insert into storage.buckets (
  id,
  name,
  public,
  file_size_limit,
  allowed_mime_types
)
values (
  'recipe-images',
  'recipe-images',
  true,
  10485760,
  array['image/png', 'image/jpeg', 'image/webp']
)
on conflict (id) do update set
  public = excluded.public,
  file_size_limit = excluded.file_size_limit,
  allowed_mime_types = excluded.allowed_mime_types;

drop policy if exists "Recipe images are publicly readable" on storage.objects;
create policy "Recipe images are publicly readable"
  on storage.objects
  for select
  to anon, authenticated
  using (bucket_id = 'recipe-images');

drop policy if exists "Users can upload own recipe images" on storage.objects;
create policy "Users can upload own recipe images"
  on storage.objects
  for insert
  to authenticated
  with check (
    bucket_id = 'recipe-images'
    and (storage.foldername(name))[1] = 'user-recipes'
    and (storage.foldername(name))[2] = (select auth.uid())::text
  );

drop policy if exists "Users can delete own recipe images" on storage.objects;
create policy "Users can delete own recipe images"
  on storage.objects
  for delete
  to authenticated
  using (
    bucket_id = 'recipe-images'
    and owner_id = (select auth.uid())::text
    and (storage.foldername(name))[1] = 'user-recipes'
    and (storage.foldername(name))[2] = (select auth.uid())::text
  );

update public.recipes
set author_id = '44444444-4444-4444-8444-444444444444'
where author_id is null
  and exists (
    select 1
    from public.profiles
    where id = '44444444-4444-4444-8444-444444444444'
  );

update public.recipes
set
  cover_image_url = overlay_image_url,
  overlay_image_url = null
where overlay_image_url is not null
  and cover_image_url like '%/home/latest/main-card-content.png';

drop policy if exists "Users can create own recipes" on public.recipes;
create policy "Users can create own recipes"
  on public.recipes
  for insert
  to authenticated
  with check (
    author_id in (
      select id
      from public.profiles
      where auth_user_id = (select auth.uid())
        and not is_deleted
    )
    and is_profile_visible
  );

drop policy if exists "Users can create ingredients for own recipes"
  on public.recipe_ingredients;
create policy "Users can create ingredients for own recipes"
  on public.recipe_ingredients
  for insert
  to authenticated
  with check (
    exists (
      select 1
      from public.recipes
      join public.profiles on profiles.id = recipes.author_id
      where recipes.id = recipe_id
        and profiles.auth_user_id = (select auth.uid())
        and not profiles.is_deleted
    )
  );

drop policy if exists "Users can create instructions for own recipes"
  on public.recipe_instructions;
create policy "Users can create instructions for own recipes"
  on public.recipe_instructions
  for insert
  to authenticated
  with check (
    exists (
      select 1
      from public.recipes
      join public.profiles on profiles.id = recipes.author_id
      where recipes.id = recipe_id
        and profiles.auth_user_id = (select auth.uid())
        and not profiles.is_deleted
    )
  );

drop policy if exists "Users can create public tags" on public.tags;
create policy "Users can create public tags"
  on public.tags
  for insert
  to authenticated
  with check (is_active);

drop policy if exists "Users can tag own recipes" on public.recipe_tags;
create policy "Users can tag own recipes"
  on public.recipe_tags
  for insert
  to authenticated
  with check (
    exists (
      select 1
      from public.recipes
      join public.profiles on profiles.id = recipes.author_id
      where recipes.id = recipe_id
        and profiles.auth_user_id = (select auth.uid())
        and not profiles.is_deleted
    )
  );

grant insert (
  author_id,
  title,
  description,
  rating,
  duration_minutes,
  difficulty,
  cover_image_url,
  overlay_image_url,
  is_search_featured,
  is_profile_visible
) on public.recipes to authenticated;
grant insert (recipe_id, position, content)
  on public.recipe_ingredients to authenticated;
grant insert (recipe_id, step_number, content)
  on public.recipe_instructions to authenticated;
grant insert (display_name, slug, is_active)
  on public.tags to authenticated;
grant insert (recipe_id, tag_id)
  on public.recipe_tags to authenticated;

