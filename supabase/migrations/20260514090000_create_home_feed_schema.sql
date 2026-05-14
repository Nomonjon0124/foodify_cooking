create table if not exists public.profiles (
  id uuid primary key default gen_random_uuid(),
  auth_user_id uuid unique,
  display_name text not null,
  avatar_url text,
  rating numeric(2, 1) check (rating is null or (rating >= 0 and rating <= 5)),
  created_at timestamptz not null default now()
);

create table if not exists public.recipes (
  id uuid primary key default gen_random_uuid(),
  author_id uuid references public.profiles(id) on delete set null,
  title text not null,
  description text,
  rating numeric(2, 1) not null check (rating >= 0 and rating <= 5),
  duration_minutes integer check (duration_minutes is null or duration_minutes > 0),
  difficulty text check (
    difficulty is null or difficulty in ('Simple', 'Medium', 'Hard')
  ),
  cover_image_url text not null,
  overlay_image_url text,
  created_at timestamptz not null default now()
);

create table if not exists public.home_feed_items (
  id uuid primary key default gen_random_uuid(),
  recipe_id uuid not null references public.recipes(id) on delete cascade,
  section text not null check (section in ('popular', 'latest')),
  sort_order integer not null,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  unique (section, sort_order)
);

create index if not exists recipes_author_id_idx
  on public.recipes(author_id);

create index if not exists home_feed_items_section_sort_order_idx
  on public.home_feed_items(section, sort_order)
  where is_active;

alter table public.profiles enable row level security;
alter table public.recipes enable row level security;
alter table public.home_feed_items enable row level security;

drop policy if exists "Profiles are publicly readable" on public.profiles;
create policy "Profiles are publicly readable"
  on public.profiles
  for select
  to anon, authenticated
  using (true);

drop policy if exists "Recipes are publicly readable" on public.recipes;
create policy "Recipes are publicly readable"
  on public.recipes
  for select
  to anon, authenticated
  using (true);

drop policy if exists "Home feed is publicly readable" on public.home_feed_items;
create policy "Home feed is publicly readable"
  on public.home_feed_items
  for select
  to anon, authenticated
  using (is_active);

grant usage on schema public to anon, authenticated;
grant select on public.profiles to anon, authenticated;
grant select on public.recipes to anon, authenticated;
grant select on public.home_feed_items to anon, authenticated;
