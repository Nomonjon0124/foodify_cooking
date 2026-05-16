alter table public.profiles
  add column if not exists slug text,
  add column if not exists location text,
  add column if not exists bio text,
  add column if not exists cover_image_url text,
  add column if not exists followers_count integer not null default 0,
  add column if not exists following_count integer not null default 0,
  add column if not exists posts_count integer not null default 0,
  add column if not exists is_search_featured boolean not null default false,
  add column if not exists search_sort_order integer;

alter table public.recipes
  add column if not exists is_search_featured boolean not null default false,
  add column if not exists search_sort_order integer,
  add column if not exists is_profile_visible boolean not null default true;

create unique index if not exists profiles_slug_unique_idx
  on public.profiles(slug)
  where slug is not null;

create index if not exists profiles_search_featured_idx
  on public.profiles(search_sort_order, display_name)
  where is_search_featured;

create index if not exists recipes_search_featured_idx
  on public.recipes(search_sort_order, title)
  where is_search_featured;

create index if not exists recipes_profile_visible_idx
  on public.recipes(author_id, search_sort_order)
  where is_profile_visible;

create table if not exists public.tags (
  id uuid primary key default gen_random_uuid(),
  display_name text not null unique,
  slug text not null unique,
  sort_order integer,
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists public.recipe_tags (
  recipe_id uuid not null references public.recipes(id) on delete cascade,
  tag_id uuid not null references public.tags(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (recipe_id, tag_id)
);

create index if not exists tags_active_sort_order_idx
  on public.tags(sort_order, display_name)
  where is_active;

create index if not exists recipe_tags_tag_id_idx
  on public.recipe_tags(tag_id);

alter table public.tags enable row level security;
alter table public.recipe_tags enable row level security;

drop policy if exists "Tags are publicly readable" on public.tags;
create policy "Tags are publicly readable"
  on public.tags
  for select
  to anon, authenticated
  using (is_active);

drop policy if exists "Recipe tags are publicly readable" on public.recipe_tags;
create policy "Recipe tags are publicly readable"
  on public.recipe_tags
  for select
  to anon, authenticated
  using (true);

grant select on public.tags to anon, authenticated;
grant select on public.recipe_tags to anon, authenticated;
