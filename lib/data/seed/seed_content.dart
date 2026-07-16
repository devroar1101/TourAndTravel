import '../models/content_models.dart';
import '../models/tour_package.dart';
import 'seed_destinations.dart';

/// Bundled tour packages across all nine collections.
final List<TourPackage> seedPackages = [
  TourPackage(
    id: 'p01',
    slug: 'grand-himalayan-odyssey',
    name: 'Grand Himalayan Odyssey',
    category: PackageCategory.luxury,
    description:
        'Kashmir\'s houseboats to Ladakh\'s lakes in one seamless arc — private hosts, luxury camps and the mountains at their most generous.',
    image: card('photo-1506905925346-21bda4d32df4'),
    price: 118000,
    days: 12,
    nights: 11,
    route: ['Srinagar', 'Gulmarg', 'Kargil', 'Leh', 'Nubra', 'Pangong'],
    highlights: [
      'Dal Lake houseboat suite',
      'Drive the Srinagar–Leh highway',
      'Luxury camps at Nubra and Pangong',
      'Private monastery audiences',
    ],
    featured: true,
    rating: 4.9,
  ),
  TourPackage(
    id: 'p02',
    slug: 'spice-coast-immersion',
    name: 'Spice Coast Immersion',
    category: PackageCategory.premium,
    description:
        'Kochi, Munnar, the backwaters and Marari\'s quiet sands — Kerala\'s full spectrum with plantation bungalows and a private houseboat.',
    image: card('photo-1602216056096-3b40cc0c9944'),
    price: 52000,
    days: 8,
    nights: 7,
    route: ['Kochi', 'Munnar', 'Thekkady', 'Alleppey', 'Marari'],
    highlights: [
      'Kolukkumalai sunrise jeep safari',
      'Exclusive-use kettuvallam',
      'Periyar spice trail',
      'Beachfront finale at Marari',
    ],
    featured: true,
    rating: 4.8,
  ),
  TourPackage(
    id: 'p03',
    slug: 'maldives-celebration',
    name: 'Maldives Celebration',
    category: PackageCategory.honeymoon,
    description:
        'Overwater pool villa, seaplane arrival, sandbank picnic and a dinner under the sea — the definitive beginning.',
    image: card('photo-1514282401047-d79a71a590e8'),
    price: 138000,
    days: 5,
    nights: 4,
    route: ['Malé', 'Noonu Atoll'],
    highlights: [
      'Overwater villa with private pool',
      'Private sandbank picnic',
      'Underwater restaurant dinner',
      'Couples spa over the lagoon',
    ],
    featured: true,
    rating: 4.9,
  ),
  TourPackage(
    id: 'p04',
    slug: 'bali-two-worlds',
    name: 'Bali: Jungle & Cliff',
    category: PackageCategory.honeymoon,
    description:
        'Four nights in an Ubud jungle villa, two on Uluwatu\'s cliffs — blessings, Batur sunrise and fire dances at the edge of the sea.',
    image: card('photo-1537996194471-e657df975ab4'),
    price: 96500,
    days: 7,
    nights: 6,
    route: ['Ubud', 'Kintamani', 'Uluwatu', 'Jimbaran'],
    highlights: [
      'Private pool villa in the jungle',
      'Tirta Empul water blessing',
      'Mount Batur sunrise',
      'Kecak fire dance at Uluwatu',
    ],
    featured: true,
    rating: 4.9,
  ),
  TourPackage(
    id: 'p05',
    slug: 'alpine-grand-tour',
    name: 'Alpine Grand Tour',
    category: PackageCategory.vip,
    description:
        'Switzerland end to end in Excellence Class — Glacier Express, Jungfraujoch, Gornergrat sunrise and grand hotels on every lake.',
    image: card('photo-1530122037265-a5f1f91d3b99'),
    price: 285000,
    days: 10,
    nights: 9,
    route: ['Zürich', 'Lucerne', 'Interlaken', 'Zermatt', 'St. Moritz'],
    highlights: [
      'Glacier Express Excellence Class',
      'Top of Europe at Jungfraujoch',
      'Matterhorn sunrise from Gornergrat',
      'Five-star lakefront grand hotels',
    ],
    featured: true,
    rating: 5.0,
  ),
  TourPackage(
    id: 'p06',
    slug: 'ladakh-high-passes',
    name: 'Ladakh High Passes Expedition',
    category: PackageCategory.adventure,
    description:
        'Khardung La, Nubra\'s dunes and a lakeshore camp at Pangong — oxygen-equipped SUVs and crews that know every hairpin.',
    image: card('photo-1464822759023-fed622ff2c3b'),
    price: 48500,
    days: 7,
    nights: 6,
    route: ['Leh', 'Khardung La', 'Nubra', 'Pangong Tso'],
    highlights: [
      'One of the world\'s highest motorable passes',
      'Bactrian camels at Hunder',
      'Luxury lakeshore camping',
      'Astronomer-led stargazing',
    ],
    featured: false,
    rating: 4.8,
  ),
  TourPackage(
    id: 'p07',
    slug: 'singapore-family-week',
    name: 'Singapore Family Week',
    category: PackageCategory.family,
    description:
        'Express passes, night safaris and supertrees that sing — the easiest international trip a family can take.',
    image: card('photo-1525625293386-3f8f99389edd'),
    price: 68000,
    days: 6,
    nights: 5,
    route: ['Marina Bay', 'Sentosa', 'Katong'],
    highlights: [
      'Universal Studios express entry',
      'Night Safari priority tram',
      'Gardens by the Bay light show',
      'Hawker trail for young palates',
    ],
    featured: false,
    rating: 4.7,
  ),
  TourPackage(
    id: 'p08',
    slug: 'royal-rajasthan-express',
    name: 'Royal Rajasthan in Brief',
    category: PackageCategory.weekend,
    description:
        'A long weekend inside the pink city — havelis, Amber at dawn and a balloon over the Aravallis.',
    image: card('photo-1477587458883-47145ed94245'),
    price: 24500,
    days: 4,
    nights: 3,
    route: ['Jaipur', 'Amber', 'Sanganer'],
    highlights: [
      'Heritage haveli stay',
      'Hot-air balloon flight',
      'Historian-led Amber Fort',
      'Palace courtyard dinner',
    ],
    featured: false,
    rating: 4.7,
  ),
  TourPackage(
    id: 'p09',
    slug: 'goa-slow-coast',
    name: 'Goa Slow Coast',
    category: PackageCategory.budget,
    description:
        'The south coast, heritage lanes and a sunset sail — Goa\'s good life at an honest price.',
    image: card('photo-1512343879784-a960bf40e7f2'),
    price: 13900,
    days: 4,
    nights: 3,
    route: ['Betalbatim', 'Fontainhas', 'Old Goa'],
    highlights: [
      'Boutique stay near quiet sands',
      'Latin Quarter heritage walk',
      'Spice farm lunch',
      'Group catamaran sunset',
    ],
    featured: false,
    rating: 4.5,
  ),
  TourPackage(
    id: 'p10',
    slug: 'thai-island-classic',
    name: 'Thai Island Classic',
    category: PackageCategory.international,
    description:
        'Bangkok\'s golden temples then Phuket\'s jade bays — the classic first taste of Southeast Asia, elevated.',
    image: card('photo-1528181304800-259b08848526'),
    price: 58500,
    days: 6,
    nights: 5,
    route: ['Bangkok', 'Phuket', 'Phang Nga'],
    highlights: [
      'Grand Palace with a historian',
      'Private Phang Nga speedboat',
      'Beachfront Kata resort',
      'Home cooking class',
    ],
    featured: false,
    rating: 4.7,
  ),
  TourPackage(
    id: 'p11',
    slug: 'nilgiri-blue-weekend',
    name: 'Nilgiri Blue Weekend',
    category: PackageCategory.weekend,
    description:
        'Toy train up, butler-run bungalow, planter\'s tea tasting — the hills as the Raj kept them.',
    image: card('photo-1470770841072-f978cf4d019e'),
    price: 16900,
    days: 4,
    nights: 3,
    route: ['Mettupalayam', 'Coonoor', 'Ooty'],
    highlights: [
      'Reserved heritage rail coach',
      'Raj-era bungalow with butler',
      'Estate tasting with the planter',
      'Avalanche lake picnic',
    ],
    featured: false,
    rating: 4.6,
  ),
  TourPackage(
    id: 'p12',
    slug: 'dubai-desert-and-sky',
    name: 'Dubai: Desert & Sky',
    category: PackageCategory.luxury,
    description:
        'Level 148 by day, conservation-reserve silence by night — both Dubais in one unhurried itinerary.',
    image: card('photo-1512453979798-5ea266f8880c'),
    price: 89000,
    days: 5,
    nights: 4,
    route: ['Downtown Dubai', 'Old Dubai', 'Al Marmoom Desert'],
    highlights: [
      'Burj Khalifa priority level 148',
      'Falconry at dawn',
      'Night in a luxury desert camp',
      'Marina sunset yacht',
    ],
    featured: true,
    rating: 4.8,
  ),
];

