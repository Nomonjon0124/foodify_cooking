create schema if not exists private;

revoke all on schema private from public;
revoke all on schema private from anon;
revoke all on schema private from authenticated;

alter table public.profiles
  add column if not exists first_name text,
  add column if not exists last_name text,
  add column if not exists updated_at timestamptz not null default now(),
  add column if not exists is_deleted boolean not null default false,
  add column if not exists deleted_at timestamptz;

do $$
begin
  if not exists (
    select 1
    from pg_constraint
    where conname = 'profiles_auth_user_id_fkey'
      and conrelid = 'public.profiles'::regclass
  ) then
    alter table public.profiles
      add constraint profiles_auth_user_id_fkey
      foreign key (auth_user_id)
      references auth.users(id)
      on delete set null;
  end if;

  if not exists (
    select 1
    from pg_constraint
    where conname = 'profiles_counts_nonnegative_check'
      and conrelid = 'public.profiles'::regclass
  ) then
    alter table public.profiles
      add constraint profiles_counts_nonnegative_check
      check (
        followers_count >= 0
        and following_count >= 0
        and posts_count >= 0
      );
  end if;

  if not exists (
    select 1
    from pg_constraint
    where conname = 'profiles_deleted_at_check'
      and conrelid = 'public.profiles'::regclass
  ) then
    alter table public.profiles
      add constraint profiles_deleted_at_check
      check (
        (is_deleted = false and deleted_at is null)
        or (is_deleted = true and deleted_at is not null)
      );
  end if;
end $$;

update public.profiles
set
  first_name = coalesce(
    nullif(btrim(first_name), ''),
    nullif(split_part(display_name, ' ', 1), ''),
    'Foodify'
  ),
  last_name = coalesce(
    nullif(btrim(last_name), ''),
    nullif(
      btrim(substr(display_name, length(split_part(display_name, ' ', 1)) + 1)),
      ''
    )
  ),
  updated_at = coalesce(updated_at, created_at, now())
where first_name is null
  or btrim(first_name) = ''
  or updated_at is null;

drop index if exists public.profiles_slug_unique_idx;

create unique index if not exists profiles_slug_unique_idx
  on public.profiles(slug)
  where slug is not null and not is_deleted;

create index if not exists profiles_auth_user_id_idx
  on public.profiles(auth_user_id)
  where auth_user_id is not null;

create index if not exists profiles_active_slug_idx
  on public.profiles(slug)
  where not is_deleted;

create or replace function private.normalize_profile_slug(raw_slug text)
returns text
language plpgsql
immutable
set search_path = public
as $$
declare
  normalized text;
begin
  normalized := lower(regexp_replace(coalesce(raw_slug, ''), '[^a-zA-Z0-9]+', '-', 'g'));
  normalized := regexp_replace(normalized, '(^-+|-+$)', '', 'g');
  return nullif(normalized, '');
end;
$$;

create or replace function private.unique_profile_slug(raw_slug text, profile_id uuid)
returns text
language plpgsql
set search_path = public
as $$
declare
  base_slug text;
  candidate text;
  suffix integer := 2;
begin
  base_slug := coalesce(private.normalize_profile_slug(raw_slug), 'user');
  candidate := base_slug;

  while exists (
    select 1
    from public.profiles
    where slug = candidate
      and id is distinct from profile_id
      and not is_deleted
  ) loop
    candidate := base_slug || '-' || suffix::text;
    suffix := suffix + 1;
  end loop;

  return candidate;
end;
$$;

create or replace function private.sync_profile_identity_fields()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  composed_name text;
begin
  new.first_name := nullif(btrim(new.first_name), '');
  new.last_name := nullif(btrim(new.last_name), '');

  composed_name := nullif(btrim(concat_ws(' ', new.first_name, new.last_name)), '');
  new.display_name := coalesce(
    composed_name,
    nullif(btrim(new.display_name), ''),
    'Foodify User'
  );

  if new.slug is null or btrim(new.slug) = '' then
    new.slug := private.unique_profile_slug(new.display_name, new.id);
  elsif tg_op = 'INSERT' or new.slug is distinct from old.slug then
    new.slug := private.unique_profile_slug(new.slug, new.id);
  end if;

  if new.is_deleted and new.deleted_at is null then
    new.deleted_at := now();
  end if;

  if not new.is_deleted then
    new.deleted_at := null;
  end if;

  new.updated_at := now();
  return new;
end;
$$;

drop trigger if exists sync_profile_identity_fields on public.profiles;
create trigger sync_profile_identity_fields
  before insert or update on public.profiles
  for each row execute function private.sync_profile_identity_fields();

