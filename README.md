# Blue Peak Store

**Women's Stitched — Ready to Wear**

Blue Peak is a women's ready-to-wear clothing store from Pakistan selling stitched
co-ord sets, 3-piece and 2-piece suits. This repository contains the complete,
working Blue Peak online store: the storefront page with product catalogue,
shopping bag and WhatsApp checkout; customer **log-in and sign-up pages**; an
owner-only **admin portal** where the whole store is edited; and the Supabase
database schemas behind them.

**Project sync rule (owner's instruction):** whenever any site file changes, the
change is pushed to this repository AND this README is updated in the same pass,
so the repository always matches the live site.

- **Owner / Support:** Muhammad Ibrahim — Blue Peak Support Team
- **Customer WhatsApp:** 03485581969 (https://wa.me/923485581969)
- **Currency:** PKR · **Sizes:** XS, S, M, L, XL, XXL · **Payment model:** Cash on Delivery

---

## Live surfaces

| Surface | Address | Status |
|---|---|---|
| This website (Vercel) | https://blue-peak-store-min955379-6910.vercel.app | Live and public; pages: `/` storefront, `/login.html`, `/signup.html`, `/admin.html` |
| Shopify store | https://zvkeh6-0v.myshopify.com | Built (12 products, collections, Support / Sign Up / Log In pages). Storefront still shows the password page until a paid Shopify plan is activated by the owner |
| WordPress site | https://bluepeak8.wordpress.com | Live on the WordPress.com Free plan: Home / Shop / Support pages published, footer carries the real WhatsApp contact |
| Customer accounts (Shopify) | https://shopify.com/86289383644/account | New customer accounts (email + 6-digit code, no password) |

Brand note: the correct brand name is **Blue Peak** (with a K). An early typo
("Blue Seak") was corrected by the owner on 13 Oct 2026 and renamed across the
website, Shopify and WordPress. A legacy internal slug (`blue-seak-store`) may
still appear in a file name — the public brand name everywhere is Blue Peak.

---

## What the website does

- **Home / Hero** — "Women's Stitched — Ready to Wear" with a Shop Now path into the catalogue.
- **Catalogue of 12 products** in three collections — Co-ord Sets, 3PC Stitched, 2PC Stitched.
- **Sale pricing everywhere** — every product shows the PKR sale price, the struck-through
  original ("was") price and a −50% badge.
- **Filters and search** — filter by collection (All / Co-ord Sets / 3PC / 2PC / Sale) or search by name.
- **Size + quantity on every product** — XS, S, M, L, XL, XXL; stock is 10 per size.
- **Shopping bag** — add items with a chosen size, change quantities, remove items;
  the bag shows the subtotal and the total savings versus the was-prices.
- **Checkout form** — name, phone, city, full address and an optional note.
- **WhatsApp ordering** — submitting checkout composes the complete order (items, sizes,
  quantities, prices, totals and delivery details) into a WhatsApp message to
  03485581969 and opens it for the customer to send. An on-screen confirmation
  summarises the order. No customer account is needed to order.
- **Support section** — Blue Peak Support Team (Muhammad Ibrahim) with a tap-to-chat
  WhatsApp button; customers are asked to share their order details with their question.
- **Design** — calm ivory-and-plum fashion look, serif display headings, mobile-first
  (most customers shop on phones), light and dark modes. No emojis; SVG icons only.
- **Live catalogue** — on load, the storefront fetches the current products and
  store settings from Supabase and renders those (the embedded catalogue is only
  an offline fallback). Admin edits are therefore live without redeploying.
- **Order recording** — every checkout is also inserted into Supabase `orders` /
  `order_items`, so the owner sees all orders in the admin portal.
- **Customer accounts** — `signup.html` / `login.html` (Supabase Auth, email +
  password). Ordering never requires an account; accounts are for faster repeat
  orders.
- **Admin portal** — `admin.html`, owner-only (see "Accounts and the admin
  portal" below): edit/add/delete products, change prices and stock, toggle
  products on/off, review orders and update their status, and edit store
  settings (WhatsApp number, announcement text, store name, tagline, support
  name).

## Product catalogue (launch range)

| # | Product | Collection | Sale (PKR) | Was (PKR) |
|---|---|---|---|---|
| 1 | Rose Pink Embroidered Co-ord Set | Co-ord Sets | 3,495 | 6,990 |
| 2 | Sage Green Dobby Printed Co-ord Set | Co-ord Sets | 2,995 | 5,990 |
| 3 | Midnight Blue Jacquard Co-ord Set | Co-ord Sets | 4,495 | 8,990 |
| 4 | Mustard Cotton Textured Co-ord Set | Co-ord Sets | 2,845 | 5,690 |
| 5 | Ivory Embroidered Co-ord Set | Co-ord Sets | 3,495 | 6,990 |
| 6 | Charcoal Denim Dyed Co-ord Set | Co-ord Sets | 4,995 | 9,990 |
| 7 | Emerald Khaddar Printed 3PC Stitched | 3PC Stitched | 4,495 | 8,990 |
| 8 | Blush Paper Cotton Embroidered 3PC Stitched | 3PC Stitched | 9,995 | 19,990 |
| 9 | Teal Linen Digital Printed 3PC Stitched | 3PC Stitched | 4,745 | 9,490 |
| 10 | Plum Raw Silk Embroidered 3PC Stitched | 3PC Stitched | 10,495 | 20,990 |
| 11 | Olive Linen Printed 2PC Stitched | 2PC Stitched | 3,995 | 7,990 |
| 12 | Sand Khaddar Embroidered 2PC Stitched | 2PC Stitched | 4,295 | 8,590 |

**Photo honesty note:** the product photos are licensed sample photos (Pexels, via the
Shopify CDN). They may not match every product's colour name exactly; the website
footer says so and invites customers to confirm the exact shade on WhatsApp before
ordering. Replace `image_url` values (and the photos in `index.html`) with real
product photography as it becomes available.

---

## How the code works

The storefront is deliberately simple:

- `index.html` — the store in one file: markup, CSS and JavaScript are inlined,
  the bag is kept in the visitor's own browser, and an embedded copy of the
  catalogue provides an instant first render and an offline fallback. On load it
  fetches live products + settings from Supabase (via the supabase-js CDN client
  and the public anon key) and re-renders. No build step, no framework — it can
  be hosted on any static host.
- `login.html`, `signup.html`, `admin.html` — standalone pages in the same
  design, each talking directly to Supabase Auth / database with the anon key;
  all permissions are enforced by the database's row-level security, never by
  the page alone.
- Product photos are loaded from the Shopify CDN URLs stored in the `products`
  table (the same photos used on the Shopify products).
- Checkout never takes payment online: it builds a WhatsApp deep link
  (`https://wa.me/923485581969?text=…`) containing the full order, and records
  the order in Supabase at the same moment.

## Repository layout

```
.
├── index.html            # The storefront (live Supabase catalogue + WhatsApp checkout)
├── login.html            # Customer log-in (Supabase Auth)
├── signup.html           # Customer sign-up (Supabase Auth + profile)
├── admin.html            # Owner-only admin portal (products, orders, settings)
├── README.md             # This file
└── supabase/
    ├── schema.sql        # v1: products + orders, RLS policies, seed data
    └── schema-v2.sql     # v2: profiles, site_admins allowlist, settings, admin RLS
```

## Run it locally

No tooling required — open `index.html` in a browser, or serve the folder:

```bash
python3 -m http.server 8000   # then visit http://localhost:8000
```

## Deployment (Vercel)

1. Import this repository in Vercel (or `vercel deploy` from the repo root).
2. Framework preset: **Other / static**. Build command: none. Output: repo root.
3. Every push to `main` redeploys automatically when the GitHub integration is on.

The same files also work unchanged on GitHub Pages, Netlify or any static host.

---

## Supabase (database + accounts)

The live project is **blue-peak-store** (ref `fulhqtlofohrsytqcbbt`, region
ap-south-1 / Mumbai): https://fulhqtlofohrsytqcbbt.supabase.co — the storefront,
login/sign-up and admin pages are all wired to it with the public **anon key**
(the only key allowed in client code; never put the `service_role` key in this
repo or in a web page).

**Schema**

1. `supabase/schema.sql` (v1) creates:
   - `products` — the catalogue (slug, name, category, fabric note, sale + was
     prices in PKR, sizes array, stock, image URL, active flag),
     seeded with the same 12 products and prices as the table above.
   - `orders` — customer name, phone, city, address, note, total, status
     (`new → confirmed → shipped → delivered / cancelled`).
   - `order_items` — line items per order (product, size, qty, unit price).
2. `supabase/schema-v2.sql` (run after v1) adds:
   - `profiles` — one row per account (name, phone), readable/editable only by
     its owner.
   - `site_admins` — the admin email allowlist (see below).
   - `settings` — key/value store settings (store name, tagline, WhatsApp
     number + display format, support name, announcement bar text), publicly
     readable, admin-writable.
   - `public.is_admin()` — a security-definer function used by the RLS
     policies: products/settings become fully editable and orders readable
     only when the signed-in user's email is in `site_admins`.

**Row Level Security summary**

- Anyone may **read** active products and the settings (public store).
- Anyone may **insert** an order and its items (checkout) but may **not** read
  or edit orders.
- Signed-in users manage only their own profile row.
- Admins (allowlist) may read/update orders, write products and settings.

**Auth configuration** (set on the live project): sign-ups enabled, email
confirmation OFF (accounts work immediately), site URL = the Vercel address,
redirect allow-list = the Vercel domain.

## Accounts and the admin portal

- **Customers** sign up on `signup.html` (name, phone, email, password) and log
  in on `login.html`. An account is optional — checkout stays account-free.
- **The owner** signs up with the owner email address; because that email is in
  `site_admins`, that account unlocks `admin.html`. Nothing in the customer
  flow points to the portal: log-in and sign-up always return to the store,
  there is no admin link anywhere on the public pages, and the portal opens
  only when its address is visited directly and the owner signs in there. A
  non-admin account opening that address is refused by the page and by the
  database rules.
- **Changing the admin:** edit the `site_admins` table in the Supabase
  dashboard (Table Editor) or SQL editor — no code change needed.
- **In the portal** the owner can: add a product; edit any product's name,
  category, fabric, prices, stock, photo URL and active flag; delete a product;
  see the latest 50 orders with line items and set each order's status; and
  edit the store settings. All changes are live on the store at next refresh.
- The portal and storefront use the database's real column names
  (`was_price_pkr`, `fabric_note`, `stock_per_size`) and the schema's order
  status wording (`new → confirmed → dispatched → delivered / cancelled`).
  Verified 13 Oct 2026 with a throwaway customer account: `is_admin` returned
  false, product edits and order reads were blocked by RLS (test user deleted
  afterwards).

## Roadmap / known items

- Replace sample photos with real product photography (site + Shopify together).
- Activate the Shopify plan (owner, in Shopify Admin) to remove its password page,
  publish the prepared "Horizon - Blue Peak" theme there, and rename that store
  from "My Store" to Blue Peak in Settings.
- Optional: custom domain for the Vercel deployment.
- Optional: connect the Vercel project to this GitHub repo for automatic
  deploys on push (currently deployments are uploaded directly, because
  Vercel's GitHub app is not authorised on the account yet).

## Support

Blue Peak Support Team — Muhammad Ibrahim
WhatsApp: **03485581969** · https://wa.me/923485581969

*Prices in PKR. Cash on Delivery available across Pakistan.*
