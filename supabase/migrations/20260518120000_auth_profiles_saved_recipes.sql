alter table public.profiles
  add column if not exists auth_user_id uuid unique;

drop policy if exists "Users can create own profile" on public.profiles;
create policy "Users can create own profile"
  on public.profiles
  for insert
  to authenticated
  with check (auth.uid() = auth_user_id);

drop policy if exists "Users can update own profile" on public.profiles;
create policy "Users can update own profile"
  on public.profiles
  for update
  to authenticated
  using (auth.uid() = auth_user_id)
  with check (auth.uid() = auth_user_id);

create table if not exists public.user_saved_recipes (
  user_id uuid not null references auth.users(id) on delete cascade,
  recipe_id uuid not null references public.recipes(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (user_id, recipe_id)
);

create index if not exists user_saved_recipes_recipe_id_idx
  on public.user_saved_recipes(recipe_id);

alter table public.user_saved_recipes enable row level security;

drop policy if exists "Users can read own saved recipes" on public.user_saved_recipes;
create policy "Users can read own saved recipes"
  on public.user_saved_recipes
  for select
  to authenticated
  using (auth.uid() = user_id);

drop policy if exists "Users can save recipes" on public.user_saved_recipes;
create policy "Users can save recipes"
  on public.user_saved_recipes
  for insert
  to authenticated
  with check (auth.uid() = user_id);

drop policy if exists "Users can remove own saved recipes" on public.user_saved_recipes;
create policy "Users can remove own saved recipes"
  on public.user_saved_recipes
  for delete
  to authenticated
  using (auth.uid() = user_id);

grant insert, update on public.profiles to authenticated;
grant select, insert, delete on public.user_saved_recipes to authenticated;
