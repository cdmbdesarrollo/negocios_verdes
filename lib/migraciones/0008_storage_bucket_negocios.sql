-- 0008_storage_bucket_negocios.sql
-- Bucket público para portadas y galerías. Las policies de Storage son RLS
-- normal sobre storage.objects, igual que cualquier otra tabla.

insert into storage.buckets (id, name, public)
values ('negocios-fotos', 'negocios-fotos', true)
on conflict (id) do nothing;

create policy "negocios_fotos_storage_select_publico"
  on storage.objects for select
  to anon, authenticated
  using (bucket_id = 'negocios-fotos');

create policy "negocios_fotos_storage_admin_insert"
  on storage.objects for insert
  to authenticated
  with check (bucket_id = 'negocios-fotos' and es_admin());

create policy "negocios_fotos_storage_admin_update"
  on storage.objects for update
  to authenticated
  using (bucket_id = 'negocios-fotos' and es_admin())
  with check (bucket_id = 'negocios-fotos' and es_admin());

create policy "negocios_fotos_storage_admin_delete"
  on storage.objects for delete
  to authenticated
  using (bucket_id = 'negocios-fotos' and es_admin());