/// Masonry gallery photographs.
final List<GalleryItem> seedGallery = [
  GalleryItem(id: 'g01', image: img('photo-1602216056096-3b40cc0c9944'), caption: 'Kettuvallam at first light', location: 'Alleppey, Kerala', category: 'India', aspectRatio: 1.5),
  GalleryItem(id: 'g02', image: img('photo-1514282401047-d79a71a590e8'), caption: 'The lagoon holds its breath', location: 'Noonu Atoll, Maldives', category: 'Beaches', aspectRatio: 0.75),
  GalleryItem(id: 'g03', image: img('photo-1506905925346-21bda4d32df4'), caption: 'Prayer flags at the pass', location: 'Ladakh', category: 'Mountains', aspectRatio: 1.4),
  GalleryItem(id: 'g04', image: img('photo-1537996194471-e657df975ab4'), caption: 'Terraces of Tegallalang', location: 'Ubud, Bali', category: 'International', aspectRatio: 0.8),
  GalleryItem(id: 'g05', image: img('photo-1477587458883-47145ed94245'), caption: 'The palace of winds', location: 'Jaipur, Rajasthan', category: 'Heritage', aspectRatio: 0.7),
  GalleryItem(id: 'g06', image: img('photo-1530122037265-a5f1f91d3b99'), caption: 'Lake Lucerne, mid-crossing', location: 'Switzerland', category: 'International', aspectRatio: 1.5),
  GalleryItem(id: 'g07', image: img('photo-1512453979798-5ea266f8880c'), caption: 'Blue hour on the marina', location: 'Dubai', category: 'Cities', aspectRatio: 1.3),
  GalleryItem(id: 'g08', image: img('photo-1504198453319-5ce911bafcde'), caption: 'Fifty shades of green', location: 'Munnar, Kerala', category: 'India', aspectRatio: 0.8),
  GalleryItem(id: 'g09', image: img('photo-1528181304800-259b08848526'), caption: 'Wat Arun from the river', location: 'Bangkok, Thailand', category: 'Heritage', aspectRatio: 0.75),
  GalleryItem(id: 'g10', image: img('photo-1507525428034-b723cf961d3e'), caption: 'The long afternoon', location: 'South Goa', category: 'Beaches', aspectRatio: 1.5),
  GalleryItem(id: 'g11', image: img('photo-1464822759023-fed622ff2c3b'), caption: 'Cedar line, snow line', location: 'Manali, Himachal', category: 'Mountains', aspectRatio: 1.4),
  GalleryItem(id: 'g12', image: img('photo-1525625293386-3f8f99389edd'), caption: 'Gardens by the Bay', location: 'Singapore', category: 'Cities', aspectRatio: 1.3),
  GalleryItem(id: 'g13', image: img('photo-1573843981267-be1999ff37cd'), caption: 'Atoll geometry', location: 'Maldives', category: 'Beaches', aspectRatio: 1.4),
  GalleryItem(id: 'g14', image: img('photo-1469474968028-56623f02e42e'), caption: 'First sun through the valley', location: 'Kashmir', category: 'Mountains', aspectRatio: 1.5),
  GalleryItem(id: 'g15', image: img('photo-1441974231531-c6227db76b6e'), caption: 'Estate road, Kodagu', location: 'Coorg, Karnataka', category: 'India', aspectRatio: 1.5),
  GalleryItem(id: 'g16', image: img('photo-1518548419970-58e3b4079ab2'), caption: 'Gates of heaven', location: 'Bali, Indonesia', category: 'Heritage', aspectRatio: 0.7),
  GalleryItem(id: 'g17', image: img('photo-1527668752968-14dc70a27c95'), caption: 'The Matterhorn declines to pose', location: 'Zermatt, Switzerland', category: 'Mountains', aspectRatio: 0.8),
  GalleryItem(id: 'g18', image: img('photo-1552465011-b4e21bf6e79a'), caption: 'Longtail, limestone, jade', location: 'Krabi, Thailand', category: 'Beaches', aspectRatio: 0.75),
];

