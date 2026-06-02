-- Fix: "column reference \"tag_id\" is ambiguous" in public.create_recipe.
-- The plpgsql variable `tag_id` collided with public.recipe_tags.tag_id in the
-- INSERT ... ON CONFLICT statement, aborting the whole (atomic) RPC so no
-- recipe was ever saved. Prefix all local variables with v_ to remove any
-- variable/column name collision.

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
  v_profile_id uuid;
  v_recipe_id uuid;
  v_tag_value text;
  v_tag_display_name text;
  v_tag_slug text;
  v_tag_id uuid;
begin
  if (select auth.uid()) is null then
    raise exception 'Login required' using errcode = '28000';
  end if;

  select id
  into v_profile_id
  from public.profiles
  where auth_user_id = (select auth.uid())
    and not is_deleted
  limit 1;

  if v_profile_id is null then
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
    v_profile_id,
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
  returning id into v_recipe_id;

  insert into public.recipe_ingredients (recipe_id, position, content)
  select v_recipe_id, (row_number() over ())::integer, content
  from (
    select nullif(btrim(value), '') as content
    from unnest(coalesce(p_ingredients, array[]::text[])) as input(value)
  ) as cleaned
  where content is not null;

  insert into public.recipe_instructions (recipe_id, step_number, content)
  select v_recipe_id, (row_number() over ())::integer, content
  from (
    select nullif(btrim(value), '') as content
    from unnest(coalesce(p_instructions, array[]::text[])) as input(value)
  ) as cleaned
  where content is not null;

  if not exists (
    select 1 from public.recipe_ingredients where recipe_id = v_recipe_id
  ) then
    raise exception 'At least one ingredient is required' using errcode = '23514';
  end if;

  if not exists (
    select 1 from public.recipe_instructions where recipe_id = v_recipe_id
  ) then
    raise exception 'At least one instruction is required' using errcode = '23514';
  end if;

  for v_tag_value in
    select distinct nullif(btrim(value), '')
    from unnest(coalesce(p_tags, array[]::text[])) as input(value)
  loop
    if v_tag_value is null then
      continue;
    end if;

    v_tag_display_name := left(v_tag_value, 80);
    v_tag_slug := lower(regexp_replace(regexp_replace(v_tag_display_name, '^#', ''), '[^a-zA-Z0-9]+', '-', 'g'));
    v_tag_slug := regexp_replace(v_tag_slug, '(^-+|-+$)', '', 'g');

    if v_tag_slug is null or v_tag_slug = '' then
      continue;
    end if;

    insert into public.tags (display_name, slug, is_active)
    values (v_tag_display_name, v_tag_slug, true)
    on conflict (slug) do nothing;

    select id
    into v_tag_id
    from public.tags
    where slug = v_tag_slug
    limit 1;

    if v_tag_id is not null then
      insert into public.recipe_tags (recipe_id, tag_id)
      values (v_recipe_id, v_tag_id)
      on conflict (recipe_id, tag_id) do nothing;
    end if;
  end loop;

  return v_recipe_id;
end;
$$;

notify pgrst, 'reload schema';
