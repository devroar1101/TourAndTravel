import '../models/destination.dart';

/// Bundled destination catalogue.
///
/// Serves as showcase-mode content when Supabase is not configured and as
/// the reference dataset for seeding the production database.
const String _u = 'https://images.unsplash.com/';
const String _q = '?auto=format&fit=crop&w=1800&q=80';
const String _qCard = '?auto=format&fit=crop&w=1000&q=75';

String img(String id) => '$_u$id$_q';
String card(String id) => '$_u$id$_qCard';

final List<Destination> seedDestinations = [
  Destination(
    id: 'd01',
    slug: 'kerala',
    name: 'Kerala',
    country: 'India',
    tagline: 'Where the backwaters keep their own time',
    overview:
        'Kerala unfolds slowly — a latticework of palm-shaded canals, spice-scented hills and beaches the colour of raw silk. Drift through Alleppey aboard a private kettuvallam houseboat, wake to mist rolling over Munnar\'s tea terraces, and end each evening with Kathakali fire and coastal seafood. This is India at its most unhurried, curated down to the last cardamom pod.',
    heroImage: img('photo-1602216056096-3b40cc0c9944'),
    cardImage: card('photo-1602216056096-3b40cc0c9944'),
    gallery: [
      img('photo-1593693397690-362cb9666fc2'),
      img('photo-1476514525535-07fb3b4ae5f1'),
      img('photo-1441974231531-c6227db76b6e'),
      img('photo-1504198453319-5ce911bafcde'),
      img('photo-1506744038136-46273834b3fb'),
      img('photo-1470770841072-f978cf4d019e'),
    ],
    videoUrl:
        'https://videos.pexels.com/video-files/2169880/2169880-uhd_3840_2160_30fps.mp4',
    priceFrom: 24500,
    days: 6,
    nights: 5,
    bestSeason: 'September – March',
    rating: 4.9,
    reviewCount: 1284,
    featured: true,
    tags: ['Honeymoon', 'Family', 'Nature'],
    highlights: [
      'Private houseboat night on the Alleppey backwaters',
      'Sunrise walk through Munnar tea plantations',
      'Kathakali performance with backstage access',
      'Ayurvedic spa ritual at a heritage resort',
      'Canoe village tour through Kumarakom',
      'Fort Kochi heritage walk and Chinese fishing nets at dusk',
    ],
    itinerary: [
      ItineraryDay(
          day: 1,
          title: 'Arrival in Kochi',
          description:
              'Private transfer to a restored Dutch-era heritage hotel in Fort Kochi. Evening walk past St. Francis Church and the Chinese fishing nets, followed by a seafood dinner on the harbour.'),
      ItineraryDay(
          day: 2,
          title: 'Kochi to Munnar',
          description:
              'A cinematic four-hour climb into the Western Ghats, pausing at waterfalls and spice gardens. Check in to a plantation bungalow wrapped in tea.'),
      ItineraryDay(
          day: 3,
          title: 'Munnar tea country',
          description:
              'Sunrise at Top Station, a guided tasting at a working tea factory, and an afternoon at leisure among the terraces of Kolukkumalai.'),
      ItineraryDay(
          day: 4,
          title: 'Munnar to Alleppey',
          description:
              'Descend to the backwaters and board your private kettuvallam. Lunch is cooked aboard as you drift past paddy fields and village jetties.'),
      ItineraryDay(
          day: 5,
          title: 'Kumarakom',
          description:
              'Morning canoe through narrow village canals, then an Ayurvedic abhyanga ritual at a lakeside resort. Sunset over Vembanad Lake.'),
      ItineraryDay(
          day: 6,
          title: 'Departure',
          description:
              'A slow breakfast on the water before your private transfer to Kochi International Airport.'),
    ],
    included: [
      'Five nights in heritage and plantation stays',
      'Private exclusive-use houseboat with chef',
      'All transfers in a private chauffeured vehicle',
      'Daily breakfast and four curated dinners',
      'English-speaking destination host throughout',
      'Kathakali performance and tea factory access',
    ],
    excluded: [
      'Flights to and from Kochi',
      'Personal expenses and gratuities',
      'Travel insurance',
      'Lunches on days 2 and 3',
      'Camera fees at monuments',
    ],
    hotels: [
      Hotel(
          name: 'Brunton Boatyard',
          stars: 5,
          location: 'Fort Kochi',
          image: card('photo-1571896349842-33c89424de2d')),
      Hotel(
          name: 'Windermere Estate',
          stars: 4,
          location: 'Munnar',
          image: card('photo-1566073771259-6a8506099945')),
      Hotel(
          name: 'Kumarakom Lake Resort',
          stars: 5,
          location: 'Kumarakom',
          image: card('photo-1520250497591-112f2f40a3f4')),
    ],
    attractions: [
      Attraction(
          name: 'Athirappilly Falls',
          distance: '55 km from Kochi',
          description:
              'Kerala\'s largest waterfall, thundering through rainforest.'),
      Attraction(
          name: 'Eravikulam National Park',
          distance: '13 km from Munnar',
          description:
              'Home of the endangered Nilgiri tahr and rolling shola grasslands.'),
      Attraction(
          name: 'Marari Beach',
          distance: '15 km from Alleppey',
          description:
              'An undeveloped fishing coast of coconut palms and quiet sand.'),
    ],
    reviews: [
      Review(
          author: 'Ananya Iyer',
          origin: 'Bengaluru',
          rating: 5,
          comment:
              'The houseboat evening alone was worth the trip. Aurevia thought of everything — even the playlist on board matched the sunset.',
          monthYear: 'January 2026'),
      Review(
          author: 'James & Clara Whitmore',
          origin: 'London',
          rating: 5,
          comment:
              'Our honeymoon was flawless. The plantation bungalow in Munnar felt like a film set, and our host Vipin was extraordinary.',
          monthYear: 'November 2025'),
      Review(
          author: 'Rohit Menon',
          origin: 'Mumbai',
          rating: 4.5,
          comment:
              'Took my parents and my kids — every generation found something to love. Seamless logistics.',
          monthYear: 'December 2025'),
    ],
    latitude: 9.4981,
    longitude: 76.3388,
    seoTitle: 'Kerala Luxury Tour Packages — Backwaters, Munnar & Kochi',
    seoDescription:
        'Private houseboats, plantation stays and Ayurvedic rituals. Curated 6-day Kerala journeys by Aurevia.',
  ),
  Destination(
    id: 'd02',
    slug: 'kashmir',
    name: 'Kashmir',
    country: 'India',
    tagline: 'A valley the poets never exaggerated',
    overview:
        'Srinagar\'s houseboats, saffron fields of Pampore, the alpine amphitheatres of Gulmarg and Pahalgam — Kashmir remains the subcontinent\'s most romantic landscape. We arrange cedar-panelled houseboat suites on Dal Lake, private shikara flotillas at dawn, and mountain lunches served on meadows at ten thousand feet.',
    heroImage: img('photo-1566837945700-30057527ade0'),
    cardImage: card('photo-1566837945700-30057527ade0'),
    gallery: [
      img('photo-1506905925346-21bda4d32df4'),
      img('photo-1464822759023-fed622ff2c3b'),
      img('photo-1454496522488-7a8e488e8606'),
      img('photo-1483728642387-6c3bdd6c93e5'),
      img('photo-1469474968028-56623f02e42e'),
      img('photo-1447752875215-b2761acb3c5d'),
    ],
    videoUrl:
        'https://videos.pexels.com/video-files/3571264/3571264-uhd_3840_2160_30fps.mp4',
    priceFrom: 32000,
    days: 6,
    nights: 5,
    bestSeason: 'April – October',
    rating: 4.8,
    reviewCount: 942,
    featured: true,
    tags: ['Honeymoon', 'Adventure', 'Nature'],
    highlights: [
      'Cedar houseboat suite on Dal Lake',
      'Dawn shikara ride through the floating market',
      'Gulmarg gondola to Apharwat ridge',
      'Private meadow lunch in Pahalgam',
      'Mughal gardens after closing hours',
      'Saffron and pashmina ateliers with the makers',
    ],
    itinerary: [
      ItineraryDay(
          day: 1,
          title: 'Srinagar arrival',
          description:
              'Met at the tarmac and transferred by shikara to your houseboat suite. Kahwa tea on the deck as the light drops behind Hari Parbat.'),
      ItineraryDay(
          day: 2,
          title: 'Dal Lake & old Srinagar',
          description:
              'Dawn at the floating vegetable market, then the old city\'s papier-mâché and pashmina workshops. Evening in Nishat Bagh, opened privately.'),
      ItineraryDay(
          day: 3,
          title: 'Gulmarg',
          description:
              'Drive to the meadow of flowers. Ride the world\'s second-highest gondola and lunch at a slope-side chalet.'),
      ItineraryDay(
          day: 4,
          title: 'Pahalgam',
          description:
              'Through saffron country to the Lidder valley. Afternoon pony trek to Baisaran meadow, dinner beside the river.'),
      ItineraryDay(
          day: 5,
          title: 'Betaab & Aru valleys',
          description:
              'A slow day among pines and glacial streams with a private picnic. Return to Srinagar by evening.'),
      ItineraryDay(
          day: 6,
          title: 'Departure',
          description:
              'Breakfast on the water, a last walk through Shalimar Bagh, and your transfer to the airport.'),
    ],
    included: [
      'Two nights in a heritage houseboat suite',
      'Three nights in alpine resorts',
      'Private vehicle and driver throughout',
      'Gondola tickets to Apharwat',
      'Daily breakfast and dinner',
      'Destination host and all permits',
    ],
    excluded: [
      'Flights to and from Srinagar',
      'Pony rides and sledding',
      'Travel insurance',
      'Lunches except where noted',
      'Personal shopping',
    ],
    hotels: [
      Hotel(
          name: 'Sukoon Houseboat',
          stars: 5,
          location: 'Dal Lake',
          image: card('photo-1578683010236-d716f9a3f461')),
      Hotel(
          name: 'The Khyber Himalayan Resort',
          stars: 5,
          location: 'Gulmarg',
          image: card('photo-1542314831-068cd1dbfeeb')),
      Hotel(
          name: 'WelcomHotel Pine N Peak',
          stars: 4,
          location: 'Pahalgam',
          image: card('photo-1551882547-ff40c63fe5fa')),
    ],
    attractions: [
      Attraction(
          name: 'Sonamarg',
          distance: '80 km from Srinagar',
          description: 'The meadow of gold at the mouth of the Thajiwas glacier.'),
      Attraction(
          name: 'Doodhpathri',
          distance: '42 km from Srinagar',
          description: 'An untouched bowl of pasture and pine.'),
      Attraction(
          name: 'Shankaracharya Temple',
          distance: '8 km from Srinagar',
          description: 'A thousand-year-old shrine above the lake.'),
    ],
    reviews: [
      Review(
          author: 'Priya & Arjun Malhotra',
          origin: 'Delhi',
          rating: 5,
          comment:
              'The private evening in Nishat Bagh was pure cinema. Kashmir with Aurevia is a different country.',
          monthYear: 'May 2026'),
      Review(
          author: 'Sofia Lindqvist',
          origin: 'Stockholm',
          rating: 4.8,
          comment:
              'The houseboat, the kahwa, the mountains — I have never slept better anywhere.',
          monthYear: 'June 2026'),
    ],
    latitude: 34.0837,
    longitude: 74.7973,
    seoTitle: 'Kashmir Luxury Tours — Dal Lake Houseboats, Gulmarg & Pahalgam',
    seoDescription:
        'Heritage houseboats, private Mughal garden evenings and alpine meadows. 6-day Kashmir journeys by Aurevia.',
  ),
  Destination(
    id: 'd03',
    slug: 'goa',
    name: 'Goa',
    country: 'India',
    tagline: 'Susegad — the art of unhurried joy',
    overview:
        'Beyond the beach shacks lies another Goa: Indo-Portuguese mansions draped in bougainvillea, Latin Quarter lanes in Fontainhas, spice farms up the Mandovi and quiet southern sands where turtles still nest. We pair heritage stays with sunset sails, market breakfasts and tables at the state\'s finest kitchens.',
    heroImage: img('photo-1512343879784-a960bf40e7f2'),
    cardImage: card('photo-1512343879784-a960bf40e7f2'),
    gallery: [
      img('photo-1507525428034-b723cf961d3e'),
      img('photo-1519046904884-53103b34b206'),
      img('photo-1520454974749-611b7248ffdb'),
      img('photo-1530521954074-e64f6810b32d'),
      img('photo-1544551763-46a013bb70d5'),
      img('photo-1468413253725-0d5181091126'),
    ],
    videoUrl:
        'https://videos.pexels.com/video-files/1093662/1093662-hd_1920_1080_30fps.mp4',
    priceFrom: 18900,
    days: 5,
    nights: 4,
    bestSeason: 'November – February',
    rating: 4.7,
    reviewCount: 1567,
    featured: false,
    tags: ['Weekend', 'Family', 'Beach'],
    highlights: [
      'Private sunset catamaran on the Arabian Sea',
      'Fontainhas heritage walk with a local historian',
      'Table at a chef-led Goan-Portuguese kitchen',
      'Butterfly Beach by private boat',
      'Spice plantation lunch on banana leaf',
      'Old Goa basilicas before the crowds',
    ],
    itinerary: [
      ItineraryDay(
          day: 1,
          title: 'Arrival — South Goa',
          description:
              'Transfer to a beachfront heritage resort near Betalbatim. Evening at leisure on a quiet stretch of silver sand.'),
      ItineraryDay(
          day: 2,
          title: 'Old Goa & Fontainhas',
          description:
              'Basilica of Bom Jesus and Sé Cathedral at opening time, then a slow walk through the Latin Quarter with feni tasting and lunch at a heritage café.'),
      ItineraryDay(
          day: 3,
          title: 'Spice country',
          description:
              'Up the Mandovi to a working spice farm — cardamom, peppercorn, betel. Traditional lunch, afternoon river cruise past mangroves.'),
      ItineraryDay(
          day: 4,
          title: 'Islands & sunset sail',
          description:
              'Private boat to Butterfly and Honeymoon beaches. Golden hour aboard a catamaran with Goan canapés.'),
      ItineraryDay(
          day: 5,
          title: 'Departure',
          description:
              'Beach breakfast and a private transfer to Dabolim or Mopa airport.'),
    ],
    included: [
      'Four nights in a beachfront heritage resort',
      'Private catamaran sunset sail',
      'All excursions with private guide',
      'Daily breakfast and two signature dinners',
      'Airport transfers',
      'Spice plantation experience with lunch',
    ],
    excluded: [
      'Flights',
      'Alcohol beyond welcome drinks',
      'Water sports',
      'Travel insurance',
      'Personal expenses',
    ],
    hotels: [
      Hotel(
          name: 'Taj Exotica Resort & Spa',
          stars: 5,
          location: 'Benaulim',
          image: card('photo-1582719508461-905c673771fd')),
      Hotel(
          name: 'Ahilya by the Sea',
          stars: 4,
          location: 'Nerul',
          image: card('photo-1584132967334-10e028bd69f7')),
    ],
    attractions: [
      Attraction(
          name: 'Dudhsagar Falls',
          distance: '71 km from Panaji',
          description: 'A four-tiered cascade on the Mandovi, best after monsoon.'),
      Attraction(
          name: 'Chapora Fort',
          distance: '22 km from Panaji',
          description: 'Laterite ramparts with the coast\'s definitive sunset.'),
      Attraction(
          name: 'Divar Island',
          distance: '12 km from Panaji',
          description: 'Ferry-only island of whitewashed churches and paddy.'),
    ],
    reviews: [
      Review(
          author: 'Kabir & Naina Shah',
          origin: 'Pune',
          rating: 4.7,
          comment:
              'We thought we knew Goa. The Fontainhas walk and the catamaran evening proved otherwise.',
          monthYear: 'December 2025'),
      Review(
          author: 'Emily Harper',
          origin: 'Sydney',
          rating: 4.8,
          comment: 'Elegant, easy, and never touristy. The south coast is a dream.',
          monthYear: 'January 2026'),
    ],
    latitude: 15.2993,
    longitude: 74.1240,
    seoTitle: 'Goa Luxury Escapes — Heritage, Beaches & Sunset Sails',
    seoDescription:
        'Indo-Portuguese heritage, private boats and the quiet southern coast. Curated Goa escapes by Aurevia.',
  ),
  Destination(
    id: 'd04',
    slug: 'ladakh',
    name: 'Ladakh',
    country: 'India',
    tagline: 'The last great silence',
    overview:
        'A high-altitude desert of cobalt lakes, thousand-year-old gompas and passes that graze the sky. Our Ladakh journeys are built around acclimatisation and access — private monastery audiences, luxury camps on Pangong\'s shore, and drives over Khardung La with oxygen, chase vehicle and a crew that has done this a hundred times.',
    heroImage: img('photo-1506905925346-21bda4d32df4'),
    cardImage: card('photo-1506905925346-21bda4d32df4'),
    gallery: [
      img('photo-1464822759023-fed622ff2c3b'),
      img('photo-1469474968028-56623f02e42e'),
      img('photo-1454496522488-7a8e488e8606'),
      img('photo-1483728642387-6c3bdd6c93e5'),
      img('photo-1447752875215-b2761acb3c5d'),
      img('photo-1506744038136-46273834b3fb'),
    ],
    videoUrl:
        'https://videos.pexels.com/video-files/3571264/3571264-uhd_3840_2160_30fps.mp4',
    priceFrom: 38500,
    days: 7,
    nights: 6,
    bestSeason: 'June – September',
    rating: 4.9,
    reviewCount: 731,
    featured: true,
    tags: ['Adventure', 'Nature', 'Photography'],
    highlights: [
      'Luxury lakeshore camp at Pangong Tso',
      'Dawn prayers with the monks of Thiksey',
      'Khardung La — one of the world\'s highest motorable passes',
      'Bactrian camel ride in the Nubra dunes',
      'Rafting the Zanskar confluence',
      'Stargazing at 14,000 feet with an astronomer',
    ],
    itinerary: [
      ItineraryDay(
          day: 1,
          title: 'Fly into Leh',
          description:
              'The Himalaya from your window seat, then two slow days begin. Rest, hydrate, and watch the light on Stok Kangri from your terrace.'),
      ItineraryDay(
          day: 2,
          title: 'Leh acclimatisation',
          description:
              'Gentle morning at Shanti Stupa and Leh Palace, afternoon in the old town\'s bakeries and antique shops.'),
      ItineraryDay(
          day: 3,
          title: 'Monastery circuit',
          description:
              'Dawn prayers at Thiksey, the Indus valley\'s great gompas — Hemis, Stakna, Matho — and lunch in a village orchard.'),
      ItineraryDay(
          day: 4,
          title: 'Over Khardung La to Nubra',
          description:
              'Cross 17,582 feet into the valley of flowers. Evening among the double-humped camels on the Hunder dunes.'),
      ItineraryDay(
          day: 5,
          title: 'Nubra to Pangong',
          description:
              'The Shyok river road to Pangong Tso. Your camp sits on the lake\'s western shore; dinner under a sky thick with stars.'),
      ItineraryDay(
          day: 6,
          title: 'Pangong to Leh',
          description:
              'Sunrise as the lake runs through its blues, then back over Chang La with a stop at Hemis. Farewell dinner in Leh.'),
      ItineraryDay(
          day: 7,
          title: 'Departure',
          description: 'Morning flight out over the ranges.'),
    ],
    included: [
      'Six nights — boutique Leh stay and luxury camps',
      'Oxygen-equipped SUV with experienced mountain driver',
      'All inner line permits and monastery fees',
      'Full board throughout',
      'Astronomer-led stargazing session',
      'Destination host and 24/7 support',
    ],
    excluded: [
      'Flights to and from Leh',
      'Rafting (optional add-on)',
      'Travel insurance with high-altitude cover',
      'Tips and personal expenses',
      'Anything not in inclusions',
    ],
    hotels: [
      Hotel(
          name: 'The Grand Dragon',
          stars: 5,
          location: 'Leh',
          image: card('photo-1542314831-068cd1dbfeeb')),
      Hotel(
          name: 'TUTC Chamba Camp',
          stars: 5,
          location: 'Thiksey',
          image: card('photo-1504280390367-361c6d9f38f4')),
      Hotel(
          name: 'Pangong Sarai Luxury Camp',
          stars: 4,
          location: 'Pangong Tso',
          image: card('photo-1478131143081-80f7f84ca84d')),
    ],
    attractions: [
      Attraction(
          name: 'Magnetic Hill',
          distance: '27 km from Leh',
          description: 'The optical illusion where cars appear to roll uphill.'),
      Attraction(
          name: 'Alchi Monastery',
          distance: '66 km from Leh',
          description: 'Eleventh-century murals unmatched in the Himalaya.'),
      Attraction(
          name: 'Tso Moriri',
          distance: '220 km from Leh',
          description: 'A remoter, wilder twin to Pangong in Changthang.'),
    ],
    reviews: [
      Review(
          author: 'Aditya Rao',
          origin: 'Hyderabad',
          rating: 5,
          comment:
              'The stargazing night at Pangong rearranged something in me. Faultless organisation at brutal altitudes.',
          monthYear: 'August 2025'),
      Review(
          author: 'Marco Bianchi',
          origin: 'Milan',
          rating: 4.9,
          comment:
              'I\'ve done Patagonia and Iceland. Ladakh with this team tops both.',
          monthYear: 'July 2026'),
    ],
    latitude: 34.1526,
    longitude: 77.5771,
    seoTitle: 'Ladakh Expeditions — Pangong, Nubra & Khardung La in Comfort',
    seoDescription:
        'Luxury camps, monastery audiences and oxygen-equipped expeditions across the high Himalaya.',
  ),
  Destination(
    id: 'd05',
    slug: 'manali',
    name: 'Manali',
    country: 'India',
    tagline: 'Cedar forests, river mornings, mountain air',
    overview:
        'Old Manali\'s orchards and the Kullu valley\'s deodar forests make the Himalaya feel domestic and wild at once. We base you in a riverside lodge, send you paragliding over Solang, trekking to Jogini falls, and — in season — through the Atal tunnel to the stark beauty of Sissu and the Lahaul valley.',
    heroImage: img('photo-1464822759023-fed622ff2c3b'),
    cardImage: card('photo-1464822759023-fed622ff2c3b'),
    gallery: [
      img('photo-1454496522488-7a8e488e8606'),
      img('photo-1469474968028-56623f02e42e'),
      img('photo-1441974231531-c6227db76b6e'),
      img('photo-1470770841072-f978cf4d019e'),
      img('photo-1506905925346-21bda4d32df4'),
      img('photo-1447752875215-b2761acb3c5d'),
    ],
    videoUrl:
        'https://videos.pexels.com/video-files/1918465/1918465-uhd_3840_2160_24fps.mp4',
    priceFrom: 16500,
    days: 5,
    nights: 4,
    bestSeason: 'March – June, October – February',
    rating: 4.6,
    reviewCount: 1108,
    featured: false,
    tags: ['Adventure', 'Weekend', 'Honeymoon'],
    highlights: [
      'Riverside lodge beneath deodar forest',
      'Paragliding over the Solang valley',
      'Atal tunnel drive to Sissu waterfalls',
      'Hidimba temple and Old Manali cafés',
      'Private riverside bonfire with mountain barbecue',
      'Jogini falls forest trek',
    ],
    itinerary: [
      ItineraryDay(
          day: 1,
          title: 'Arrival',
          description:
              'Met in Kullu or at your Volvo drop point. Settle into a riverside lodge; evening walk through Old Manali\'s orchard lanes.'),
      ItineraryDay(
          day: 2,
          title: 'Solang valley',
          description:
              'Morning paragliding and ropeway, afternoon at Hidimba temple and the Tibetan monastery. Bonfire dinner by the Beas.'),
      ItineraryDay(
          day: 3,
          title: 'Lahaul day',
          description:
              'Through the Atal tunnel to Sissu — waterfalls, barley fields, and the Chandra river\'s glacier grey. Picnic lunch.'),
      ItineraryDay(
          day: 4,
          title: 'Forest trails',
          description:
              'Guided trek to Jogini falls through cedar and apple orchards. Afternoon at leisure with café time in Old Manali.'),
      ItineraryDay(
          day: 5,
          title: 'Departure',
          description: 'Slow breakfast and onward transfer.'),
    ],
    included: [
      'Four nights riverside boutique lodge',
      'Paragliding with certified pilots',
      'Private SUV for all excursions',
      'Daily breakfast and dinner',
      'Guided Jogini falls trek',
      'Bonfire evening with barbecue',
    ],
    excluded: [
      'Transport to Manali',
      'Ropeway tickets',
      'Lunches',
      'Travel insurance',
      'Snow gear rental in winter',
    ],
    hotels: [
      Hotel(
          name: 'Span Resort & Spa',
          stars: 4,
          location: 'Kullu–Manali Highway',
          image: card('photo-1520250497591-112f2f40a3f4')),
      Hotel(
          name: 'The Himalayan',
          stars: 4,
          location: 'Hadimba Road',
          image: card('photo-1551882547-ff40c63fe5fa')),
    ],
    attractions: [
      Attraction(
          name: 'Rohtang Pass',
          distance: '51 km from Manali',
          description: 'The storied gateway to Lahaul, snowbound most of the year.'),
      Attraction(
          name: 'Naggar Castle',
          distance: '21 km from Manali',
          description: 'A fifteenth-century timber castle above the Kullu valley.'),
      Attraction(
          name: 'Vashisht hot springs',
          distance: '3 km from Manali',
          description: 'Sulphur springs beside an ancient stone temple.'),
    ],
    reviews: [
      Review(
          author: 'Sneha Kulkarni',
          origin: 'Nagpur',
          rating: 4.6,
          comment:
              'Perfect long weekend. The lodge was gorgeous and the Sissu day felt like another planet.',
          monthYear: 'October 2025'),
      Review(
          author: 'Dhruv Kapoor',
          origin: 'Chandigarh',
          rating: 4.5,
          comment: 'Paragliding was superbly organised. Great valley knowledge.',
          monthYear: 'April 2026'),
    ],
    latitude: 32.2396,
    longitude: 77.1887,
    seoTitle: 'Manali Getaways — Solang, Sissu & Riverside Lodges',
    seoDescription:
        'Paragliding, cedar forests and the Atal tunnel to Lahaul. Curated Manali escapes by Aurevia.',
  ),
  Destination(
    id: 'd06',
    slug: 'ooty',
    name: 'Ooty',
    country: 'India',
    tagline: 'The blue mountains, taken slowly',
    overview:
        'The Nilgiris reward the unhurried: a UNESCO-listed toy train through eucalyptus and tea, colonial bungalows with fireplaces lit by six, and viewpoints where the hills genuinely turn blue at dusk. We add estate tastings, Toda village encounters and picnic hampers packed by your bungalow\'s kitchen.',
    heroImage: img('photo-1470770841072-f978cf4d019e'),
    cardImage: card('photo-1470770841072-f978cf4d019e'),
    gallery: [
      img('photo-1441974231531-c6227db76b6e'),
      img('photo-1470071459604-3b5ec3a7fe05'),
      img('photo-1504198453319-5ce911bafcde'),
      img('photo-1506744038136-46273834b3fb'),
      img('photo-1469474968028-56623f02e42e'),
      img('photo-1447752875215-b2761acb3c5d'),
    ],
    videoUrl:
        'https://videos.pexels.com/video-files/857251/857251-hd_1280_720_25fps.mp4',
    priceFrom: 14900,
    days: 4,
    nights: 3,
    bestSeason: 'October – June',
    rating: 4.5,
    reviewCount: 876,
    featured: false,
    tags: ['Family', 'Weekend', 'Nature'],
    highlights: [
      'Nilgiri Mountain Railway in a reserved coach',
      'Heritage bungalow stay with butler service',
      'Private tea estate tasting with the planter',
      'Doddabetta and Avalanche lake picnic',
      'Toda hamlet visit with an anthropologist guide',
      'Rose garden and botanical walk',
    ],
    itinerary: [
      ItineraryDay(
          day: 1,
          title: 'Up the mountain',
          description:
              'Board the toy train at Mettupalayam for the climb through Coonoor\'s tea. Check in to a Raj-era bungalow; scones by the fire.'),
      ItineraryDay(
          day: 2,
          title: 'Tea country',
          description:
              'Morning with a planter — plucking, withering, tasting. Afternoon at Sim\'s Park and the Dolphin\'s Nose viewpoint.'),
      ItineraryDay(
          day: 3,
          title: 'Lakes and peaks',
          description:
              'Doddabetta at dawn, then a hamper picnic at Avalanche lake. Evening boat on Ooty lake and the chocolate factory.'),
      ItineraryDay(
          day: 4,
          title: 'Departure',
          description: 'Botanical garden stroll before the drive down.'),
    ],
    included: [
      'Three nights heritage bungalow with butler',
      'Reserved toy train seats',
      'All drives in a private car',
      'Daily breakfast and dinner',
      'Estate tasting and picnic hamper',
      'All entry fees',
    ],
    excluded: [
      'Transport to Mettupalayam/Coimbatore',
      'Lunches except picnic day',
      'Travel insurance',
      'Personal expenses',
      'Horse rides at the lake',
    ],
    hotels: [
      Hotel(
          name: 'Savoy — IHCL SeleQtions',
          stars: 5,
          location: 'Ooty',
          image: card('photo-1571896349842-33c89424de2d')),
      Hotel(
          name: 'La Belle Vie',
          stars: 4,
          location: 'Coonoor',
          image: card('photo-1566073771259-6a8506099945')),
    ],
    attractions: [
      Attraction(
          name: 'Pykara falls',
          distance: '20 km from Ooty',
          description: 'Cascades through shola forest with boating below.'),
      Attraction(
          name: 'Mudumalai National Park',
          distance: '35 km from Ooty',
          description: 'Elephant and tiger country on the Mysore road.'),
      Attraction(
          name: 'Ketti valley',
          distance: '7 km from Ooty',
          description: 'One of the world\'s widest valleys, best at sunset.'),
    ],
    reviews: [
      Review(
          author: 'The Krishnamurthys',
          origin: 'Chennai',
          rating: 4.5,
          comment:
              'The bungalow and butler made it. Our children still talk about the toy train.',
          monthYear: 'May 2026'),
      Review(
          author: 'Alan Pereira',
          origin: 'Kochi',
          rating: 4.4,
          comment: 'Genteel and green. The estate tasting was a highlight.',
          monthYear: 'January 2026'),
    ],
    latitude: 11.4102,
    longitude: 76.6950,
    seoTitle: 'Ooty Heritage Escapes — Toy Train, Tea Estates & Bungalows',
    seoDescription:
        'Reserved toy-train coaches, planter tastings and Raj-era bungalows in the Nilgiris.',
  ),
  Destination(
    id: 'd07',
    slug: 'munnar',
    name: 'Munnar',
    country: 'India',
    tagline: 'An ocean of tea at five thousand feet',
    overview:
        'Munnar is what green dreams look like: fifty shades of it, combed into terraces that roll to the horizon. Stay in a planter\'s bungalow inside a working estate, walk to viewpoints before the mist lifts, and take dinner beside a fireplace as cicadas start in the valley below.',
    heroImage: img('photo-1504198453319-5ce911bafcde'),
    cardImage: card('photo-1504198453319-5ce911bafcde'),
    gallery: [
      img('photo-1470071459604-3b5ec3a7fe05'),
      img('photo-1441974231531-c6227db76b6e'),
      img('photo-1470770841072-f978cf4d019e'),
      img('photo-1506744038136-46273834b3fb'),
      img('photo-1602216056096-3b40cc0c9944'),
      img('photo-1476514525535-07fb3b4ae5f1'),
    ],
    videoUrl:
        'https://videos.pexels.com/video-files/857251/857251-hd_1280_720_25fps.mp4',
    priceFrom: 15900,
    days: 4,
    nights: 3,
    bestSeason: 'September – May',
    rating: 4.7,
    reviewCount: 964,
    featured: false,
    tags: ['Honeymoon', 'Nature', 'Weekend'],
    highlights: [
      'Planter\'s bungalow inside a working estate',
      'Kolukkumalai — the world\'s highest tea, by jeep at dawn',
      'Eravikulam National Park and the Nilgiri tahr',
      'Tea factory masterclass and tasting flight',
      'Candlelit estate dinner under the stars',
      'Spice route drive to Top Station',
    ],
    itinerary: [
      ItineraryDay(
          day: 1,
          title: 'Into the high ranges',
          description:
              'The climb from Kochi through waterfalls and cardamom country. Evening tea on your bungalow lawn as mist fills the valley.'),
      ItineraryDay(
          day: 2,
          title: 'Kolukkumalai dawn',
          description:
              'A 4 a.m. jeep to the world\'s highest organic tea estate for sunrise above the clouds. Factory masterclass, afternoon at leisure.'),
      ItineraryDay(
          day: 3,
          title: 'Eravikulam & Top Station',
          description:
              'Morning with the Nilgiri tahr on Rajamala\'s slopes, then the old spice route to Top Station\'s edge-of-the-world view. Candlelit dinner.'),
      ItineraryDay(
          day: 4,
          title: 'Departure',
          description: 'Estate walk and descent to Kochi.'),
    ],
    included: [
      'Three nights planter\'s bungalow, full board',
      'Kolukkumalai sunrise jeep safari',
      'Eravikulam entry and guide',
      'Private vehicle from Kochi and back',
      'Tea factory masterclass',
      'Candlelit estate dinner',
    ],
    excluded: [
      'Flights to Kochi',
      'Travel insurance',
      'Ayurvedic treatments',
      'Personal expenses',
      'Camera fees',
    ],
    hotels: [
      Hotel(
          name: 'Windermere Estate',
          stars: 4,
          location: 'Pothamedu',
          image: card('photo-1566073771259-6a8506099945')),
      Hotel(
          name: 'Fragrant Nature',
          stars: 5,
          location: 'Chithirapuram',
          image: card('photo-1582719508461-905c673771fd')),
    ],
    attractions: [
      Attraction(
          name: 'Mattupetty dam',
          distance: '10 km from Munnar',
          description: 'Boating between grassed hills and shola forest.'),
      Attraction(
          name: 'Attukal waterfalls',
          distance: '9 km from Munnar',
          description: 'A monsoon-fed fall framed by hills and tea.'),
      Attraction(
          name: 'Anamudi',
          distance: '13 km from Munnar',
          description: 'South India\'s highest peak, inside Eravikulam.'),
    ],
    reviews: [
      Review(
          author: 'Ishaan & Tara Bedi',
          origin: 'Gurgaon',
          rating: 4.9,
          comment:
              'The Kolukkumalai sunrise is the single best thing we have done in India.',
          monthYear: 'February 2026'),
      Review(
          author: 'Lakshmi Narayan',
          origin: 'Coimbatore',
          rating: 4.6,
          comment: 'Quiet, green, impeccably arranged.',
          monthYear: 'March 2026'),
    ],
    latitude: 10.0889,
    longitude: 77.0595,
    seoTitle: 'Munnar Tea Country — Planter Bungalows & Kolukkumalai Sunrises',
    seoDescription:
        'Estate stays, factory masterclasses and dawn above the clouds in Kerala\'s high ranges.',
  ),
  Destination(
    id: 'd08',
    slug: 'coorg',
    name: 'Coorg',
    country: 'India',
    tagline: 'Coffee, cardamom and Kodava hospitality',
    overview:
        'Kodagu — Coorg to the Raj — is a highland of coffee estates, sacred river sources and a martial people with a cuisine all their own. Stay on a working plantation, walk its shaded acres with the owner, raft the Barapole\'s rapids in season and eat pandi curry the way only a Kodava home makes it.',
    heroImage: img('photo-1441974231531-c6227db76b6e'),
    cardImage: card('photo-1441974231531-c6227db76b6e'),
    gallery: [
      img('photo-1470770841072-f978cf4d019e'),
      img('photo-1504198453319-5ce911bafcde'),
      img('photo-1470071459604-3b5ec3a7fe05'),
      img('photo-1447752875215-b2761acb3c5d'),
      img('photo-1506744038136-46273834b3fb'),
      img('photo-1469474968028-56623f02e42e'),
    ],
    videoUrl:
        'https://videos.pexels.com/video-files/1918465/1918465-uhd_3840_2160_24fps.mp4',
    priceFrom: 15500,
    days: 4,
    nights: 3,
    bestSeason: 'October – March',
    rating: 4.6,
    reviewCount: 689,
    featured: false,
    tags: ['Nature', 'Family', 'Weekend'],
    highlights: [
      'Plantation stay with the estate family',
      'Coffee walk and cupping session',
      'Abbey falls and Raja\'s seat at golden hour',
      'Dubare elephant camp on the Cauvery',
      'Kodava lunch in a heritage ainmane home',
      'Tibetan golden temple at Bylakuppe',
    ],
    itinerary: [
      ItineraryDay(
          day: 1,
          title: 'Arrival in coffee country',
          description:
              'Drive up from Mysore or Mangalore through betel and paddy. Estate tea on the verandah, evening birdsong.'),
      ItineraryDay(
          day: 2,
          title: 'The estate day',
          description:
              'Morning coffee walk — arabica, robusta, pepper vines — with a cupping session. Afternoon at Abbey falls and Raja\'s seat for sunset.'),
      ItineraryDay(
          day: 3,
          title: 'River and monastery',
          description:
              'Dubare elephant camp at bathing hour, coracle ride on the Cauvery, then the gilded prayer halls of Bylakuppe. Kodava lunch en route.'),
      ItineraryDay(
          day: 4,
          title: 'Departure',
          description: 'Estate breakfast and the drive down.'),
    ],
    included: [
      'Three nights plantation homestay, full board',
      'Coffee walk and cupping with the planter',
      'Private vehicle throughout',
      'Dubare and Bylakuppe excursion',
      'Traditional Kodava lunch experience',
      'All entry fees',
    ],
    excluded: [
      'Transport to Coorg',
      'White-water rafting (seasonal add-on)',
      'Travel insurance',
      'Personal expenses',
      'Alcohol',
    ],
    hotels: [
      Hotel(
          name: 'Old Kent Estates',
          stars: 4,
          location: 'Suntikoppa',
          image: card('photo-1520250497591-112f2f40a3f4')),
      Hotel(
          name: 'Evolve Back Coorg',
          stars: 5,
          location: 'Siddapura',
          image: card('photo-1582719508461-905c673771fd')),
    ],
    attractions: [
      Attraction(
          name: 'Talakaveri',
          distance: '48 km from Madikeri',
          description: 'The sacred source of the Cauvery on Brahmagiri hill.'),
      Attraction(
          name: 'Mandalpatti peak',
          distance: '18 km from Madikeri',
          description: 'Jeep-track summit above a sea of monsoon clouds.'),
      Attraction(
          name: 'Iruppu falls',
          distance: '48 km from Madikeri',
          description: 'A forest fall beside the Rameshwara temple.'),
    ],
    reviews: [
      Review(
          author: 'Vikram Nair',
          origin: 'Bengaluru',
          rating: 4.7,
          comment:
              'The estate family\'s table was the best meal of my year. Coorg done right.',
          monthYear: 'November 2025'),
      Review(
          author: 'Meera & Sanjay Hegde',
          origin: 'Mangalore',
          rating: 4.5,
          comment: 'Restful, fragrant, beautifully paced.',
          monthYear: 'December 2025'),
    ],
    latitude: 12.3375,
    longitude: 75.8069,
    seoTitle: 'Coorg Plantation Stays — Coffee Estates & Kodava Tables',
    seoDescription:
        'Working plantations, cupping sessions and the Cauvery\'s elephants in Kodagu.',
  ),
  Destination(
    id: 'd09',
    slug: 'jaipur',
    name: 'Jaipur',
    country: 'India',
    tagline: 'The pink city, palace doors ajar',
    overview:
        'Jaipur is theatre — Amber Fort\'s mirrored halls, the honeycomb of Hawa Mahal, bazaars dense with gemstones and block print. We open its quieter doors: private palace dinners, textile ateliers with master printers, dawn at Amber before the gates, and a hot-air balloon drifting over the Aravallis.',
    heroImage: img('photo-1477587458883-47145ed94245'),
    cardImage: card('photo-1477587458883-47145ed94245'),
    gallery: [
      img('photo-1599661046289-e31897846e41'),
      img('photo-1564507592333-c60657eea523'),
      img('photo-1524230507669-5ff97982bb5e'),
      img('photo-1587135941948-670b381f08ce'),
      img('photo-1530789253388-582c481c54b0'),
      img('photo-1506744038136-46273834b3fb'),
    ],
    videoUrl:
        'https://videos.pexels.com/video-files/2169880/2169880-uhd_3840_2160_30fps.mp4',
    priceFrom: 21900,
    days: 4,
    nights: 3,
    bestSeason: 'October – March',
    rating: 4.8,
    reviewCount: 1195,
    featured: true,
    tags: ['Heritage', 'Family', 'Luxury'],
    highlights: [
      'Amber Fort at opening hour, before the crowds',
      'Hot-air balloon over the Aravalli hills',
      'Private dinner in a heritage palace courtyard',
      'Block-print atelier with a master printer',
      'City Palace royal quarters with curator access',
      'Gem bazaar walk with a certified gemologist',
    ],
    itinerary: [
      ItineraryDay(
          day: 1,
          title: 'Arrival in the pink city',
          description:
              'Check in to a restored haveli. Evening rickshaw glide past Hawa Mahal lit for dusk, dinner on a bazaar rooftop.'),
      ItineraryDay(
          day: 2,
          title: 'Amber and the royal city',
          description:
              'Amber Fort at opening hour with a historian, Panna Meena stepwell, then City Palace\'s royal quarters and Jantar Mantar.'),
      ItineraryDay(
          day: 3,
          title: 'Balloons and bazaars',
          description:
              'Dawn balloon flight over forts and dunes. Later, a block-print atelier in Sanganer and the gem bazaar with an expert. Palace courtyard dinner.'),
      ItineraryDay(
          day: 4,
          title: 'Departure',
          description: 'Breakfast at the haveli, onward transfer.'),
    ],
    included: [
      'Three nights heritage haveli stay',
      'Hot-air balloon flight',
      'Historian-led Amber and City Palace visits',
      'Private palace courtyard dinner',
      'All transfers in a private car',
      'Daily breakfast',
    ],
    excluded: [
      'Flights or trains to Jaipur',
      'Lunches',
      'Travel insurance',
      'Shopping and personal expenses',
      'Monument camera fees',
    ],
    hotels: [
      Hotel(
          name: 'Samode Haveli',
          stars: 5,
          location: 'Gangapole',
          image: card('photo-1571896349842-33c89424de2d')),
      Hotel(
          name: 'Alila Fort Bishangarh',
          stars: 5,
          location: 'Bishangarh',
          image: card('photo-1542314831-068cd1dbfeeb')),
    ],
    attractions: [
      Attraction(
          name: 'Nahargarh Fort',
          distance: '9 km from Jaipur',
          description: 'The city\'s definitive sunset rampart.'),
      Attraction(
          name: 'Abhaneri stepwell',
          distance: '88 km from Jaipur',
          description: 'Chand Baori\'s thirteen-storey geometry.'),
      Attraction(
          name: 'Sambhar salt lake',
          distance: '80 km from Jaipur',
          description: 'Flamingos and salt flats shot straight from a dream.'),
    ],
    reviews: [
      Review(
          author: 'Charlotte Dubois',
          origin: 'Paris',
          rating: 5,
          comment:
              'The balloon at dawn over Amber — I have no words that do it justice.',
          monthYear: 'February 2026'),
      Review(
          author: 'Nikhil Choudhary',
          origin: 'Jaipur',
          rating: 4.7,
          comment:
              'I grew up here and they still showed me rooms I\'d never seen.',
          monthYear: 'December 2025'),
    ],
    latitude: 26.9124,
    longitude: 75.7873,
    seoTitle: 'Jaipur Royal Journeys — Amber at Dawn & Palace Dinners',
    seoDescription:
        'Historian-led forts, balloon flights and haveli stays in the pink city.',
  ),
  Destination(
    id: 'd10',
    slug: 'dubai',
    name: 'Dubai',
    country: 'United Arab Emirates',
    tagline: 'The future, with desert manners',
    overview:
        'Dubai runs on superlatives, but its best moments are quiet ones: falcons at dawn over the Empty Quarter\'s edge, the old creek\'s abra crossings, dinner at 122 storeys as the fountains bloom below. We balance the skyline with the sand — five-star towers and a night in a desert conservation reserve.',
    heroImage: img('photo-1512453979798-5ea266f8880c'),
    cardImage: card('photo-1512453979798-5ea266f8880c'),
    gallery: [
      img('photo-1518684079-3c830dcef090'),
      img('photo-1526495124232-a04e1849168c'),
      img('photo-1523816572877-2789929ae3ae'),
      img('photo-1489516408517-0c0a15662682'),
      img('photo-1512632578888-169bbbc64f33'),
      img('photo-1506744038136-46273834b3fb'),
    ],
    videoUrl:
        'https://videos.pexels.com/video-files/2169880/2169880-uhd_3840_2160_30fps.mp4',
    priceFrom: 58000,
    days: 5,
    nights: 4,
    bestSeason: 'November – March',
    rating: 4.8,
    reviewCount: 1436,
    featured: true,
    tags: ['Luxury', 'Family', 'International'],
    highlights: [
      'At the Top — Burj Khalifa level 148, priority access',
      'Night in a Bedouin-style desert conservation camp',
      'Falconry at dawn with a master falconer',
      'Old Dubai — creek abras, gold and spice souks',
      'Dinner with fountain views at Armani/Amal',
      'Museum of the Future timed entry',
    ],
    itinerary: [
      ItineraryDay(
          day: 1,
          title: 'Arrival',
          description:
              'Fast-track immigration and transfer to your Downtown tower. Evening at the Dubai Fountain and dinner overlooking the show.'),
      ItineraryDay(
          day: 2,
          title: 'Vertical city',
          description:
              'Burj Khalifa level 148 in the morning light, Museum of the Future after lunch, golden hour at the Palm\'s West Beach.'),
      ItineraryDay(
          day: 3,
          title: 'The old town',
          description:
              'Abra across the creek, gold and spice souks, Al Fahidi\'s wind-tower lanes and Emirati lunch at a heritage house. Marina yacht cruise at sunset.'),
      ItineraryDay(
          day: 4,
          title: 'Into the desert',
          description:
              'Out to a conservation reserve — dune drive, falconry, camel caravan at sunset, dinner under the stars and a night in canvas luxury.'),
      ItineraryDay(
          day: 5,
          title: 'Departure',
          description: 'Desert sunrise and transfer to DXB.'),
    ],
    included: [
      'Three nights five-star Downtown, one night desert camp',
      'Burj Khalifa level 148 tickets',
      'Falconry session and dune safari',
      'Private airport and city transfers',
      'Daily breakfast, desert dinner under the stars',
      'Marina sunset yacht cruise',
    ],
    excluded: [
      'International flights',
      'UAE visa fees',
      'Lunches and most dinners',
      'Travel insurance',
      'Theme park tickets',
    ],
    hotels: [
      Hotel(
          name: 'Address Downtown',
          stars: 5,
          location: 'Downtown Dubai',
          image: card('photo-1542314831-068cd1dbfeeb')),
      Hotel(
          name: 'Al Maha Desert Resort',
          stars: 5,
          location: 'Dubai Desert Conservation Reserve',
          image: card('photo-1504280390367-361c6d9f38f4')),
    ],
    attractions: [
      Attraction(
          name: 'Abu Dhabi day trip',
          distance: '140 km from Dubai',
          description: 'Sheikh Zayed Grand Mosque and the Louvre Abu Dhabi.'),
      Attraction(
          name: 'Hatta',
          distance: '130 km from Dubai',
          description: 'Kayaks and mountain trails in the Hajar range.'),
      Attraction(
          name: 'Global Village',
          distance: '20 km from Downtown',
          description: 'Ninety pavilions of food and folklore, in season.'),
    ],
    reviews: [
      Review(
          author: 'Farah Sheikh',
          origin: 'Karachi',
          rating: 4.9,
          comment:
              'The desert night rebalanced the whole trip — the skyline means more after the silence.',
          monthYear: 'January 2026'),
      Review(
          author: 'Daniel Okafor',
          origin: 'Lagos',
          rating: 4.7,
          comment: 'Level 148 with no queue. That\'s how Dubai should be done.',
          monthYear: 'December 2025'),
    ],
    latitude: 25.2048,
    longitude: 55.2708,
    seoTitle: 'Dubai Luxury Packages — Skyline, Souks & Desert Camps',
    seoDescription:
        'Burj Khalifa priority access, falconry at dawn and conservation-reserve nights.',
  ),
  Destination(
    id: 'd11',
    slug: 'bali',
    name: 'Bali',
    country: 'Indonesia',
    tagline: 'Island of a thousand temples, and one long exhale',
    overview:
        'Bali layers jungle, rice terrace and reef around a living Hindu culture that scents every morning with frangipani and incense. We base you between Ubud\'s green canyons and Uluwatu\'s clifftops: private villa pools, water temple blessings, sunrise on Mount Batur and dinners where the paddies glow gold.',
    heroImage: img('photo-1537996194471-e657df975ab4'),
    cardImage: card('photo-1537996194471-e657df975ab4'),
    gallery: [
      img('photo-1518548419970-58e3b4079ab2'),
      img('photo-1544644181-1484b3fdfc62'),
      img('photo-1552733407-5d5c46c3bb3b'),
      img('photo-1507525428034-b723cf961d3e'),
      img('photo-1519046904884-53103b34b206'),
      img('photo-1544551763-46a013bb70d5'),
    ],
    videoUrl:
        'https://videos.pexels.com/video-files/1093662/1093662-hd_1920_1080_30fps.mp4',
    priceFrom: 64500,
    days: 7,
    nights: 6,
    bestSeason: 'April – October',
    rating: 4.9,
    reviewCount: 1873,
    featured: true,
    tags: ['Honeymoon', 'Luxury', 'International'],
    highlights: [
      'Private pool villa in the Ubud jungle',
      'Water blessing ritual at Tirta Empul',
      'Sunrise trek (or jeep) up Mount Batur',
      'Tegallalang terraces before the day begins',
      'Uluwatu clifftop kecak fire dance at sunset',
      'Floating breakfast and couples spa ritual',
    ],
    itinerary: [
      ItineraryDay(
          day: 1,
          title: 'Arrival — Ubud',
          description:
              'VIP airport meet and the drive into the hills. Your villa\'s pool faces pure jungle; dinner is served on your deck.'),
      ItineraryDay(
          day: 2,
          title: 'Sacred water',
          description:
              'Morning blessing at Tirta Empul with a village priest, then Gunung Kawi\'s rock-cut shrines and lunch above the Petanu gorge.'),
      ItineraryDay(
          day: 3,
          title: 'Batur sunrise',
          description:
              'Pre-dawn ascent for sunrise over the caldera, hot springs after, and an afternoon nap you\'ve earned. Evening in Ubud\'s galleries.'),
      ItineraryDay(
          day: 4,
          title: 'Terraces and temples',
          description:
              'Tegallalang at first light, a Balinese cooking class in a family compound, and the monkey forest at closing time.'),
      ItineraryDay(
          day: 5,
          title: 'South to the cliffs',
          description:
              'Transfer to an Uluwatu clifftop resort. Sunset kecak fire dance at the temple, dinner on the rocks at Jimbaran bay.'),
      ItineraryDay(
          day: 6,
          title: 'Reef and swell',
          description:
              'Morning snorkel or surf lesson at Padang Padang, floating breakfast, couples spa ritual as the sun drops.'),
      ItineraryDay(
          day: 7,
          title: 'Departure',
          description: 'Slow morning and private transfer to DPS.'),
    ],
    included: [
      'Four nights Ubud pool villa, two nights clifftop resort',
      'All experiences with private driver-guide',
      'Batur sunrise with breakfast',
      'Couples spa ritual and floating breakfast',
      'Daily breakfast, three curated dinners',
      'VIP airport handling',
    ],
    excluded: [
      'International flights',
      'Indonesia visa on arrival',
      'Lunches except cooking class day',
      'Travel insurance',
      'Personal expenses',
    ],
    hotels: [
      Hotel(
          name: 'Hanging Gardens of Bali',
          stars: 5,
          location: 'Payangan, Ubud',
          image: card('photo-1571896349842-33c89424de2d')),
      Hotel(
          name: 'Six Senses Uluwatu',
          stars: 5,
          location: 'Uluwatu',
          image: card('photo-1582719508461-905c673771fd')),
    ],
    attractions: [
      Attraction(
          name: 'Nusa Penida',
          distance: '45 min by fast boat',
          description: 'Kelingking\'s T-rex cliff and manta bays.'),
      Attraction(
          name: 'Sidemen valley',
          distance: '40 km from Ubud',
          description: 'The Bali of thirty years ago, under Mount Agung.'),
      Attraction(
          name: 'Menjangan reef',
          distance: 'North-west national park',
          description: 'The island\'s clearest water and wall dives.'),
    ],
    reviews: [
      Review(
          author: 'Aisha & Omar Qureshi',
          origin: 'Dubai',
          rating: 5,
          comment:
              'The water blessing undid two years of city stress. A perfect honeymoon.',
          monthYear: 'September 2025'),
      Review(
          author: 'Rachel Kim',
          origin: 'Seoul',
          rating: 4.8,
          comment: 'Every transfer smooth, every table booked right.',
          monthYear: 'June 2026'),
    ],
    latitude: -8.5069,
    longitude: 115.2625,
    seoTitle: 'Bali Honeymoons & Escapes — Ubud Villas to Uluwatu Cliffs',
    seoDescription:
        'Pool villas, water temple blessings and Batur sunrises, privately guided.',
  ),
  Destination(
    id: 'd12',
    slug: 'maldives',
    name: 'Maldives',
    country: 'Maldives',
    tagline: 'One island, one resort, one shade of impossible blue',
    overview:
        'The Maldives perfected the argument for doing nothing: an overwater villa with a glass floor, a house reef three steps away, and horizons unbroken in every direction. We match you to the right atoll and resort — seaplane arrivals, sandbank picnics, sunset dolphin cruises and dinners below sea level.',
    heroImage: img('photo-1514282401047-d79a71a590e8'),
    cardImage: card('photo-1514282401047-d79a71a590e8'),
    gallery: [
      img('photo-1573843981267-be1999ff37cd'),
      img('photo-1544551763-46a013bb70d5'),
      img('photo-1507525428034-b723cf961d3e'),
      img('photo-1519046904884-53103b34b206'),
      img('photo-1476673160081-cf065607f449'),
      img('photo-1505118380757-91f5f5632de0'),
    ],
    videoUrl:
        'https://videos.pexels.com/video-files/2169880/2169880-uhd_3840_2160_30fps.mp4',
    priceFrom: 89000,
    days: 5,
    nights: 4,
    bestSeason: 'November – April',
    rating: 4.9,
    reviewCount: 1621,
    featured: true,
    tags: ['Honeymoon', 'Luxury', 'International'],
    highlights: [
      'Overwater villa with private pool and glass floor',
      'Seaplane transfer over the atolls',
      'Guided house-reef snorkel with a marine biologist',
      'Private sandbank picnic, just the two of you',
      'Sunset dolphin cruise',
      'Underwater restaurant dinner',
    ],
    itinerary: [
      ItineraryDay(
          day: 1,
          title: 'Seaplane in',
          description:
              'The forty-minute flight is the best welcome in travel. Champagne check-in, first swim off your villa deck.'),
      ItineraryDay(
          day: 2,
          title: 'The reef',
          description:
              'Morning snorkel safari with the resident marine biologist — turtles, rays, reef sharks. Afternoon spa over the lagoon.'),
      ItineraryDay(
          day: 3,
          title: 'Sandbank day',
          description:
              'Dropped by dhoni on a private sandbank with a hamper and a parasol. Evening dolphin cruise as the sky performs.'),
      ItineraryDay(
          day: 4,
          title: 'Blue at leisure',
          description:
              'Yours entirely — dive, kayak, or do gloriously little. Farewell dinner below the surface at the reef restaurant.'),
      ItineraryDay(
          day: 5,
          title: 'Departure',
          description: 'Last glass-floor morning and the seaplane to Malé.'),
    ],
    included: [
      'Four nights overwater pool villa, half board',
      'Return seaplane transfers',
      'Marine-biologist reef safari',
      'Private sandbank picnic',
      'Sunset dolphin cruise',
      'Underwater restaurant dinner',
    ],
    excluded: [
      'International flights to Malé',
      'Lunches and premium beverages',
      'Diving courses',
      'Travel insurance',
      'Green tax where applicable',
    ],
    hotels: [
      Hotel(
          name: 'Soneva Jani',
          stars: 5,
          location: 'Noonu Atoll',
          image: card('photo-1573843981267-be1999ff37cd')),
      Hotel(
          name: 'Conrad Maldives Rangali',
          stars: 5,
          location: 'South Ari Atoll',
          image: card('photo-1520250497591-112f2f40a3f4')),
    ],
    attractions: [
      Attraction(
          name: 'Hanifaru Bay',
          distance: 'Baa Atoll',
          description: 'Seasonal manta and whale-shark gatherings.'),
      Attraction(
          name: 'Malé old town',
          distance: 'Capital island',
          description: 'Coral-stone mosques and the fish market.'),
      Attraction(
          name: 'Vaadhoo bioluminescence',
          distance: 'Raa Atoll',
          description: 'The famous sea of stars on dark nights.'),
    ],
    reviews: [
      Review(
          author: 'Zara & Imran Ali',
          origin: 'London',
          rating: 5,
          comment:
              'The sandbank picnic was the most romantic hour of our lives. Nothing was too much trouble.',
          monthYear: 'March 2026'),
      Review(
          author: 'Hiroshi Tanaka',
          origin: 'Tokyo',
          rating: 4.9,
          comment: 'Resort selection was spot on. The reef is world class.',
          monthYear: 'February 2026'),
    ],
    latitude: 3.2028,
    longitude: 73.2207,
    seoTitle: 'Maldives Overwater Villas — Seaplanes, Reefs & Sandbanks',
    seoDescription:
        'Hand-matched resorts, marine-biologist safaris and dinners under the sea.',
  ),
  Destination(
    id: 'd13',
    slug: 'singapore',
    name: 'Singapore',
    country: 'Singapore',
    tagline: 'A garden that became a city',
    overview:
        'Singapore compresses a continent into an island: hawker stalls with Michelin stars, a rainforest inside an airport, supertrees that sing at night. Ideal for families and first international trips, our itineraries thread Gardens by the Bay, Sentosa and the shophouse neighbourhoods with zero friction.',
    heroImage: img('photo-1525625293386-3f8f99389edd'),
    cardImage: card('photo-1525625293386-3f8f99389edd'),
    gallery: [
      img('photo-1508964942454-1a56651d54ac'),
      img('photo-1496939376851-89342e90adcd'),
      img('photo-1490642914619-7955a3fd483c'),
      img('photo-1565967511849-76a60a516170'),
      img('photo-1506744038136-46273834b3fb'),
      img('photo-1530521954074-e64f6810b32d'),
    ],
    videoUrl:
        'https://videos.pexels.com/video-files/1093662/1093662-hd_1920_1080_30fps.mp4',
    priceFrom: 52000,
    days: 5,
    nights: 4,
    bestSeason: 'Year-round',
    rating: 4.7,
    reviewCount: 1342,
    featured: false,
    tags: ['Family', 'International', 'City'],
    highlights: [
      'Gardens by the Bay with Supertree Grove light show',
      'Universal Studios express passes',
      'Hawker trail with a food historian',
      'Night Safari tram with priority boarding',
      'Marina Bay Sands SkyPark at sunset',
      'Katong shophouse and Peranakan heritage walk',
    ],
    itinerary: [
      ItineraryDay(
          day: 1,
          title: 'Arrival',
          description:
              'Jewel\'s rain vortex on the way out of Changi. Evening at Marina Bay — SkyPark at golden hour, Spectra light show after.'),
      ItineraryDay(
          day: 2,
          title: 'Gardens and bays',
          description:
              'Cloud Forest and Flower Dome in the morning cool, ArtScience Museum after lunch, Supertree Grove rhapsody at night.'),
      ItineraryDay(
          day: 3,
          title: 'Sentosa',
          description:
              'Universal Studios with express passes, cable car across the harbour, sunset at Tanjong Beach.'),
      ItineraryDay(
          day: 4,
          title: 'Heritage and hawkers',
          description:
              'Katong\'s Peranakan shophouses, Chinatown and Little India with a food historian — chilli crab finale. Night Safari to close.'),
      ItineraryDay(
          day: 5,
          title: 'Departure',
          description: 'Orchard Road morning or straight to Jewel early.'),
    ],
    included: [
      'Four nights in a Marina Bay-view hotel',
      'Universal Studios with express passes',
      'Gardens by the Bay and Night Safari entries',
      'Hawker trail with historian guide',
      'Private airport transfers',
      'Daily breakfast',
    ],
    excluded: [
      'International flights',
      'Most lunches and dinners',
      'Travel insurance',
      'Personal shopping',
      'Optional attraction upgrades',
    ],
    hotels: [
      Hotel(
          name: 'Marina Bay Sands',
          stars: 5,
          location: 'Marina Bay',
          image: card('photo-1525625293386-3f8f99389edd')),
      Hotel(
          name: 'The Fullerton Hotel',
          stars: 5,
          location: 'Fullerton Square',
          image: card('photo-1542314831-068cd1dbfeeb')),
    ],
    attractions: [
      Attraction(
          name: 'Pulau Ubin',
          distance: 'Bumboat from Changi',
          description: 'Kampong Singapore, preserved on a bicycle-sized island.'),
      Attraction(
          name: 'Southern Ridges',
          distance: 'Harbourfront',
          description: 'Treetop walkways linking forest parks.'),
      Attraction(
          name: 'Tiong Bahru',
          distance: 'Central',
          description: 'Art-deco estate of bakeries and bookshops.'),
    ],
    reviews: [
      Review(
          author: 'The Guptas',
          origin: 'Ahmedabad',
          rating: 4.8,
          comment:
              'With two kids under ten this was flawless. Express passes were worth everything.',
          monthYear: 'May 2026'),
      Review(
          author: 'Wei Ling Tan',
          origin: 'Kuala Lumpur',
          rating: 4.6,
          comment: 'The hawker trail found stalls even I didn\'t know.',
          monthYear: 'April 2026'),
    ],
    latitude: 1.3521,
    longitude: 103.8198,
    seoTitle: 'Singapore Family Holidays — Gardens, Sentosa & Hawker Trails',
    seoDescription:
        'Express-pass theme parks, supertree nights and food-historian tours.',
  ),
  Destination(
    id: 'd14',
    slug: 'thailand',
    name: 'Thailand',
    country: 'Thailand',
    tagline: 'Golden temples, jade water, open kitchens',
    overview:
        'Thailand moves from Bangkok\'s gilded chaos to limestone bays where the sea turns to glass. Our route pairs the capital\'s temples and canal life with Phuket and Phang Nga\'s island world — longtail boats to Maya Bay at dawn, beach clubs at dusk, and massaman curry from its birthplace.',
    heroImage: img('photo-1528181304800-259b08848526'),
    cardImage: card('photo-1528181304800-259b08848526'),
    gallery: [
      img('photo-1552465011-b4e21bf6e79a'),
      img('photo-1506665531195-3566af2b4dfa'),
      img('photo-1507525428034-b723cf961d3e'),
      img('photo-1519046904884-53103b34b206'),
      img('photo-1544551763-46a013bb70d5'),
      img('photo-1476673160081-cf065607f449'),
    ],
    videoUrl:
        'https://videos.pexels.com/video-files/1093662/1093662-hd_1920_1080_30fps.mp4',
    priceFrom: 46500,
    days: 6,
    nights: 5,
    bestSeason: 'November – April',
    rating: 4.7,
    reviewCount: 1518,
    featured: false,
    tags: ['Family', 'Honeymoon', 'International'],
    highlights: [
      'Grand Palace and Wat Arun with a historian',
      'Longtail canal tour through Thonburi',
      'Phang Nga Bay by private speedboat at dawn',
      'Beachfront resort on Kata\'s golden crescent',
      'Thai cooking class in a Phuket home',
      'Old Phuket Town\'s Sino-Portuguese streets',
    ],
    itinerary: [
      ItineraryDay(
          day: 1,
          title: 'Bangkok arrival',
          description:
              'Riverside hotel check-in, sunset drinks facing Wat Arun, dinner at a canal-side kitchen.'),
      ItineraryDay(
          day: 2,
          title: 'Royal Bangkok',
          description:
              'Grand Palace and the Emerald Buddha early, Wat Pho\'s reclining giant, then longtails through Thonburi\'s canal life.'),
      ItineraryDay(
          day: 3,
          title: 'South to Phuket',
          description:
              'Morning flight, afternoon on Kata beach, sunset at the Karon viewpoint.'),
      ItineraryDay(
          day: 4,
          title: 'Phang Nga at dawn',
          description:
              'Private speedboat before the flotillas — James Bond island, Hong lagoons by canoe, lunch on Naka Yai.'),
      ItineraryDay(
          day: 5,
          title: 'Taste of the south',
          description:
              'Market-to-table cooking class in a local home, Old Phuket Town walk, farewell beach-club sunset.'),
      ItineraryDay(
          day: 6,
          title: 'Departure',
          description: 'Beach morning and transfer to HKT.'),
    ],
    included: [
      'Two nights Bangkok riverside, three nights Phuket beachfront',
      'Domestic flight Bangkok–Phuket',
      'Private Phang Nga speedboat charter',
      'Historian-led temple mornings',
      'Cooking class with market visit',
      'Daily breakfast and all transfers',
    ],
    excluded: [
      'International flights',
      'Most lunches and dinners',
      'Travel insurance',
      'Spa treatments',
      'Personal expenses',
    ],
    hotels: [
      Hotel(
          name: 'The Siam',
          stars: 5,
          location: 'Bangkok riverside',
          image: card('photo-1542314831-068cd1dbfeeb')),
      Hotel(
          name: 'The Shore at Katathani',
          stars: 5,
          location: 'Kata Noi, Phuket',
          image: card('photo-1582719508461-905c673771fd')),
    ],
    attractions: [
      Attraction(
          name: 'Ayutthaya',
          distance: '80 km from Bangkok',
          description: 'The ruined royal capital among banyan roots.'),
      Attraction(
          name: 'Similan Islands',
          distance: 'Boat from Khao Lak',
          description: 'Thailand\'s clearest dive water, in season.'),
      Attraction(
          name: 'Big Buddha',
          distance: '6 km from Chalong',
          description: 'Forty-five metres of white marble above the island.'),
    ],
    reviews: [
      Review(
          author: 'Neha & Vivaan Joshi',
          origin: 'Indore',
          rating: 4.8,
          comment:
              'Phang Nga before the crowds was magic. The kids graduated from pad thai to green curry.',
          monthYear: 'December 2025'),
      Review(
          author: 'Lucas Meyer',
          origin: 'Berlin',
          rating: 4.6,
          comment: 'Bangkok guide was outstanding. Smooth throughout.',
          monthYear: 'January 2026'),
    ],
    latitude: 7.8804,
    longitude: 98.3923,
    seoTitle: 'Thailand Journeys — Bangkok Temples to Phang Nga Bays',
    seoDescription:
        'Private speedboats, historian-led temples and beachfront Phuket stays.',
  ),
  Destination(
    id: 'd15',
    slug: 'switzerland',
    name: 'Switzerland',
    country: 'Switzerland',
    tagline: 'Punctual trains through impossible scenery',
    overview:
        'Switzerland is the world\'s most beautiful timetable: panoramic trains that thread glaciers, lakes with alps for walls, villages where cars were never invited. We build it around the Glacier Express, Zermatt\'s Matterhorn mornings, Interlaken\'s adventure valley and Lucerne\'s medieval waterfront.',
    heroImage: img('photo-1530122037265-a5f1f91d3b99'),
    cardImage: card('photo-1530122037265-a5f1f91d3b99'),
    gallery: [
      img('photo-1527668752968-14dc70a27c95'),
      img('photo-1506905925346-21bda4d32df4'),
      img('photo-1469474968028-56623f02e42e'),
      img('photo-1454496522488-7a8e488e8606'),
      img('photo-1464822759023-fed622ff2c3b'),
      img('photo-1447752875215-b2761acb3c5d'),
    ],
    videoUrl:
        'https://videos.pexels.com/video-files/3571264/3571264-uhd_3840_2160_30fps.mp4',
    priceFrom: 145000,
    days: 8,
    nights: 7,
    bestSeason: 'May – October, December – March',
    rating: 4.9,
    reviewCount: 987,
    featured: true,
    tags: ['Luxury', 'Honeymoon', 'International'],
    highlights: [
      'Glacier Express in Excellence Class',
      'Matterhorn sunrise from Gornergrat',
      'Jungfraujoch — Top of Europe',
      'Lake Lucerne paddle steamer cruise',
      'Chocolate and cheese masterclass in Gruyères',
      'Car-free Zermatt and Mürren villages',
    ],
    itinerary: [
      ItineraryDay(
          day: 1,
          title: 'Zürich to Lucerne',
          description:
              'Arrive and rail to Lucerne. Chapel Bridge, old-town frescoes, dinner on the lakefront.'),
      ItineraryDay(
          day: 2,
          title: 'Lake Lucerne',
          description:
              'Paddle steamer to Vitznau, cogwheel up Rigi for the classic panorama, fondue back in town.'),
      ItineraryDay(
          day: 3,
          title: 'Interlaken',
          description:
              'GoldenPass line through the Brünig pass. Afternoon at Lake Brienz\'s turquoise, evening in Unterseen\'s lanes.'),
      ItineraryDay(
          day: 4,
          title: 'Jungfraujoch',
          description:
              'The railway through the Eiger to 3,454 metres — ice palace, glacier plateau. Cliffside Mürren by cable car on the return.'),
      ItineraryDay(
          day: 5,
          title: 'To Zermatt',
          description:
              'Rail through the Rhône valley to the car-free village under the Matterhorn. Electric-taxi arrival, first sight of the peak.'),
      ItineraryDay(
          day: 6,
          title: 'Gornergrat sunrise',
          description:
              'Dawn cogwheel to 3,089 metres as the Matterhorn catches fire. Afternoon walk to Riffelsee\'s mirror.'),
      ItineraryDay(
          day: 7,
          title: 'Glacier Express',
          description:
              'The famous eight-hour crossing to St. Moritz in Excellence Class — 291 bridges, 91 tunnels, five-course lunch at your seat.'),
      ItineraryDay(
          day: 8,
          title: 'Departure',
          description: 'Engadin morning and rail to Zürich airport.'),
    ],
    included: [
      'Seven nights four/five-star alpine hotels',
      'Swiss Travel Pass first class',
      'Glacier Express Excellence Class with lunch',
      'Jungfraujoch and Gornergrat tickets',
      'Gruyères masterclass',
      'Daily breakfast and four dinners',
    ],
    excluded: [
      'International flights',
      'Schengen visa fees',
      'Most lunches',
      'Travel insurance',
      'Ski passes and rentals',
    ],
    hotels: [
      Hotel(
          name: 'Hotel Schweizerhof',
          stars: 5,
          location: 'Lucerne',
          image: card('photo-1542314831-068cd1dbfeeb')),
      Hotel(
          name: 'Victoria-Jungfrau Grand',
          stars: 5,
          location: 'Interlaken',
          image: card('photo-1571896349842-33c89424de2d')),
      Hotel(
          name: 'Mont Cervin Palace',
          stars: 5,
          location: 'Zermatt',
          image: card('photo-1551882547-ff40c63fe5fa')),
    ],
    attractions: [
      Attraction(
          name: 'Lauterbrunnen valley',
          distance: '12 km from Interlaken',
          description: 'Seventy-two waterfalls in one glacial trench.'),
      Attraction(
          name: 'Aletsch glacier',
          distance: 'Above Fiesch',
          description: 'The Alps\' longest river of ice, UNESCO-listed.'),
      Attraction(
          name: 'St. Moritz',
          distance: 'Engadin valley',
          description: 'The original winter resort, champagne air included.'),
    ],
    reviews: [
      Review(
          author: 'Rajeev & Sunita Talwar',
          origin: 'Delhi',
          rating: 5,
          comment:
              'Excellence Class on the Glacier Express is the finest day of travel money can buy.',
          monthYear: 'June 2026'),
      Review(
          author: 'Grace Chen',
          origin: 'Singapore',
          rating: 4.9,
          comment:
              'Every train, every seat reservation, every transfer — perfect.',
          monthYear: 'September 2025'),
    ],
    latitude: 46.8182,
    longitude: 8.2275,
    seoTitle: 'Switzerland by Rail — Glacier Express, Zermatt & Jungfrau',
    seoDescription:
        'Excellence Class rail journeys, Matterhorn sunrises and lakefront grand hotels.',
  ),
];
