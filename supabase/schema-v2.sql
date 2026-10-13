-- ============================================================
-- Blue Peak Store — schema v2: customer accounts, admin portal,
-- site settings. Run AFTER schema.sql. Safe to re-run.
-- ============================================================

-- ---------- Customer profiles (one row per Supabase Auth user) ----------
create table if not exists public.profiles (
  id         uuid primary key references auth.users(id) on delete cascade,
  full_name  text,
  phone      text,
  created_at timestamptz not null default now()
);
alter table public.profiles enable row level security;

drop policy if exists "profiles: read own" on public.profiles;
create policy "profiles: read own" on public.profiles
  for select using (auth.uid() = id);
drop policy if exists "profiles: insert own" on public.profiles;
create policy "profiles: insert own" on public.profiles
  for insert with check (auth.uid() = id);
drop policy if exists "profiles: update own" on public.profiles;
create policy "profiles: update own" on public.profiles
  for update using (auth.uid() = id);

-- ---------- Admin allowlist (email based) ----------
create table if not exists public.site_admins (
  email      text primary key,
  created_at timestamptz not null default now()
);
alter table public.site_admins enable row level security;
-- No public policies: only the dashboard / service role can change this table.
-- The is_admin() function below reads it as security definer.

insert into public.site_admins (email) values ('min955379@gmail.com')
on conflict (email) do nothing;

create or replace function public.is_admin()
returns boolean
language sql
security definer
set search_path = public
as $$
  select exists (
    select 1 from public.site_admins
    where lower(email) = lower(coalesce(auth.jwt() ->> 'email', ''))
  );
$$;
grant execute on function public.is_admin() to authenticated;

-- ---------- Site settings (key/value, edited from the admin portal) ----------
create table if not exists public.settings (
  key        text primary key,
  value      text,
  updated_at timestamptz not null default now()
);
alter table public.settings enable row level security;

drop policy if exists "settings: public read" on public.settings;
create policy "settings: public read" on public.settings
  for select using (true);
drop policy if exists "settings: admin write" on public.settings;
create policy "settings: admin write" on public.settings
  for all using (public.is_admin()) with check (public.is_admin());

insert into public.settings (key, value) values
  ('store_name',       'Blue Peak'),
  ('tagline',          'Women''s Stitched — Ready to Wear'),
  ('whatsapp_number',  '923485581969'),
  ('whatsapp_display', '03485581969'),
  ('support_name',     'Muhammad Ibrahim'),
  ('announcement',     'Sale is live — flat 50% off everything, with Cash on Delivery across Pakistan')
on conflict (key) do nothing;

-- ---------- Admin rights on catalogue and orders ----------
drop policy if exists "products: admin write" on public.products;
create policy "products: admin write" on public.products
  for all using (public.is_admin()) with check (public.is_admin());

drop policy if exists "orders: admin read" on public.orders;
create policy "orders: admin read" on public.orders
  for select using (public.is_admin());
drop policy if exists "orders: admin update" on public.orders;
create policy "orders: admin update" on public.orders
  for update using (public.is_admin()) with check (public.is_admin());

drop policy if exists "order_items: admin read" on public.order_items;
create policy "order_items: admin read" on public.order_items
  for select using (public.is_admin());