create or replace function public.create_recipe(
  p_title text,
  p_description text,
  p_duration_minutes integer,
  p_difficulty text,
  p_cover_image_url text,
  p_ingredients text[],
  p_instructions text[],
  p_tags text[] default array[]::text[]
)
returns uuid
language plpgsql
security invoker
set search_path = public, pg_temp
as $$
declare
  current_profile_id uuid;
  new_recipe_id uuid;
  tag_value text;
  tag_display_name text;
  tag_slug text;
  tag_id uuid;
begin
  if (select auth.uid()) is null then
    raise exception 'Login required' using errcode = '28000';
  end if;

  select id
  into current_profile_id
  from public.profiles
  where auth_user_id = (select auth.uid())
    and not is_deleted
  limit 1;

  if current_profile_id is null then
    raise exception 'Profile required' using errcode = '23503';
  end if;

  if nullif(btrim(p_title), '') is null then
    raise exception 'Recipe title is required' using errcode = '23514';
  end if;

  if nullif(btrim(p_cover_image_url), '') is null then
    raise exception 'Recipe cover image is required' using errcode = '23514';
  end if;

  insert into public.recipes (
    author_id,
    title,
    description,
    rating,
    duration_minutes,
    difficulty,
    cover_image_url,
    overlay_image_url,
    is_search_featured,
    is_profile_visible
  )
  values (
    current_profile_id,
    btrim(p_title),
    nullif(btrim(coalesce(p_description, '')), ''),
    0,
    case when coalesce(p_duration_minutes, 0) > 0 then p_duration_minutes else null end,
    nullif(btrim(coalesce(p_difficulty, '')), ''),
    btrim(p_cover_image_url),
    null,
    false,
    true
  )
  returning id into new_recipe_id;

  insert into public.recipe_ingredients (recipe_id, position, content)
  select new_recipe_id, (row_number() over ())::integer, content
  from (
    select nullif(btrim(value), '') as content
    from unnest(coalesce(p_ingredients, array[]::text[])) as input(value)
  ) as cleaned
  where content is not null;

  insert into public.recipe_instructions (recipe_id, step_number, content)
  select new_recipe_id, (row_number() over ())::integer, content
  from (
    select nullif(btrim(value), '') as content
    from unnest(coalesce(p_instructions, array[]::text[])) as input(value)
  ) as cleaned
  where content is not null;

  if not exists (
    select 1 from public.recipe_ingredients where recipe_id = new_recipe_id
  ) then
    raise exception 'At least one ingredient is required' using errcode = '23514';
  end if;

  if not exists (
    select 1 from public.recipe_instructions where recipe_id = new_recipe_id
  ) then
    raise exception 'At least one instruction is required' using errcode = '23514';
  end if;

  for tag_value in
    select distinct nullif(btrim(value), '')
    from unnest(coalesce(p_tags, array[]::text[])) as input(value)
  loop
    if tag_value is null then
      continue;
    end if;

    tag_display_name := left(tag_value, 80);
    tag_slug := lower(regexp_replace(regexp_replace(tag_display_name, '^#', ''), '[^a-zA-Z0-9]+', '-', 'g'));
    tag_slug := regexp_replace(tag_slug, '(^-+|-+$)', '', 'g');

    if tag_slug is null or tag_slug = '' then
      continue;
    end if;

    insert into public.tags (display_name, slug, is_active)
    values (tag_display_name, tag_slug, true)
    on conflict (slug) do nothing;

    select id
    into tag_id
    from public.tags
    where slug = tag_slug
    limit 1;

    if tag_id is not null then
      insert into public.recipe_tags (recipe_id, tag_id)
      values (new_recipe_id, tag_id)
      on conflict (recipe_id, tag_id) do nothing;
    end if;
  end loop;

  return new_recipe_id;
end;
$$;

revoke all on function public.create_recipe(
  text,
  text,
  integer,
  text,
  text,
  text[],
  text[],
  text[]
) from public;
grant execute on function public.create_recipe(
  text,
  text,
  integer,
  text,
  text,
  text[],
  text[],
  text[]
) to authenticated;

notify pgrst, 'reload schema';
