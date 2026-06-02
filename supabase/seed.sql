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

insert into public.profiles (
  id,
  slug,
  display_name,
  location,
  bio,
  avatar_url,
  cover_image_url,
  rating,
  followers_count,
  following_count,
  posts_count,
  is_search_featured,
  search_sort_order
)
values
  (
    '11111111-1111-4111-8111-111111111111',
    'kelly-mayer',
    'Kelly Mayer',
    'New York, USA',
    'Baking instructor and dessert specialist.',
    'https://zxhtseztegvzxvhxbqfj.supabase.co/storage/v1/object/public/recipe-images/home/authors/kelly-mayer.png',
    'https://zxhtseztegvzxvhxbqfj.supabase.co/storage/v1/object/public/recipe-images/home/latest/frosted-pinecone-cake-overlay.png',
    4.9,
    128000,
    37,
    12,
    true,
    5
  ),
  (
    '22222222-2222-4222-8222-222222222222',
    'rick-dolynsky',
    'Rick Dolynsky',
    'London, UK',
    'Classic bakery recipes with practical home methods.',
    'https://zxhtseztegvzxvhxbqfj.supabase.co/storage/v1/object/public/recipe-images/home/authors/rick-dolynsky.png',
    'https://zxhtseztegvzxvhxbqfj.supabase.co/storage/v1/object/public/recipe-images/home/latest/classic-victoria-sandwich-overlay.png',
    4.4,
    84000,
    42,
    9,
    false,
    6
  ),
  (
    '33333333-3333-4333-8333-333333333333',
    'dave-robert',
    'Dave Robert',
    'Austin, USA',
    'Fast, protein-forward recipes for busy kitchens.',
    'https://zxhtseztegvzxvhxbqfj.supabase.co/storage/v1/object/public/recipe-images/home/authors/dave-robert.png',
    'https://zxhtseztegvzxvhxbqfj.supabase.co/storage/v1/object/public/recipe-images/home/latest/pea-ricotta-omelets-overlay.png',
    5.0,
    99000,
    21,
    15,
    true,
    4
  ),
  (
    '44444444-4444-4444-8444-444444444444',
    'mark-salvador',
    'Mark Salvador',
    'New York, USA',
    'To cook is to see how simple ingredients can create magic on the plate.',
    'https://zxhtseztegvzxvhxbqfj.supabase.co/storage/v1/object/public/recipe-images/home/authors/kelly-mayer.png',
    'https://zxhtseztegvzxvhxbqfj.supabase.co/storage/v1/object/public/recipe-images/home/latest/main-card-content.png',
    5.0,
    357000,
    24,
    18,
    true,
    1
  ),
  (
    '55555555-5555-4555-8555-555555555555',
    'martin-robert',
    'Martin Robert',
    'Paris, France',
    'Comfort food and bistro-style cooking.',
    'https://zxhtseztegvzxvhxbqfj.supabase.co/storage/v1/object/public/recipe-images/home/authors/rick-dolynsky.png',
    'https://zxhtseztegvzxvhxbqfj.supabase.co/storage/v1/object/public/recipe-images/home/popular/chocolate-cake-buttercream-frosting.png',
    4.6,
    76000,
    18,
    8,
    true,
    2
  ),
  (
    '66666666-6666-4666-8666-666666666666',
    'melisa-anne',
    'Melisa Anne',
    'Los Angeles, USA',
    'Colorful meals, family recipes, and quick desserts.',
    'https://zxhtseztegvzxvhxbqfj.supabase.co/storage/v1/object/public/recipe-images/home/authors/kelly-mayer.png',
    'https://zxhtseztegvzxvhxbqfj.supabase.co/storage/v1/object/public/recipe-images/home/popular/chocolate-ice-cream-buttercream-fruit.png',
    4.7,
    112000,
    31,
    11,
    true,
    3
  )
