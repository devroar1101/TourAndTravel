-- ============================================================================
-- AUREVIA — Supabase / PostgreSQL schema
-- Run in the Supabase SQL editor (or `supabase db push`) on a fresh project.
-- Includes: tables, constraints, indexes, audit columns, soft delete,
-- updated-at triggers, Row Level Security and storage buckets.
-- ============================================================================

create extension if not exists "pgcrypto";

-- ----------------------------------------------------------------------------
-- Audit helper: maintain modified_date / modified_by automatically
-- ----------------------------------------------------------------------------
create or replace function public.touch_audit()
returns trigger language plpgsql as $$
begin
  new.modified_date := now();
  new.modified_by := auth.uid();
  return new;
end $$;

-- ----------------------------------------------------------------------------
-- admins — operators allowed into the panel (rows reference auth.users)
-- ----------------------------------------------------------------------------
create table public.admins (
  id            uuid primary key default gen_random_uuid(),
  user_id       uuid not null unique references auth.users (id) on delete cascade,
  display_name  text not null,
  role          text not null default 'editor' check (role in ('owner', 'editor')),
  created_date  timestamptz not null default now(),
  modified_date timestamptz not null default now(),
  created_by    uuid references auth.users (id),
  modified_by   uuid references auth.users (id),
  deleted_at    timestamptz
);

-- Helper used by every policy below.
create or replace function public.is_admin()
returns boolean language sql stable security definer set search_path = public as $$
  select exists (
    select 1 from public.admins
    where user_id = auth.uid() and deleted_at is null
  );
$$;

-- ----------------------------------------------------------------------------
-- destinations
-- ----------------------------------------------------------------------------
create table public.destinations (
  id              uuid primary key default gen_random_uuid(),
  slug            text not null unique,
  name            text not null,
  country         text not null,
  tagline         text not null default '',
  overview        text not null default '',
  hero_image      text not null default '',
  card_image      text not null default '',
  gallery         jsonb not null default '[]',
  video_url       text not null default '',
  price_from      integer not null default 0 check (price_from >= 0),
  days            integer not null default 0 check (days >= 0),
  nights          integer not null default 0 check (nights >= 0),
  best_season     text not null default '',
  rating          numeric(3,2) not null default 0 check (rating between 0 and 5),
  review_count    integer not null default 0,
  featured        boolean not null default false,
  tags            jsonb not null default '[]',
  highlights      jsonb not null default '[]',
  itinerary       jsonb not null default '[]',
  included        jsonb not null default '[]',
  excluded        jsonb not null default '[]',
  hotels          jsonb not null default '[]',
  attractions     jsonb not null default '[]',
  reviews         jsonb not null default '[]',
  latitude        double precision not null default 0,
  longitude       double precision not null default 0,
  seo_title       text not null default '',
  seo_description text not null default '',
  created_date    timestamptz not null default now(),
  modified_date   timestamptz not null default now(),
  created_by      uuid references auth.users (id),
  modified_by     uuid references auth.users (id),
  deleted_at      timestamptz
);

create index idx_destinations_slug     on public.destinations (slug) where deleted_at is null;
create index idx_destinations_featured on public.destinations (featured) where deleted_at is null;
create index idx_destinations_country  on public.destinations (country) where deleted_at is null;

-- ----------------------------------------------------------------------------
-- destination_images / destination_videos — normalised media (optional
-- alternative to the jsonb columns for teams preferring relational media)
-- ----------------------------------------------------------------------------
create table public.destination_images (
  id             uuid primary key default gen_random_uuid(),
  destination_id uuid not null references public.destinations (id) on delete cascade,
  url            text not null,
  alt_text       text not null default '',
  sort_order     integer not null default 0,
  created_date   timestamptz not null default now(),
  modified_date  timestamptz not null default now(),
  created_by     uuid references auth.users (id),
  modified_by    uuid references auth.users (id),
  deleted_at     timestamptz
);

create index idx_destination_images_dest on public.destination_images (destination_id) where deleted_at is null;

create table public.destination_videos (
  id             uuid primary key default gen_random_uuid(),
  destination_id uuid not null references public.destinations (id) on delete cascade,
  url            text not null,
  poster_url     text not null default '',
  title          text not null default '',
  sort_order     integer not null default 0,
  created_date   timestamptz not null default now(),
  modified_date  timestamptz not null default now(),
  created_by     uuid references auth.users (id),
  modified_by    uuid references auth.users (id),
  deleted_at     timestamptz
);

create index idx_destination_videos_dest on public.destination_videos (destination_id) where deleted_at is null;

