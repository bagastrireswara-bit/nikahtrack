-- Jalankan seluruh isi file ini di Supabase: SQL Editor > New query > Run
create table dompet(
  id uuid primary key default gen_random_uuid(),
  nama text not null,
  target bigint not null check (target > 0),
  tgl_nikah date not null,
  kode text unique not null,
  dibuat timestamptz default now());
create table anggota(
  dompet_id uuid references dompet on delete cascade,
  user_id uuid references auth.users on delete cascade,
  primary key (dompet_id, user_id));
create table transaksi(
  id uuid primary key default gen_random_uuid(),
  dompet_id uuid not null references dompet on delete cascade,
  type text not null check (type in ('in','out')),
  amt bigint not null check (amt > 0),
  cat text not null,
  note text default '',
  date date not null default current_date,
  created_by uuid default auth.uid(),
  dibuat timestamptz default now());

alter table dompet enable row level security;
alter table anggota enable row level security;
alter table transaksi enable row level security;

create policy "anggota lihat diri sendiri" on anggota for select using (user_id = auth.uid());
create policy "anggota lihat dompet" on dompet for select using (id in (select dompet_id from anggota where user_id = auth.uid()));
create policy "anggota ubah dompet" on dompet for update using (id in (select dompet_id from anggota where user_id = auth.uid()));
create policy "anggota kelola transaksi" on transaksi for all
  using (dompet_id in (select dompet_id from anggota where user_id = auth.uid()))
  with check (dompet_id in (select dompet_id from anggota where user_id = auth.uid()));

create function buat_dompet(p_nama text, p_target bigint, p_tgl date) returns uuid
language plpgsql security definer set search_path = public as $$
declare v uuid;
begin
  if auth.uid() is null then raise exception 'Silakan masuk dulu'; end if;
  insert into dompet(nama, target, tgl_nikah, kode)
    values (p_nama, p_target, p_tgl, upper(substr(md5(random()::text || clock_timestamp()::text), 1, 8)))
    returning id into v;
  insert into anggota values (v, auth.uid());
  return v;
end $$;

create function gabung_dompet(p_kode text) returns uuid
language plpgsql security definer set search_path = public as $$
declare v uuid;
begin
  if auth.uid() is null then raise exception 'Silakan masuk dulu'; end if;
  select id into v from dompet where kode = upper(trim(p_kode));
  if v is null then raise exception 'Kode dompet tidak ditemukan'; end if;
  insert into anggota values (v, auth.uid()) on conflict do nothing;
  return v;
end $$;

revoke all on function buat_dompet(text, bigint, date) from public, anon;
revoke all on function gabung_dompet(text) from public, anon;
grant execute on function buat_dompet(text, bigint, date) to authenticated;
grant execute on function gabung_dompet(text) to authenticated;
