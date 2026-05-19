-- Auto-create a public.profiles row whenever a new auth.users row appears.
-- Fires on sign-up regardless of whether the user has confirmed their email,
-- so RLS-guarded queries that join on auth_user_id always find a profile.

create schema if not exists private;

revoke all on schema private from public;
revoke all on schema private from anon;
revoke all on schema private from authenticated;

drop trigger if exists on_auth_user_created on auth.users;
drop function if exists public.handle_new_user();

create or replace function private.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  display text;
  avatar text;
begin
  display := coalesce(
    nullif(trim(new.raw_user_meta_data ->> 'full_name'), ''),
    nullif(trim(new.raw_user_meta_data ->> 'name'), ''),
    nullif(trim(new.raw_user_meta_data ->> 'display_name'), ''),
    split_part(new.email, '@', 1),
    'User'
  );
  avatar := coalesce(
    nullif(trim(new.raw_user_meta_data ->> 'avatar_url'), ''),
    nullif(trim(new.raw_user_meta_data ->> 'picture'), '')
  );

  insert into public.profiles (auth_user_id, display_name, avatar_url)
  values (new.id, display, avatar)
  on conflict (auth_user_id) do nothing;

  return new;
end;
$$;

revoke all on function private.handle_new_user() from public;
revoke all on function private.handle_new_user() from anon;
revoke all on function private.handle_new_user() from authenticated;

insert into public.profiles (auth_user_id, display_name, avatar_url)
select
  auth_users.id,
  coalesce(
    nullif(trim(auth_users.raw_user_meta_data ->> 'full_name'), ''),
    nullif(trim(auth_users.raw_user_meta_data ->> 'name'), ''),
    nullif(trim(auth_users.raw_user_meta_data ->> 'display_name'), ''),
    split_part(auth_users.email, '@', 1),
    'User'
  ) as display_name,
  coalesce(
    nullif(trim(auth_users.raw_user_meta_data ->> 'avatar_url'), ''),
    nullif(trim(auth_users.raw_user_meta_data ->> 'picture'), '')
  ) as avatar_url
from auth.users as auth_users
where not exists (
  select 1
  from public.profiles
  where profiles.auth_user_id = auth_users.id
)
on conflict (auth_user_id) do nothing;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function private.handle_new_user();