-- ----------------------------------------------------------------------------
-- packages / package_images
-- ----------------------------------------------------------------------------
create table public.packages (
  id            uuid primary key default gen_random_uuid(),
  slug          text not null unique,
  name          text not null,
  category      text not null check (category in
                  ('luxury','adventure','family','honeymoon','weekend',
                   'international','budget','premium','vip')),
  description   text not null default '',
  image         text not null default '',
  price         integer not null default 0 check (price >= 0),
  days          integer not null default 0,
  nights        integer not null default 0,
  route         jsonb not null default '[]',
  highlights    jsonb not null default '[]',
  featured      boolean not null default false,
  rating        numeric(3,2) not null default 0 check (rating between 0 and 5),
  created_date  timestamptz not null default now(),
  modified_date timestamptz not null default now(),
  created_by    uuid references auth.users (id),
  modified_by   uuid references auth.users (id),
  deleted_at    timestamptz
);

create index idx_packages_category on public.packages (category) where deleted_at is null;
create index idx_packages_featured on public.packages (featured) where deleted_at is null;

create table public.package_images (
  id            uuid primary key default gen_random_uuid(),
  package_id    uuid not null references public.packages (id) on delete cascade,
  url           text not null,
  alt_text      text not null default '',
  sort_order    integer not null default 0,
  created_date  timestamptz not null default now(),
  modified_date timestamptz not null default now(),
  created_by    uuid references auth.users (id),
  modified_by   uuid references auth.users (id),
  deleted_at    timestamptz
);

create index idx_package_images_pkg on public.package_images (package_id) where deleted_at is null;

-- ----------------------------------------------------------------------------
-- gallery
-- ----------------------------------------------------------------------------
create table public.gallery (
  id            uuid primary key default gen_random_uuid(),
  image         text not null,
  caption       text not null default '',
  location      text not null default '',
  category      text not null default 'All',
  aspect_ratio  numeric(5,3) not null default 1.0 check (aspect_ratio > 0),
  created_date  timestamptz not null default now(),
  created_at    timestamptz not null default now(),
  modified_date timestamptz not null default now(),
  created_by    uuid references auth.users (id),
  modified_by   uuid references auth.users (id),
  deleted_at    timestamptz
);

create index idx_gallery_category on public.gallery (category) where deleted_at is null;

-- ----------------------------------------------------------------------------
-- testimonials
-- ----------------------------------------------------------------------------
create table public.testimonials (
  id            uuid primary key default gen_random_uuid(),
  name          text not null,
  origin        text not null default '',
  avatar        text not null default '',
  rating        numeric(3,2) not null default 5 check (rating between 0 and 5),
  quote         text not null,
  trip_name     text not null default '',
  created_date  timestamptz not null default now(),
  created_at    timestamptz not null default now(),
  modified_date timestamptz not null default now(),
  created_by    uuid references auth.users (id),
  modified_by   uuid references auth.users (id),
  deleted_at    timestamptz
);

-- ----------------------------------------------------------------------------
-- faqs
-- ----------------------------------------------------------------------------
create table public.faqs (
  id            uuid primary key default gen_random_uuid(),
  question      text not null,
  answer        text not null,
  category      text not null default 'General',
  created_date  timestamptz not null default now(),
  created_at    timestamptz not null default now(),
  modified_date timestamptz not null default now(),
  created_by    uuid references auth.users (id),
  modified_by   uuid references auth.users (id),
  deleted_at    timestamptz
);

-- ----------------------------------------------------------------------------
-- enquiries
-- ----------------------------------------------------------------------------
create table public.enquiries (
  id                   uuid primary key default gen_random_uuid(),
  name                 text not null,
  phone                text not null default '',
  email                text not null default '',
  destination          text not null default '',
  travel_date          date,
  adults               integer not null default 1 check (adults between 1 and 50),
  children             integer not null default 0 check (children between 0 and 50),
  budget               text not null default '',
  special_requirements text not null default '',
  message              text not null default '',
  status               text not null default 'new' check (status in
                        ('new','contacted','quoted','confirmed','completed','cancelled')),
  notes                text not null default '',
  created_at           timestamptz not null default now(),
  created_date         timestamptz not null default now(),
  modified_date        timestamptz not null default now(),
  created_by           uuid references auth.users (id),
  modified_by          uuid references auth.users (id),
  deleted_at           timestamptz
);

create index idx_enquiries_status  on public.enquiries (status) where deleted_at is null;
create index idx_enquiries_created on public.enquiries (created_at desc) where deleted_at is null;
create index idx_enquiries_email   on public.enquiries (email) where deleted_at is null;

-- ----------------------------------------------------------------------------
-- settings / contact_information / social_links / homepage_content
-- ----------------------------------------------------------------------------
create table public.settings (
  id            uuid primary key default gen_random_uuid(),
  key           text not null unique,
  value         jsonb not null default '{}',
  created_date  timestamptz not null default now(),
  modified_date timestamptz not null default now(),
  created_by    uuid references auth.users (id),
  modified_by   uuid references auth.users (id),
  deleted_at    timestamptz
);

