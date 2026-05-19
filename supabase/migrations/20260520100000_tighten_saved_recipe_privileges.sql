revoke all privileges on table public.user_saved_recipes from public;
revoke all privileges on table public.user_saved_recipes from anon;
revoke all privileges on table public.user_saved_recipes from authenticated;

grant select, insert, update, delete on table public.user_saved_recipes
  to authenticated;
