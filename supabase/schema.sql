-- ============================================================
-- Blue Peak Store — Supabase schema
-- Women's stitched ready-to-wear store (Pakistan, PKR)
-- Run this in the Supabase SQL editor (or via the Management API)
-- after creating the project. Safe to re-run: tables are created
-- if missing and seed rows upsert on the product slug.
-- ============================================================

create extension if not exists "pgcrypto";

-- ---------- Products ----------
create table if not exists public.products (
  id            uuid primary key default gen_random_uuid(),
  slug          text unique not null,
  name          text not null,
  category      text not null check (category in ('Co-ord Sets', '3PC Stitched', '2PC Stitched')),
  fabric_note   text,
  price_pkr     integer not null check (price_pkr > 0),
  was_price_pkr integer not null check (was_price_pkr >= price_pkr),
  sizes         text[] not null default '{XS,S,M,L,XL,XXL}',
  stock_per_size integer not null default 10,
  image_url     text,
  is_sample_photo boolean not null default true,
  active        boolean not null default true,
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now()
);

-- ---------- Orders (placed via WhatsApp checkout) ----------
create table if not exists public.orders (
  id            uuid primary key default gen_random_uuid(),
  customer_name text not null,
  phone         text not null,
  city          text not null,
  address       text not null,
  note          text,
  total_pkr     integer not null,
  savings_pkr   integer not null default 0,
  status        text not null default 'new'
                check (status in ('new','confirmed','dispatched','delivered','cancelled')),
  channel       text not null default 'whatsapp',
  created_at    timestamptz not null default now()
);

create table if not exists public.order_items (
  id          uuid primary key default gen_random_uuid(),
  order_id    uuid not null references public.orders(id) on delete cascade,
  product_id  uuid references public.products(id),
  product_name text not null,
  size        text not null,
  qty         integer not null check (qty > 0),
  unit_price_pkr integer not null
);

-- ---------- Row Level Security ----------
alter table public.products    enable row level security;
alter table public.orders      enable row level security;
alter table public.order_items enable row level security;

-- Anyone (anon) may READ active products — the storefront catalogue.
drop policy if exists "products are public to read" on public.products;
create policy "products are public to read"
  on public.products for select
  using (active = true);

-- Anyone may INSERT an order + its items (checkout), but never read,
-- update or delete orders from the public key. The owner reads orders
-- in the Supabase dashboard (service role bypasses RLS).
drop policy if exists "anyone can place an order" on public.orders;
create policy "anyone can place an order"
  on public.orders for insert
  with check (true);

drop policy if exists "anyone can add order items" on public.order_items;
create policy "anyone can add order items"
  on public.order_items for insert
  with check (true);

