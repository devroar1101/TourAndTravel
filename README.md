# Aurevia — Luxury Travel, Composed

A production-ready tour & travel website built with **Flutter Web + Supabase**, designed as a cinematic, editorial experience: full-screen film hero, scroll-choreographed sections, 15 hand-written destination journeys, nine package collections, a masonry gallery with lightbox, and a complete admin panel with enquiry pipeline, charts and CSV export.

## Stack

| Layer | Technology |
| --- | --- |
| UI | Flutter Web · Material 3 · Poppins (Google Fonts) |
| State | Riverpod 3 |
| Routing | GoRouter (fade-through transitions, admin auth guard) |
| Motion | flutter_animate · custom scroll-reveal system · 60 fps hover/parallax |
| Media | video_player · cached_network_image · masonry gallery |
| Backend | Supabase (PostgreSQL, Auth, Storage, RLS, Edge Functions) |
| Charts | fl_chart (admin dashboard) |
| Hosting | Cloudflare Pages |

## Project layout

```
lib/
  core/            config, theme, router, constants, utilities
  data/
    models/        Destination, TourPackage, GalleryItem, Testimonial, FaqItem, Enquiry
    repositories/  Supabase-backed, with in-memory showcase fallback
    seed/          the bundled 15-destination catalogue and content
    services/      Supabase lifecycle
  providers/       Riverpod providers + auth controller
  shared/widgets/  nav, footer, reveal/motion system, cards, forms, map, video
  features/
    home/          hero, story+stats, destinations, collections, testimonials, CTA
    destinations/  index + full detail page (film, gallery, itinerary, hotels,
                   attractions, map, reviews, related, enquiry)
    packages/      the nine collections
    gallery/       masonry wall + lightbox
    faq/           categorised accordion
    contact/       channels, enquiry form, office map
    admin/         login, dashboard, enquiries, and five CRUD managers
supabase/
  schema.sql       full schema: tables, FKs, indexes, audit columns,
                   soft delete, RLS, storage buckets
  seed.sql         settings, contact info, social links, homepage copy
  functions/       send-enquiry-email (Resend) edge function
```

## Running locally

```bash
flutter pub get
flutter run -d chrome
```

Without Supabase credentials the app runs in **showcase mode**: all content is served from the bundled catalogue, enquiries land in an in-memory pipeline, and the admin panel accepts
`admin@aurevia.travel` / `aurevia-demo`.

## Connecting Supabase

1. Create a project at [supabase.com](https://supabase.com).
2. Run `supabase/schema.sql`, then `supabase/seed.sql` in the SQL editor.
3. Create your admin user under **Authentication → Users**, then register it
   (see the footer of `schema.sql`).
4. Deploy the confirmation email function:
   ```bash
   supabase functions deploy send-enquiry-email
   supabase secrets set RESEND_API_KEY=re_xxx MAIL_FROM="Aurevia <concierge@aurevia.travel>"
   ```
5. Run or build with credentials:
   ```bash
   flutter run -d chrome \
     --dart-define=SUPABASE_URL=https://YOURPROJECT.supabase.co \
     --dart-define=SUPABASE_ANON_KEY=YOUR_ANON_KEY
   ```

## Deploying to Cloudflare Pages

```bash
flutter build web --release \
  --dart-define=SUPABASE_URL=... \
  --dart-define=SUPABASE_ANON_KEY=...
```

- **Build output directory:** `build/web`
- Direct upload: `npx wrangler pages deploy build/web --project-name aurevia`
- Git integration: set the build command to the line above and the output
  directory to `build/web`.
- SPA routing: Pages serves `index.html` for unknown routes automatically;
  no `_redirects` file is required for this app.

## Admin panel

`/admin` — guarded by Supabase Auth plus an `admins` table check (RLS enforces
it server-side as well). Includes:

- **Dashboard** — today's/monthly enquiries, most requested destination,
  14-day trend line, status pipeline donut, recent enquiries, notification badge.
- **Enquiries** — search, status filter, six-stage pipeline (New → Contacted →
  Quoted → Confirmed → Completed / Cancelled), internal notes, CSV export.
- **Destinations / Packages / Gallery / Testimonials / FAQs** — full CRUD with
  soft delete, featured toggles and SEO fields.
