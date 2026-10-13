# Blue Peak Store

**Women's Stitched — Ready to Wear**

Blue Peak is a women's ready-to-wear clothing store from Pakistan selling stitched
co-ord sets, 3-piece and 2-piece suits. This repository contains the complete,
working Blue Peak online store website: a single self-contained storefront page
with a product catalogue, shopping bag and WhatsApp checkout, plus the Supabase
database schema for the store's products and orders.

- **Owner / Support:** Muhammad Ibrahim — Blue Peak Support Team
- **Customer WhatsApp:** 03485581969 (https://wa.me/923485581969)
- **Currency:** PKR · **Sizes:** XS, S, M, L, XL, XXL · **Payment model:** Cash on Delivery

---

## Live surfaces

| Surface | Address | Status |
|---|---|---|
| This website (Vercel) | see the repo's deployment / Vercel project | Deployed from this repo |
| Shopify store | https://zvkeh6-0v.myshopify.com | Built (12 products, collections, Support / Sign Up / Log In pages). Storefront still shows the password page until a paid Shopify plan is activated by the owner |
| WordPress site | https://bluepeak8.wordpress.com | Created on the WordPress.com Free plan; pages being completed |
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

The storefront is deliberately simple and dependency-free:

- `index.html` — the entire store in one file: markup, CSS and JavaScript are
  inlined, product data is embedded in the page, and the bag is kept in the
  visitor's own browser (`localStorage`-style state). No build step, no server,
  no framework — it can be hosted on any static host.
- Product photos are loaded from the Shopify CDN URLs listed in
  `supabase/schema.sql` (the same photos used on the Shopify products).
- Checkout never takes payment online: it builds a WhatsApp deep link
  (`https://wa.me/923485581969?text=…`) containing the full order.

## Repository layout

```
.
├── index.html            # The complete storefront (single-file build)
├── README.md             # This file
└── supabase/
    └── schema.sql        # Products + orders schema, RLS policies, seed data
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

## Supabase (database)

The storefront currently runs fully client-side; Supabase is the store's database
layer for the catalogue and for recording orders, ready to be wired into the page.

**Setup**

1. Create a Supabase project (Free plan is fine).
2. Open the project's SQL editor and run `supabase/schema.sql`. It creates:
   - `products` — the catalogue (slug, name, category, fabric note, sale + was
     prices in PKR, sizes array, stock per size, image URL, active flag),
     seeded with the same 12 products and prices as the table above.
   - `orders` — customer name, phone, city, address, note, totals, status
     (`new → confirmed → dispatched → delivered / cancelled`), channel.
   - `order_items` — line items per order (product, size, qty, unit price).
3. Row Level Security is enabled in the script:
   - Anyone may **read** active products (public catalogue).
   - Anyone may **insert** an order and its items (checkout) but may **not**
     read, edit or delete orders — the owner manages orders from the Supabase
     dashboard.
4. To connect the storefront later, use the project's **anon (public) key** only.
   Never put the `service_role` key in this repo or in client-side code.

## Roadmap / known items

- Replace sample photos with real product photography (site + Shopify together).
- Wire the checkout to also insert the order into Supabase `orders` / `order_items`
  before opening WhatsApp, so every order is recorded in the dashboard.
- Activate the Shopify plan (owner, in Shopify Admin) to remove its password page,
  publish the prepared "Horizon - Blue Peak" theme there, and rename that store
  from "My Store" to Blue Peak in Settings.
- Finish and launch the WordPress site pages (Home / Shop / Support).
- Optional: custom domain for the Vercel deployment.

## Support

Blue Peak Support Team — Muhammad Ibrahim
WhatsApp: **03485581969** · https://wa.me/923485581969

*Prices in PKR. Cash on Delivery available across Pakistan.*