on conflict (id) do update set
  slug = excluded.slug,
  display_name = excluded.display_name,
  location = excluded.location,
  bio = excluded.bio,
  avatar_url = excluded.avatar_url,
  cover_image_url = excluded.cover_image_url,
  rating = excluded.rating,
  followers_count = excluded.followers_count,
  following_count = excluded.following_count,
  posts_count = excluded.posts_count,
  is_search_featured = excluded.is_search_featured,
  search_sort_order = excluded.search_sort_order;

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
    '66666666-6666-4666-8666-666666666666',
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
    '55555555-5555-4555-8555-555555555555',
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
    '44444444-4444-4444-8444-444444444444',
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
    'https://zxhtseztegvzxvhxbqfj.supabase.co/storage/v1/object/public/recipe-images/home/latest/frosted-pinecone-cake-overlay.png',
    null
  ),
  (
    'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbb2',
    '22222222-2222-4222-8222-222222222222',
    'Classic Victoria sandwich recip...',
    'In a large bowl, mix together flour, baking powder, sugar, and salt..',
    3.8,
    120,
    'Simple',
    'https://zxhtseztegvzxvhxbqfj.supabase.co/storage/v1/object/public/recipe-images/home/latest/classic-victoria-sandwich-overlay.png',
    null
  ),
  (
    'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbb3',
    '33333333-3333-4333-8333-333333333333',
    'Pea and Ricotta Omelets',
    'In a large bowl, mix together flour, baking powder, sugar, and salt..',
    4.5,
    15,
    'Hard',
    'https://zxhtseztegvzxvhxbqfj.supabase.co/storage/v1/object/public/recipe-images/home/latest/pea-ricotta-omelets-overlay.png',
    null
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

insert into public.recipes (
  id,
  author_id,
  title,
  description,
  rating,
  duration_minutes,
  difficulty,
  cover_image_url,
  overlay_image_url,
  is_search_featured,
  search_sort_order,
  is_profile_visible
)
values
  (
    'eeeeeeee-eeee-4eee-8eee-eeeeeeeeeee1',
    '44444444-4444-4444-8444-444444444444',
    'chocolate cake with buttercream frosting',
    'A rich chocolate cake finished with smooth buttercream frosting.',
    4.8,
    30,
    'Medium',
    'https://zxhtseztegvzxvhxbqfj.supabase.co/storage/v1/object/public/recipe-images/home/popular/chocolate-cake-buttercream-frosting.png',
    null,
    true,
    1,
    true
  ),
  (
    'eeeeeeee-eeee-4eee-8eee-eeeeeeeeeee2',
    '44444444-4444-4444-8444-444444444444',
    'chocolate ice cream fruit smoothie',
    'Cold chocolate ice cream blended with fruit for a quick dessert drink.',
    4.6,
    15,
    'Simple',
    'https://zxhtseztegvzxvhxbqfj.supabase.co/storage/v1/object/public/recipe-images/home/popular/chocolate-ice-cream-buttercream-fruit.png',
    null,
    true,
    2,
    true
  ),
  (
    'eeeeeeee-eeee-4eee-8eee-eeeeeeeeeee3',
    '44444444-4444-4444-8444-444444444444',
    'Italian pineapple pizza',
    'Sweet pineapple and savory cheese on a crisp Italian-style base.',
    4.5,
    45,
    'Hard',
    'https://zxhtseztegvzxvhxbqfj.supabase.co/storage/v1/object/public/recipe-images/home/popular/italian-pineapple-pizza.png',
    null,
    true,
    3,
    true
  ),
  (
    'eeeeeeee-eeee-4eee-8eee-eeeeeeeeeee4',
    '44444444-4444-4444-8444-444444444444',
    'chocolate cake with buttercream frosting',
    'A soft party cake with cocoa layers and buttercream.',
    4.8,
    40,
    'Medium',
    'https://zxhtseztegvzxvhxbqfj.supabase.co/storage/v1/object/public/recipe-images/home/popular/chocolate-cake-buttercream-frosting.png',
    null,
    true,
    4,
    true
  ),
  (
    'eeeeeeee-eeee-4eee-8eee-eeeeeeeeeee5',
    '44444444-4444-4444-8444-444444444444',
    'chocolate ice cream fruit smoothie',
    'A creamy frozen smoothie with chocolate notes and fresh fruit.',
    4.7,
    20,
    'Simple',
    'https://zxhtseztegvzxvhxbqfj.supabase.co/storage/v1/object/public/recipe-images/home/popular/chocolate-ice-cream-buttercream-fruit.png',
    null,
    true,
    5,
    true
  ),
  (
    'eeeeeeee-eeee-4eee-8eee-eeeeeeeeeee6',
    '44444444-4444-4444-8444-444444444444',
    'Italian pineapple pizza',
    'A bright, sweet-and-savory pizza built for fast weeknight cooking.',
    4.9,
    35,
    'Medium',
    'https://zxhtseztegvzxvhxbqfj.supabase.co/storage/v1/object/public/recipe-images/home/popular/italian-pineapple-pizza.png',
    null,
    true,
    6,
    true
  )
on conflict (id) do update set
  author_id = excluded.author_id,
  title = excluded.title,
  description = excluded.description,
  rating = excluded.rating,
  duration_minutes = excluded.duration_minutes,
  difficulty = excluded.difficulty,
  cover_image_url = excluded.cover_image_url,
  overlay_image_url = excluded.overlay_image_url,
  is_search_featured = excluded.is_search_featured,
  search_sort_order = excluded.search_sort_order,
  is_profile_visible = excluded.is_profile_visible;

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

insert into public.tags (id, display_name, slug, sort_order, is_active)
values
  ('ffffffff-ffff-4fff-8fff-fffffffffff1', '#egg', 'egg', 1, true),
  ('ffffffff-ffff-4fff-8fff-fffffffffff2', '#eggrecipe', 'eggrecipe', 2, true),
  ('ffffffff-ffff-4fff-8fff-fffffffffff3', '#eggfast', 'eggfast', 3, true),
  ('ffffffff-ffff-4fff-8fff-fffffffffff4', '#eggsandvich', 'eggsandvich', 4, true),
  ('ffffffff-ffff-4fff-8fff-fffffffffff5', '#eggrolls', 'eggrolls', 5, true)
on conflict (id) do update set
  display_name = excluded.display_name,
  slug = excluded.slug,
  sort_order = excluded.sort_order,
  is_active = excluded.is_active;

insert into public.recipe_tags (recipe_id, tag_id)
values
  ('eeeeeeee-eeee-4eee-8eee-eeeeeeeeeee1', 'ffffffff-ffff-4fff-8fff-fffffffffff1'),
  ('eeeeeeee-eeee-4eee-8eee-eeeeeeeeeee1', 'ffffffff-ffff-4fff-8fff-fffffffffff2'),
  ('eeeeeeee-eeee-4eee-8eee-eeeeeeeeeee2', 'ffffffff-ffff-4fff-8fff-fffffffffff3'),
  ('eeeeeeee-eeee-4eee-8eee-eeeeeeeeeee3', 'ffffffff-ffff-4fff-8fff-fffffffffff4'),
  ('eeeeeeee-eeee-4eee-8eee-eeeeeeeeeee6', 'ffffffff-ffff-4fff-8fff-fffffffffff5')
on conflict (recipe_id, tag_id) do nothing;