/// Traveller testimonials.
final List<Testimonial> seedTestimonials = [
  Testimonial(
    id: 't01',
    name: 'Ananya & Dev Iyer',
    origin: 'Bengaluru, India',
    avatar: '${_avatarBase}women/44.jpg',
    rating: 5,
    quote:
        'Aurevia didn\'t plan our honeymoon — they directed it. Every sunset seemed to arrive on cue. We came home different people.',
    tripName: 'Maldives Celebration',
  ),
  Testimonial(
    id: 't02',
    name: 'James Whitmore',
    origin: 'London, UK',
    avatar: '${_avatarBase}men/32.jpg',
    rating: 5,
    quote:
        'I\'ve used travel designers on four continents. Nobody sweats the details like this team — the houseboat playlist matched the sunset.',
    tripName: 'Spice Coast Immersion',
  ),
  Testimonial(
    id: 't03',
    name: 'Farah Sheikh',
    origin: 'Dubai, UAE',
    avatar: '${_avatarBase}women/68.jpg',
    rating: 4.9,
    quote:
        'Ladakh at those altitudes could have been an ordeal. Instead it was the most comfortable adventure of my life.',
    tripName: 'High Passes Expedition',
  ),
  Testimonial(
    id: 't04',
    name: 'The Gupta Family',
    origin: 'Ahmedabad, India',
    avatar: '${_avatarBase}men/75.jpg',
    rating: 4.8,
    quote:
        'Two kids, four grandparents, zero meltdowns. Singapore with Aurevia was the first holiday where we all actually rested.',
    tripName: 'Singapore Family Week',
  ),
  Testimonial(
    id: 't05',
    name: 'Charlotte Dubois',
    origin: 'Paris, France',
    avatar: '${_avatarBase}women/17.jpg',
    rating: 5,
    quote:
        'The balloon over Amber at dawn, the palace dinner by oil lamp — Jaipur was staged like an opera and we had the royal box.',
    tripName: 'Royal Rajasthan',
  ),
  Testimonial(
    id: 't06',
    name: 'Rajeev Talwar',
    origin: 'New Delhi, India',
    avatar: '${_avatarBase}men/54.jpg',
    rating: 5,
    quote:
        'Excellence Class on the Glacier Express, arranged down to the window side. Switzerland by Aurevia is the only way I\'ll do it again.',
    tripName: 'Alpine Grand Tour',
  ),
];

