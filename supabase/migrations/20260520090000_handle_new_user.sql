-- Auto-create a public.profiles row whenever a new auth.users row appears.
-- Fires on sign-up regardless of whether the user has confirmed their email,
-- so RLS-guarded queries that join on auth_user_id always find a profile.

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  display text;
begin
  display := coalesce(
    nullif(trim(new.raw_user_meta_data ->> 'full_name'), ''),
    nullif(trim(new.raw_user_meta_data ->> 'name'), ''),
    split_part(new.email, '@', 1),
    'User'
  );

  insert into public.profiles (auth_user_id, display_name)
  values (new.id, display)
  on conflict (auth_user_id) do nothing;

  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();
