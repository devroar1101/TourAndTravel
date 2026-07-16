-- ============================================================================
-- AUREVIA — starter seed
-- Run after schema.sql. Seeds site settings, contact info, social links and
-- homepage copy. Destination/package/gallery/testimonial/FAQ content ships
-- inside the app's bundled catalogue (lib/data/seed/) and is also editable
-- from the admin panel once created here.
-- ============================================================================

insert into public.contact_information
  (phone, whatsapp, email, office_address, latitude, longitude)
values (
  '+91 98470 12345',
  '+919847012345',
  'concierge@aurevia.travel',
  'Aurevia House, 14 Marine Parade, Fort Kochi, Kerala 682001, India',
  9.9658, 76.2422
);

insert into public.social_links (platform, url, sort_order) values
  ('instagram', 'https://instagram.com/aurevia.travel', 1),
  ('facebook',  'https://facebook.com/aurevia.travel',  2),
  ('youtube',   'https://youtube.com/@aurevia',         3),
  ('linkedin',  'https://linkedin.com/company/aurevia', 4);

insert into public.homepage_content (section, headline, subheadline, media_url, body, sort_order) values
  ('hero',
   'Some journeys are works of art.',
   'Aurevia designs private, cinematic journeys across India and the world — built by hand, run without friction, remembered forever.',
   'https://videos.pexels.com/video-files/2169880/2169880-uhd_3840_2160_30fps.mp4',
   '{"eyebrow": "Luxury travel, composed", "cta_primary": "Explore destinations", "cta_secondary": "Plan a journey"}',
   1),
  ('story',
   'Sixteen years of composing journeys',
   'Since 2010 we have built each journey by hand — the right room, the right table, the right hour of light.',
   '',
   '{"stats": {"years": 16, "travellers": 48000, "countries": 42, "packages": 120, "satisfaction": 98}}',
   2),
  ('cta',
   'Tell us where the story goes.',
   'A thirty-minute conversation with a travel designer is free, unhurried, and usually the beginning of something extraordinary.',
   'https://images.unsplash.com/photo-1469474968028-56623f02e42e',
   '{}',
   3);

insert into public.settings (key, value) values
  ('site', '{"name": "Aurevia", "tagline": "Journeys, composed like cinema.", "currency": "INR"}'),
  ('enquiry_email', '{"from": "concierge@aurevia.travel", "reply_to": "concierge@aurevia.travel", "subject": "Your Aurevia enquiry — consider it begun"}');
