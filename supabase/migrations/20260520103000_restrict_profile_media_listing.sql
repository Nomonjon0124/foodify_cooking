drop policy if exists "Profile media is publicly readable" on storage.objects;

drop policy if exists "Users can select own profile media" on storage.objects;
create policy "Users can select own profile media"
  on storage.objects
  for select
  to authenticated
  using (
    bucket_id = 'profile-media'
    and owner_id = (select auth.uid())::text
    and (storage.foldername(name))[1] = (select auth.uid())::text
    and (storage.foldername(name))[2] in ('avatar', 'cover')
  );