const String _avatarBase = 'https://randomuser.me/api/portraits/';

/// Frequently asked questions.
final List<FaqItem> seedFaqs = [
  FaqItem(
    id: 'f01',
    question: 'How far in advance should I book my journey?',
    answer:
        'For international journeys and peak seasons (December–January, April–May) we recommend 60–90 days, which secures the best villas, rail classes and guides. Domestic escapes can often be arranged within two to three weeks. For the Maldives and Switzerland in high season, earlier is always better.',
    category: 'Booking',
  ),
  FaqItem(
    id: 'f02',
    question: 'Are your itineraries customisable?',
    answer:
        'Entirely. Every published itinerary is a starting sketch — our travel designers rebuild it around your dates, pace, cuisine preferences and occasions. Roughly 80% of the journeys we operate are bespoke variations of our core routes.',
    category: 'Booking',
  ),
  FaqItem(
    id: 'f03',
    question: 'What is included in the published price?',
    answer:
        'Each destination page lists inclusions and exclusions precisely. As a rule: stays, private transfers, named experiences, listed meals and your destination host are included; flights to the starting point, visas and insurance are not. There are no hidden fees — the quote you approve is the price you pay.',
    category: 'Pricing',
  ),
  FaqItem(
    id: 'f04',
    question: 'How do payments and cancellations work?',
    answer:
        'A 25% deposit confirms your journey; the balance is due 30 days before departure. Cancellations more than 45 days out are refunded minus non-recoverable supplier costs; within 45 days, our team works to recover and re-credit whatever the hotels and operators allow. We always recommend comprehensive travel insurance.',
    category: 'Pricing',
  ),
  FaqItem(
    id: 'f05',
    question: 'Do you assist with visas and travel insurance?',
    answer:
        'Yes. Our documentation desk prepares your visa file, books appointments and tracks applications for every destination we operate. We also partner with leading insurers for trip, medical and high-altitude cover, and will recommend the right policy for your route.',
    category: 'Travel',
  ),
  FaqItem(
    id: 'f06',
    question: 'Is support available while I\'m travelling?',
    answer:
        'Every journey runs with a dedicated destination host and a 24/7 concierge line. Flight delayed, weather turned, restaurant closed — one message and the itinerary reshapes around you in real time.',
    category: 'Travel',
  ),
  FaqItem(
    id: 'f07',
    question: 'Can you arrange journeys for large families or corporate groups?',
    answer:
        'Group journeys are a speciality — multi-generation family reunions, incentive trips, offsites and destination celebrations up to 120 guests. We handle rooming, dietaries, staggered arrivals, event production and on-ground crew.',
    category: 'Groups',
  ),
  FaqItem(
    id: 'f08',
    question: 'Which destinations suit first-time international travellers?',
    answer:
        'Singapore, Dubai and Thailand are our gentlest introductions — short flights from India, simple visas, and infrastructure that forgives every wrong turn. Bali follows closely for couples. Our designers will match the destination to your comfort level.',
    category: 'Travel',
  ),
];