create table if not exists public.profile_follows (
  follower_profile_id uuid not null references public.profiles(id) on delete cascade,
  following_profile_id uuid not null references public.profiles(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (follower_profile_id, following_profile_id),
  constraint profile_follows_no_self_follow_check
    check (follower_profile_id <> following_profile_id)
);

create index if not exists profile_follows_following_profile_id_idx
  on public.profile_follows(following_profile_id);

alter table public.profile_follows enable row level security;

create or replace function private.refresh_profile_follow_counts(profile_id uuid)
returns void
language sql
security definer
set search_path = public
as $$
  update public.profiles
  set
    followers_count = (
      select count(*)::integer
      from public.profile_follows
      where following_profile_id = profile_id
    ),
    following_count = (
      select count(*)::integer
      from public.profile_follows
      where follower_profile_id = profile_id
    ),
    updated_at = now()
  where id = profile_id;
$$;

create or replace function private.refresh_profile_follow_counts_trigger()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if tg_op = 'INSERT' then
    perform private.refresh_profile_follow_counts(new.follower_profile_id);
    perform private.refresh_profile_follow_counts(new.following_profile_id);
    return new;
  end if;

  if tg_op = 'DELETE' then
    perform private.refresh_profile_follow_counts(old.follower_profile_id);
    perform private.refresh_profile_follow_counts(old.following_profile_id);
    return old;
  end if;

  return null;
end;
$$;

drop trigger if exists refresh_profile_follow_counts on public.profile_follows;
create trigger refresh_profile_follow_counts
  after insert or delete on public.profile_follows
  for each row execute function private.refresh_profile_follow_counts_trigger();

create or replace function private.refresh_profile_recipe_stats(profile_id uuid)
returns void
language sql
security definer
set search_path = public
as $$
  update public.profiles
  set
    posts_count = (
      select count(*)::integer
      from public.recipes
      where author_id = profile_id
        and is_profile_visible
    ),
    rating = coalesce((
      select round(avg(rating)::numeric, 1)
      from public.recipes
      where author_id = profile_id
        and is_profile_visible
    ), 0),
    updated_at = now()
  where id = profile_id;
$$;

create or replace function private.refresh_profile_recipe_stats_trigger()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if tg_op = 'INSERT' then
    if new.author_id is not null then
      perform private.refresh_profile_recipe_stats(new.author_id);
    end if;
    return new;
  end if;

  if tg_op = 'UPDATE' then
    if old.author_id is not null then
      perform private.refresh_profile_recipe_stats(old.author_id);
    end if;
    if new.author_id is not null and new.author_id is distinct from old.author_id then
      perform private.refresh_profile_recipe_stats(new.author_id);
    elsif new.author_id is not null then
      perform private.refresh_profile_recipe_stats(new.author_id);
    end if;
    return new;
  end if;

  if tg_op = 'DELETE' then
    if old.author_id is not null then
      perform private.refresh_profile_recipe_stats(old.author_id);
    end if;
    return old;
  end if;

  return null;
end;
$$;

drop trigger if exists refresh_profile_recipe_stats on public.recipes;
create trigger refresh_profile_recipe_stats
  after insert or update of author_id, rating, is_profile_visible or delete on public.recipes
  for each row execute function private.refresh_profile_recipe_stats_trigger();

create or replace function private.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  metadata jsonb := coalesce(new.raw_user_meta_data, '{}'::jsonb);
  full_name text;
  fallback_name text;
  given_name text;
  family_name text;
  avatar text;
begin
  full_name := coalesce(
    nullif(btrim(metadata ->> 'full_name'), ''),
    nullif(btrim(metadata ->> 'name'), ''),
    nullif(btrim(metadata ->> 'display_name'), '')
  );
  fallback_name := coalesce(nullif(split_part(new.email, '@', 1), ''), 'Foodify User');
  given_name := coalesce(
    nullif(btrim(metadata ->> 'first_name'), ''),
    nullif(btrim(metadata ->> 'given_name'), ''),
    nullif(split_part(coalesce(full_name, fallback_name), ' ', 1), ''),
    fallback_name
  );
  family_name := coalesce(
    nullif(btrim(metadata ->> 'last_name'), ''),
    nullif(btrim(metadata ->> 'family_name'), ''),
    nullif(
      btrim(substr(coalesce(full_name, ''), length(split_part(coalesce(full_name, ''), ' ', 1)) + 1)),
      ''
    )
  );
  avatar := coalesce(
    nullif(btrim(metadata ->> 'avatar_url'), ''),
    nullif(btrim(metadata ->> 'picture'), '')
  );

  insert into public.profiles (
    auth_user_id,
    first_name,
    last_name,
    display_name,
    avatar_url
  )
  values (
    new.id,
    given_name,
    family_name,
    coalesce(full_name, nullif(btrim(concat_ws(' ', given_name, family_name)), ''), fallback_name),
    avatar
  )
  on conflict (auth_user_id) do nothing;

  return new;
end;
$$;

revoke all on function private.handle_new_user() from public;
revoke all on function private.handle_new_user() from anon;
revoke all on function private.handle_new_user() from authenticated;

insert into public.profiles (
  auth_user_id,
  first_name,
  last_name,
  display_name,
  avatar_url
)
select
  auth_users.id,
  coalesce(
    nullif(btrim(auth_users.raw_user_meta_data ->> 'first_name'), ''),
    nullif(btrim(auth_users.raw_user_meta_data ->> 'given_name'), ''),
    nullif(split_part(coalesce(auth_users.raw_user_meta_data ->> 'full_name', auth_users.raw_user_meta_data ->> 'name', split_part(auth_users.email, '@', 1)), ' ', 1), ''),
    'Foodify'
  ),
  coalesce(
    nullif(btrim(auth_users.raw_user_meta_data ->> 'last_name'), ''),
    nullif(btrim(auth_users.raw_user_meta_data ->> 'family_name'), '')
  ),
  coalesce(
    nullif(btrim(auth_users.raw_user_meta_data ->> 'full_name'), ''),
    nullif(btrim(auth_users.raw_user_meta_data ->> 'name'), ''),
    nullif(btrim(auth_users.raw_user_meta_data ->> 'display_name'), ''),
    split_part(auth_users.email, '@', 1),
    'Foodify User'
  ),
  coalesce(
    nullif(btrim(auth_users.raw_user_meta_data ->> 'avatar_url'), ''),
    nullif(btrim(auth_users.raw_user_meta_data ->> 'picture'), '')
  )
from auth.users as auth_users
where not exists (
  select 1
  from public.profiles
  where profiles.auth_user_id = auth_users.id
)
on conflict (auth_user_id) do nothing;

update public.profiles as profile
set
  followers_count = (
    select count(*)::integer
    from public.profile_follows
    where following_profile_id = profile.id
  ),
  following_count = (
    select count(*)::integer
    from public.profile_follows
    where follower_profile_id = profile.id
  );

update public.profiles as profile
set
  posts_count = recipe_stats.posts_count,
  rating = recipe_stats.rating
from (
  select
    p.id,
    count(r.id)::integer as posts_count,
    coalesce(round(avg(r.rating)::numeric, 1), 0) as rating
  from public.profiles p
  left join public.recipes r
    on r.author_id = p.id
    and r.is_profile_visible
  group by p.id
) as recipe_stats
where profile.id = recipe_stats.id;

drop policy if exists "Profiles are publicly readable" on public.profiles;
create policy "Profiles are publicly readable"
  on public.profiles
  for select
  to anon, authenticated
  using (not is_deleted);

drop policy if exists "Users can create own profile" on public.profiles;
create policy "Users can create own profile"
  on public.profiles
  for insert
  to authenticated
  with check ((select auth.uid()) = auth_user_id and not is_deleted);

drop policy if exists "Users can update own profile" on public.profiles;
create policy "Users can update own profile"
  on public.profiles
  for update
  to authenticated
  using ((select auth.uid()) = auth_user_id and not is_deleted)
  with check ((select auth.uid()) = auth_user_id and not is_deleted);

drop policy if exists "Profile follows are publicly readable" on public.profile_follows;
create policy "Profile follows are publicly readable"
  on public.profile_follows
  for select
  to anon, authenticated
  using (
    exists (
      select 1 from public.profiles follower
      where follower.id = follower_profile_id and not follower.is_deleted
    )
    and exists (
      select 1 from public.profiles following
      where following.id = following_profile_id and not following.is_deleted
    )
  );

drop policy if exists "Users can follow active profiles" on public.profile_follows;
create policy "Users can follow active profiles"
  on public.profile_follows
  for insert
  to authenticated
  with check (
    exists (
      select 1
      from public.profiles follower
      where follower.id = follower_profile_id
        and follower.auth_user_id = (select auth.uid())
        and not follower.is_deleted
    )
    and exists (
      select 1
      from public.profiles following
      where following.id = following_profile_id
        and not following.is_deleted
    )
  );

drop policy if exists "Users can unfollow from own profile" on public.profile_follows;
create policy "Users can unfollow from own profile"
  on public.profile_follows
  for delete
  to authenticated
  using (
    exists (
      select 1
      from public.profiles follower
      where follower.id = follower_profile_id
        and follower.auth_user_id = (select auth.uid())
        and not follower.is_deleted
    )
  );

insert into storage.buckets (
  id,
  name,
  public,
  file_size_limit,
  allowed_mime_types
)
values (
  'profile-media',
  'profile-media',
  true,
  10485760,
  array['image/png', 'image/jpeg', 'image/webp']
)
on conflict (id) do update set
  public = excluded.public,
  file_size_limit = excluded.file_size_limit,
  allowed_mime_types = excluded.allowed_mime_types;

drop policy if exists "Profile media is publicly readable" on storage.objects;
create policy "Profile media is publicly readable"
  on storage.objects
  for select
  to anon, authenticated
  using (bucket_id = 'profile-media');

drop policy if exists "Users can upload own profile media" on storage.objects;
create policy "Users can upload own profile media"
  on storage.objects
  for insert
  to authenticated
  with check (
    bucket_id = 'profile-media'
    and (storage.foldername(name))[1] = (select auth.uid())::text
    and (storage.foldername(name))[2] in ('avatar', 'cover')
  );

drop policy if exists "Users can update own profile media" on storage.objects;
create policy "Users can update own profile media"
  on storage.objects
  for update
  to authenticated
  using (
    bucket_id = 'profile-media'
    and owner_id = (select auth.uid())::text
    and (storage.foldername(name))[1] = (select auth.uid())::text
    and (storage.foldername(name))[2] in ('avatar', 'cover')
  )
  with check (
    bucket_id = 'profile-media'
    and (storage.foldername(name))[1] = (select auth.uid())::text
    and (storage.foldername(name))[2] in ('avatar', 'cover')
  );

drop policy if exists "Users can delete own profile media" on storage.objects;
create policy "Users can delete own profile media"
  on storage.objects
  for delete
  to authenticated
  using (
    bucket_id = 'profile-media'
    and owner_id = (select auth.uid())::text
    and (storage.foldername(name))[1] = (select auth.uid())::text
    and (storage.foldername(name))[2] in ('avatar', 'cover')
  );

drop view if exists public.profile_recipes_view;
drop view if exists public.profile_page_view;

create view public.profile_page_view
with (security_invoker = true)
as
select
  profiles.id,
  profiles.slug,
  profiles.display_name,
  profiles.first_name,
  profiles.last_name,
  profiles.location,
  profiles.bio,
  profiles.avatar_url,
  profiles.cover_image_url,
  profiles.rating,
  profiles.followers_count,
  profiles.following_count,
  profiles.posts_count,
  coalesce((select auth.uid()) = profiles.auth_user_id, false) as is_current_user,
  profiles.created_at,
  profiles.updated_at
from public.profiles
where not profiles.is_deleted;

create view public.profile_recipes_view
with (security_invoker = true)
as
select
  recipes.id,
  recipes.author_id,
  recipes.title,
  recipes.description,
  recipes.rating,
  recipes.duration_minutes,
  recipes.difficulty,
  recipes.cover_image_url,
  recipes.search_sort_order,
  recipes.created_at,
  profiles.display_name as chef_name,
  profiles.avatar_url as chef_avatar_url
from public.recipes
join public.profiles
  on profiles.id = recipes.author_id
where recipes.is_profile_visible
  and not profiles.is_deleted;

revoke all privileges on public.profiles from public;
revoke all privileges on public.profiles from anon;
revoke all privileges on public.profiles from authenticated;
revoke all privileges on public.recipes from public;
revoke all privileges on public.recipes from anon;
revoke all privileges on public.recipes from authenticated;
revoke all privileges on public.profile_follows from public;
revoke all privileges on public.profile_follows from anon;
revoke all privileges on public.profile_follows from authenticated;

grant usage on schema public to anon, authenticated;

grant select on public.profiles to anon, authenticated;
grant insert (
  auth_user_id,
  first_name,
  last_name,
  display_name,
  slug,
  bio,
  location,
  avatar_url,
  cover_image_url
) on public.profiles to authenticated;
grant update (
  first_name,
  last_name,
  slug,
  bio,
  location,
  avatar_url,
  cover_image_url
) on public.profiles to authenticated;

grant select on public.recipes to anon, authenticated;
grant select on public.profile_follows to anon, authenticated;
grant insert, delete on public.profile_follows to authenticated;
grant select on public.profile_page_view to anon, authenticated;
grant select on public.profile_recipes_view to anon, authenticated;

notify pgrst, 'reload schema';
