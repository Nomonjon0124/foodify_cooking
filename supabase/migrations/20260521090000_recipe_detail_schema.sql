-- Recipe detail schema: ingredients, instructions, likes, comments.
-- Likes are a separate per-user toggle (independent of user_saved_recipes).
-- Comments are read-only for the current app phase; insert policy is kept in
-- place for the next phase.

create table if not exists public.recipe_ingredients (
  id uuid primary key default gen_random_uuid(),
  recipe_id uuid not null references public.recipes(id) on delete cascade,
  position integer not null check (position > 0),
  content text not null check (char_length(content) between 1 and 500),
  created_at timestamptz not null default now(),
  unique (recipe_id, position)
);

create index if not exists recipe_ingredients_recipe_id_idx
  on public.recipe_ingredients(recipe_id, position);

create table if not exists public.recipe_instructions (
  id uuid primary key default gen_random_uuid(),
  recipe_id uuid not null references public.recipes(id) on delete cascade,
  step_number integer not null check (step_number > 0),
  content text not null check (char_length(content) between 1 and 2000),
  created_at timestamptz not null default now(),
  unique (recipe_id, step_number)
);

create index if not exists recipe_instructions_recipe_id_idx
  on public.recipe_instructions(recipe_id, step_number);

create table if not exists public.recipe_likes (
  user_id uuid not null references auth.users(id) on delete cascade,
  recipe_id uuid not null references public.recipes(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (user_id, recipe_id)
);

create index if not exists recipe_likes_recipe_id_idx
  on public.recipe_likes(recipe_id);

create table if not exists public.recipe_comments (
  id uuid primary key default gen_random_uuid(),
  recipe_id uuid not null references public.recipes(id) on delete cascade,
  author_profile_id uuid not null references public.profiles(id) on delete cascade,
  content text not null check (char_length(content) between 1 and 1000),
  created_at timestamptz not null default now()
);

create index if not exists recipe_comments_recipe_id_idx
  on public.recipe_comments(recipe_id, created_at desc);

alter table public.recipe_ingredients enable row level security;
alter table public.recipe_instructions enable row level security;
alter table public.recipe_likes enable row level security;
alter table public.recipe_comments enable row level security;

-- Public read for ingredients/instructions/comments (matches recipes policy).
drop policy if exists "Recipe ingredients are publicly readable"
  on public.recipe_ingredients;
create policy "Recipe ingredients are publicly readable"
  on public.recipe_ingredients
  for select
  to anon, authenticated
  using (true);

drop policy if exists "Recipe instructions are publicly readable"
  on public.recipe_instructions;
create policy "Recipe instructions are publicly readable"
  on public.recipe_instructions
  for select
  to anon, authenticated
  using (true);

drop policy if exists "Recipe comments are publicly readable"
  on public.recipe_comments;
create policy "Recipe comments are publicly readable"
  on public.recipe_comments
  for select
  to anon, authenticated
  using (true);

-- Likes: public read so counts are visible to anyone; writes locked to owner.
drop policy if exists "Recipe likes are publicly readable" on public.recipe_likes;
create policy "Recipe likes are publicly readable"
  on public.recipe_likes
  for select
  to anon, authenticated
  using (true);

drop policy if exists "Users can like recipes" on public.recipe_likes;
create policy "Users can like recipes"
  on public.recipe_likes
  for insert
  to authenticated
  with check ((select auth.uid()) = user_id);

drop policy if exists "Users can unlike recipes" on public.recipe_likes;
create policy "Users can unlike recipes"
  on public.recipe_likes
  for delete
  to authenticated
  using ((select auth.uid()) = user_id);

-- Comments insert policy is staged for the next phase; the app does not call it
-- yet but the policy is here so the contract is reviewable now.
drop policy if exists "Users can post own comments" on public.recipe_comments;
create policy "Users can post own comments"
  on public.recipe_comments
  for insert
  to authenticated
  with check (
    (select auth.uid()) = (
      select auth_user_id
      from public.profiles
      where id = author_profile_id
    )
  );

drop policy if exists "Users can delete own comments" on public.recipe_comments;
create policy "Users can delete own comments"
  on public.recipe_comments
  for delete
  to authenticated
  using (
    (select auth.uid()) = (
      select auth_user_id
      from public.profiles
      where id = author_profile_id
    )
  );

grant select on public.recipe_ingredients to anon, authenticated;
grant select on public.recipe_instructions to anon, authenticated;
grant select on public.recipe_likes to anon, authenticated;
grant select on public.recipe_comments to anon, authenticated;
grant insert, delete on public.recipe_likes to authenticated;
grant insert, delete on public.recipe_comments to authenticated;

-- ---------------------------------------------------------------------------
-- Seed: ingredients + instructions for every existing recipe, plus a handful
-- of comments per recipe and a few likes from real auth users.
-- The same generic 8-ingredient / 8-step pancake recipe from the Figma source
-- is used for all recipes; this is sample data that will be replaced once the
-- editor flow lands.
-- ---------------------------------------------------------------------------

with recipe_ids as (
  select id from public.recipes
), ingredient_template as (
  select * from (values
    (1, '2 cups all-purpose flour'),
    (2, '2 teaspoons baking powder'),
    (3, '2 tablespoons sugar'),
    (4, '1/2 teaspoon salt'),
    (5, '1.5 cups milk'),
    (6, '1 large egg'),
    (7, '2 tablespoons vegetable oil or melted butter'),
    (8, 'Vanilla extract (optional)')
  ) as t(position, content)
), instruction_template as (
  select * from (values
    (1, 'In a large bowl, mix together flour, baking powder, sugar, and salt.'),
    (2, 'In a separate bowl, whisk together milk, egg, and oil or melted butter. Add vanilla extract if desired.'),
    (3, 'Gradually add the liquid mixture to the dry ingredients, stirring continuously until a smooth, lump-free batter forms.'),
    (4, 'Heat a griddle or skillet over medium heat. Pour about 1 tablespoon of batter onto the griddle for each pancake.'),
    (5, 'Cook until bubbles form on the surface of the pancake and the edges look set. Flip the pancake and cook the other side until golden brown.'),
    (6, 'Repeat the process with the remaining batter.'),
    (7, 'Serve the pancakes warm with your favorite toppings such as maple syrup, honey, fresh fruits, or chocolate chips.'),
    (8, 'Enjoy your delicious homemade pancakes!')
  ) as t(step_number, content)
)
insert into public.recipe_ingredients (recipe_id, position, content)
select r.id, t.position, t.content
from recipe_ids r
cross join ingredient_template t
on conflict (recipe_id, position) do nothing;

with recipe_ids as (
  select id from public.recipes
), instruction_template as (
  select * from (values
    (1, 'In a large bowl, mix together flour, baking powder, sugar, and salt.'),
    (2, 'In a separate bowl, whisk together milk, egg, and oil or melted butter. Add vanilla extract if desired.'),
    (3, 'Gradually add the liquid mixture to the dry ingredients, stirring continuously until a smooth, lump-free batter forms.'),
    (4, 'Heat a griddle or skillet over medium heat. Pour about 1 tablespoon of batter onto the griddle for each pancake.'),
    (5, 'Cook until bubbles form on the surface of the pancake and the edges look set. Flip the pancake and cook the other side until golden brown.'),
    (6, 'Repeat the process with the remaining batter.'),
    (7, 'Serve the pancakes warm with your favorite toppings such as maple syrup, honey, fresh fruits, or chocolate chips.'),
    (8, 'Enjoy your delicious homemade pancakes!')
  ) as t(step_number, content)
)
insert into public.recipe_instructions (recipe_id, step_number, content)
select r.id, t.step_number, t.content
from recipe_ids r
cross join instruction_template t
on conflict (recipe_id, step_number) do nothing;

-- Sample comments: pick three sample comments per recipe, rotating authors
-- across the four seeded profiles (Kelly, Rick, Dave, Mark).
with recipe_ids as (
  select id, row_number() over (order by created_at, id) as rn
  from public.recipes
), comment_template as (
  select * from (values
    (1, '11111111-1111-4111-8111-111111111111'::uuid,
        'This recipe is a game-changer! The combination of spices and textures is phenomenal. I''ve already shared it with all my friends – it''s too good not to pass along!'),
    (2, '22222222-2222-4222-8222-222222222222'::uuid,
        'As a busy mom, I appreciate quick and tasty recipes. This one not only saved me time but also earned me compliments from the whole family. Winner!'),
    (3, '33333333-3333-4333-8333-333333333333'::uuid,
        'I''m always on the lookout for healthy recipes, and this one exceeded my expectations. Packed with nutrients and flavor, it''s become a regular in my weekly menu.')
  ) as t(slot, author_profile_id, content)
)
insert into public.recipe_comments (recipe_id, author_profile_id, content, created_at)
select
  r.id,
  c.author_profile_id,
  c.content,
  now() - (c.slot || ' hours')::interval - (r.rn || ' minutes')::interval
from recipe_ids r
cross join comment_template c;

-- Sample likes: every real auth user likes the first three recipes.
with recipe_ids as (
  select id, row_number() over (order by created_at, id) as rn
  from public.recipes
), auth_users as (
  select auth_user_id
  from public.profiles
  where auth_user_id is not null
)
insert into public.recipe_likes (user_id, recipe_id)
select u.auth_user_id, r.id
from auth_users u
cross join recipe_ids r
where r.rn <= 6
on conflict (user_id, recipe_id) do nothing;
