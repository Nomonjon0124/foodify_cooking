-- Recipe AI analyses cache.
-- Stores Gemini-generated nutrition + health-score JSON keyed by
-- (recipe_id, locale, input_hash) so repeated calls hit cache instead of API.
-- Only the Edge Function (service role) writes; everyone reads.

create table if not exists public.recipe_ai_analyses (
  id uuid primary key default gen_random_uuid(),
  recipe_id uuid not null references public.recipes(id) on delete cascade,
  locale text not null check (locale in ('uz', 'en', 'ru')),
  input_hash text not null,
  model text not null,
  analysis jsonb not null,
  created_at timestamptz not null default now(),
  unique (recipe_id, locale, input_hash)
);

create index if not exists recipe_ai_analyses_recipe_locale_idx
  on public.recipe_ai_analyses (recipe_id, locale);

alter table public.recipe_ai_analyses enable row level security;

-- Cached analyses are non-sensitive aggregate data; public read is OK.
drop policy if exists "recipe_ai_analyses_select_all" on public.recipe_ai_analyses;
create policy "recipe_ai_analyses_select_all"
  on public.recipe_ai_analyses
  for select
  using (true);

-- No insert/update/delete policies: only service role (Edge Function) writes.

grant select on public.recipe_ai_analyses to anon, authenticated;