-- ---------- Seed: the 12 launch products ----------
insert into public.products (slug, name, category, fabric_note, price_pkr, was_price_pkr, image_url) values
('rose-pink-embroidered-coord',    'Rose Pink Embroidered Co-ord Set',            'Co-ord Sets',  'Textured cotton, embroidered neckline',      3495,  6990, 'https://cdn.shopify.com/s/files/1/0862/8938/3644/files/free-photo-of-eastern-dresses-2024-shoot-by-dhanno.jpg?v=1791910682'),
('sage-green-dobby-coord',         'Sage Green Dobby Printed Co-ord Set',         'Co-ord Sets',  'Dobby lawn, digital print',                  2995,  5990, 'https://cdn.shopify.com/s/files/1/0862/8938/3644/files/free-photo-of-eastern-dresses-2024-shoot-by-dhanno_798a7c35-fdc9-4f0a-bea3-b65448acd1f5.jpg?v=1791910688'),
('midnight-blue-jacquard-coord',   'Midnight Blue Jacquard Co-ord Set',           'Co-ord Sets',  'Jacquard, dyed',                             4495,  8990, 'https://cdn.shopify.com/s/files/1/0862/8938/3644/files/free-photo-of-model-in-blue-embroidered-shalwar-kameez-dress-with-scarf.jpg?v=1791910694'),
('mustard-cotton-coord',           'Mustard Cotton Textured Co-ord Set',          'Co-ord Sets',  'Cotton textured',                            2845,  5690, 'https://cdn.shopify.com/s/files/1/0862/8938/3644/files/free-photo-of-fashion-eastern-dresses-by-dhanno.jpg?v=1791910700'),
('ivory-embroidered-coord',        'Ivory Embroidered Co-ord Set',                'Co-ord Sets',  'Embroidered textured fabric',                3495,  6990, 'https://cdn.shopify.com/s/files/1/0862/8938/3644/files/free-photo-of-fashion-eastern-dresses-by-dhanno_9b5471bd-89b6-4b4d-aaf3-096ecfabd9d6.jpg?v=1791910706'),
('charcoal-denim-coord',           'Charcoal Denim Dyed Co-ord Set',              'Co-ord Sets',  'Denim dyed',                                 4995,  9990, 'https://cdn.shopify.com/s/files/1/0862/8938/3644/files/free-photo-of-fashion-eastern-dresses-by-dhanno_775b44e5-2c3a-4489-908f-3037ebe638e3.jpg?v=1791910712'),
('emerald-khaddar-3pc',            'Emerald Khaddar Printed 3PC Stitched',       '3PC Stitched', 'Khaddar print, with dupatta',                4495,  8990, 'https://cdn.shopify.com/s/files/1/0862/8938/3644/files/pexels-photo-27284033.jpg?v=1791910718'),
('blush-paper-cotton-3pc',         'Blush Paper Cotton Embroidered 3PC Stitched', '3PC Stitched', 'Paper cotton, embroidered, with dupatta',    9995, 19990, 'https://cdn.shopify.com/s/files/1/0862/8938/3644/files/free-photo-of-eastern-dresses-2024-shoot-by-dhanno_af1e2698-1679-4775-a790-749aacc66a1f.jpg?v=1791910724'),
('teal-linen-3pc',                 'Teal Linen Digital Printed 3PC Stitched',     '3PC Stitched', 'Linen digital print, with dupatta',          4745,  9490, 'https://cdn.shopify.com/s/files/1/0862/8938/3644/files/free-photo-of-eastern-dresses-2024-shoot-by-dhanno_3106e940-ca4d-45cb-862c-a2dcb274547f.jpg?v=1791910730'),
('plum-raw-silk-3pc',              'Plum Raw Silk Embroidered 3PC Stitched',      '3PC Stitched', 'Raw silk, embroidered, with dupatta',       10495, 20990, 'https://cdn.shopify.com/s/files/1/0862/8938/3644/files/free-photo-of-eastern-dresses-2024-shoot-by-dhanno_fd64f84c-8362-4d45-8b91-66202354fa5c.jpg?v=1791910735'),
('olive-linen-2pc',               'Olive Linen Printed 2PC Stitched',           '2PC Stitched', 'Linen print',                                3995,  7990, 'https://cdn.shopify.com/s/files/1/0862/8938/3644/files/free-photo-of-fashion-eastern-dresses-by-dhanno_2d50b8a2-0430-4beb-88af-02f198a27d09.jpg?v=1791910742'),
('sand-khaddar-2pc',               'Sand Khaddar Embroidered 2PC Stitched',      '2PC Stitched', 'Khaddar, embroidered',                       4295,  8590, 'https://cdn.shopify.com/s/files/1/0862/8938/3644/files/free-photo-of-elegant-pakistani-fashion-shoot-in-lahore.jpg?v=1791910749')
on conflict (slug) do update set
  name = excluded.name,
  category = excluded.category,
  fabric_note = excluded.fabric_note,
  price_pkr = excluded.price_pkr,
  was_price_pkr = excluded.was_price_pkr,
  image_url = excluded.image_url,
  updated_at = now();
