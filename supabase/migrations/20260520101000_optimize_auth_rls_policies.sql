drop policy if exists "Users can create own profile" on public.profiles;
create policy "Users can create own profile"
  on public.profiles
  for insert
  to authenticated
  with check ((select auth.uid()) = auth_user_id);

drop policy if exists "Users can update own profile" on public.profiles;
create policy "Users can update own profile"
  on public.profiles
  for update
  to authenticated
  using ((select auth.uid()) = auth_user_id)
  with check ((select auth.uid()) = auth_user_id);

drop policy if exists "Users can read own saved recipes" on public.user_saved_recipes;
create policy "Users can read own saved recipes"
  on public.user_saved_recipes
  for select
  to authenticated
  using ((select auth.uid()) = user_id);

drop policy if exists "Users can save recipes" on public.user_saved_recipes;
create policy "Users can save recipes"
  on public.user_saved_recipes
  for insert
  to authenticated
  with check ((select auth.uid()) = user_id);

drop policy if exists "Users can keep own saved recipes" on public.user_saved_recipes;
create policy "Users can keep own saved recipes"
  on public.user_saved_recipes
  for update
  to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

drop policy if exists "Users can remove own saved recipes" on public.user_saved_recipes;
create policy "Users can remove own saved recipes"
  on public.user_saved_recipes
  for delete
  to authenticated
  using ((select auth.uid()) = user_id);
