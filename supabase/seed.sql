insert into public.profiles (id, display_name, avatar_url, rating)
values
  (
    '11111111-1111-4111-8111-111111111111',
    'Kelly Mayer',
    'https://zxhtseztegvzxvhxbqfj.supabase.co/storage/v1/object/public/recipe-images/home/authors/kelly-mayer.png',
    4.9
  ),
  (
    '22222222-2222-4222-8222-222222222222',
    'Rick Dolynsky',
    'https://zxhtseztegvzxvhxbqfj.supabase.co/storage/v1/object/public/recipe-images/home/authors/rick-dolynsky.png',
    4.4
  ),
  (
    '33333333-3333-4333-8333-333333333333',
    'Dave Robert',
    'https://zxhtseztegvzxvhxbqfj.supabase.co/storage/v1/object/public/recipe-images/home/authors/dave-robert.png',
    5.0
  )
on conflict (id) do update set
  display_name = excluded.display_name,
  avatar_url = excluded.avatar_url,
  rating = excluded.rating;

insert into public.recipes (
  id,
  author_id,
  title,
  description,
  rating,
  duration_minutes,
  difficulty,
  cover_image_url,
  overlay_image_url
)
values
  (
    'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaa1',
    null,
    'chocolate ice cream buttercream fruit',
    null,
    4.8,
    null,
    null,
    'https://zxhtseztegvzxvhxbqfj.supabase.co/storage/v1/object/public/recipe-images/home/popular/chocolate-ice-cream-buttercream-fruit.png',
    null
  ),
  (
    'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaa2',
    null,
    'chocolate cake with buttercream frosting',
    null,
    4.8,
    null,
    null,
    'https://zxhtseztegvzxvhxbqfj.supabase.co/storage/v1/object/public/recipe-images/home/popular/chocolate-cake-buttercream-frosting.png',
    null
  ),
  (
    'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaa3',
    null,
    'Italian pineapple pizza',
    null,
    4.8,
    null,
    null,
    'https://zxhtseztegvzxvhxbqfj.supabase.co/storage/v1/object/public/recipe-images/home/popular/italian-pineapple-pizza.png',
    null
  ),
  (
    'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbb1',
    '11111111-1111-4111-8111-111111111111',
    'Frosted pinecone cake',
    'In a large bowl, mix together flour, baking powder, sugar, and salt..',
    4.8,
    30,
    'Medium',
    'https://zxhtseztegvzxvhxbqfj.supabase.co/storage/v1/object/public/recipe-images/home/latest/main-card-content.png',
    'https://zxhtseztegvzxvhxbqfj.supabase.co/storage/v1/object/public/recipe-images/home/latest/frosted-pinecone-cake-overlay.png'
  ),
  (
    'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbb2',
    '22222222-2222-4222-8222-222222222222',
    'Classic Victoria sandwich recip...',
    'In a large bowl, mix together flour, baking powder, sugar, and salt..',
    3.8,
    120,
    'Simple',
    'https://zxhtseztegvzxvhxbqfj.supabase.co/storage/v1/object/public/recipe-images/home/latest/main-card-content.png',
    'https://zxhtseztegvzxvhxbqfj.supabase.co/storage/v1/object/public/recipe-images/home/latest/classic-victoria-sandwich-overlay.png'
  ),
  (
    'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbb3',
    '33333333-3333-4333-8333-333333333333',
    'Pea and Ricotta Omelets',
    'In a large bowl, mix together flour, baking powder, sugar, and salt..',
    4.5,
    15,
    'Hard',
    'https://zxhtseztegvzxvhxbqfj.supabase.co/storage/v1/object/public/recipe-images/home/latest/main-card-content.png',
    'https://zxhtseztegvzxvhxbqfj.supabase.co/storage/v1/object/public/recipe-images/home/latest/pea-ricotta-omelets-overlay.png'
  )
on conflict (id) do update set
  author_id = excluded.author_id,
  title = excluded.title,
  description = excluded.description,
  rating = excluded.rating,
  duration_minutes = excluded.duration_minutes,
  difficulty = excluded.difficulty,
  cover_image_url = excluded.cover_image_url,
  overlay_image_url = excluded.overlay_image_url;

insert into public.home_feed_items (
  id,
  recipe_id,
  section,
  sort_order,
  is_active
)
values
  (
    'cccccccc-cccc-4ccc-8ccc-ccccccccccc1',
    'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaa1',
    'popular',
    1,
    true
  ),
  (
    'cccccccc-cccc-4ccc-8ccc-ccccccccccc2',
    'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaa2',
    'popular',
    2,
    true
  ),
  (
    'cccccccc-cccc-4ccc-8ccc-ccccccccccc3',
    'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaa3',
    'popular',
    3,
    true
  ),
  (
    'dddddddd-dddd-4ddd-8ddd-ddddddddddd1',
    'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbb1',
    'latest',
    1,
    true
  ),
  (
    'dddddddd-dddd-4ddd-8ddd-ddddddddddd2',
    'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbb2',
    'latest',
    2,
    true
  ),
  (
    'dddddddd-dddd-4ddd-8ddd-ddddddddddd3',
    'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbb3',
    'latest',
    3,
    true
  )
on conflict (id) do update set
  recipe_id = excluded.recipe_id,
  section = excluded.section,
  sort_order = excluded.sort_order,
  is_active = excluded.is_active;