create table public.contact_information (
  id             uuid primary key default gen_random_uuid(),
  phone          text not null default '',
  whatsapp       text not null default '',
  email          text not null default '',
  office_address text not null default '',
  latitude       double precision not null default 0,
  longitude      double precision not null default 0,
  created_date   timestamptz not null default now(),
  modified_date  timestamptz not null default now(),
  created_by     uuid references auth.users (id),
  modified_by    uuid references auth.users (id),
  deleted_at     timestamptz
);

create table public.social_links (
  id            uuid primary key default gen_random_uuid(),
  platform      text not null,
  url           text not null,
  sort_order    integer not null default 0,
  created_date  timestamptz not null default now(),
  modified_date timestamptz not null default now(),
  created_by    uuid references auth.users (id),
  modified_by   uuid references auth.users (id),
  deleted_at    timestamptz
);

create table public.homepage_content (
  id            uuid primary key default gen_random_uuid(),
  section       text not null unique,
  headline      text not null default '',
  subheadline   text not null default '',
  media_url     text not null default '',
  body          jsonb not null default '{}',
  sort_order    integer not null default 0,
  created_date  timestamptz not null default now(),
  modified_date timestamptz not null default now(),
  created_by    uuid references auth.users (id),
  modified_by   uuid references auth.users (id),
  deleted_at    timestamptz
);

-- ----------------------------------------------------------------------------
-- updated-at triggers
-- ----------------------------------------------------------------------------
do $$
declare t text;
begin
  foreach t in array array[
    'admins','destinations','destination_images','destination_videos',
    'packages','package_images','gallery','testimonials','faqs','enquiries',
    'settings','contact_information','social_links','homepage_content'
  ] loop
    execute format(
      'create trigger trg_%s_audit before update on public.%I
       for each row execute function public.touch_audit()', t, t);
  end loop;
end $$;

-- ----------------------------------------------------------------------------
-- Row Level Security
-- Public: read-only on live (non-deleted) content; insert-only on enquiries.
-- Admins: full access everywhere.
-- ----------------------------------------------------------------------------
do $$
declare t text;
begin
  foreach t in array array[
    'admins','destinations','destination_images','destination_videos',
    'packages','package_images','gallery','testimonials','faqs','enquiries',
    'settings','contact_information','social_links','homepage_content'
  ] loop
    execute format('alter table public.%I enable row level security', t);
  end loop;
end $$;

-- Public read of live content.
do $$
declare t text;
begin
  foreach t in array array[
    'destinations','destination_images','destination_videos','packages',
    'package_images','gallery','testimonials','faqs','settings',
    'contact_information','social_links','homepage_content'
  ] loop
    execute format(
      'create policy "public read live" on public.%I
       for select using (deleted_at is null)', t);
  end loop;
end $$;

-- Anyone may submit an enquiry; nobody anonymous may read them.
create policy "public submit enquiry" on public.enquiries
  for insert with check (true);

-- Admins: full control of every content table.
do $$
declare t text;
begin
  foreach t in array array[
    'destinations','destination_images','destination_videos','packages',
    'package_images','gallery','testimonials','faqs','enquiries','settings',
    'contact_information','social_links','homepage_content'
  ] loop
    execute format(
      'create policy "admin all" on public.%I
       for all using (public.is_admin()) with check (public.is_admin())', t);
  end loop;
end $$;

-- Admins table: an admin may see the admin roster; only owners manage it.
create policy "admins read roster" on public.admins
  for select using (public.is_admin());
create policy "owners manage roster" on public.admins
  for all using (
    exists (
      select 1 from public.admins a
      where a.user_id = auth.uid() and a.role = 'owner' and a.deleted_at is null
    )
  );

-- ----------------------------------------------------------------------------
-- Storage buckets
-- ----------------------------------------------------------------------------
insert into storage.buckets (id, name, public) values
  ('destination-media', 'destination-media', true),
  ('gallery-media',     'gallery-media',     true),
  ('site-assets',       'site-assets',       true)
on conflict (id) do nothing;

create policy "public read media" on storage.objects
  for select using (bucket_id in ('destination-media','gallery-media','site-assets'));

create policy "admin write media" on storage.objects
  for insert with check (
    bucket_id in ('destination-media','gallery-media','site-assets')
    and public.is_admin()
  );

create policy "admin update media" on storage.objects
  for update using (
    bucket_id in ('destination-media','gallery-media','site-assets')
    and public.is_admin()
  );

create policy "admin delete media" on storage.objects
  for delete using (
    bucket_id in ('destination-media','gallery-media','site-assets')
    and public.is_admin()
  );

-- ----------------------------------------------------------------------------
-- Bootstrapping the first admin
-- 1. Create the user in Authentication → Users (email + password).
-- 2. Then run (replacing the email):
--
--    insert into public.admins (user_id, display_name, role)
--    select id, 'Operations', 'owner' from auth.users
--    where email = 'you@aurevia.travel';
-- ----------------------------------------------------------------------------
