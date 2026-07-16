import 'package:equatable/equatable.dart';

/// One day inside a destination itinerary.
class ItineraryDay extends Equatable {
  const ItineraryDay({
    required this.day,
    required this.title,
    required this.description,
  });

  final int day;
  final String title;
  final String description;

  factory ItineraryDay.fromJson(Map<String, dynamic> json) => ItineraryDay(
        day: (json['day'] as num).toInt(),
        title: json['title'] as String,
        description: json['description'] as String,
      );

  Map<String, dynamic> toJson() =>
      {'day': day, 'title': title, 'description': description};

  @override
  List<Object?> get props => [day, title, description];
}

/// A partner hotel featured on a destination page.
class Hotel extends Equatable {
  const Hotel({
    required this.name,
    required this.stars,
    required this.location,
    required this.image,
  });

  final String name;
  final int stars;
  final String location;
  final String image;

  factory Hotel.fromJson(Map<String, dynamic> json) => Hotel(
        name: json['name'] as String,
        stars: (json['stars'] as num).toInt(),
        location: json['location'] as String,
        image: json['image'] as String,
      );

  Map<String, dynamic> toJson() =>
      {'name': name, 'stars': stars, 'location': location, 'image': image};

  @override
  List<Object?> get props => [name, stars, location, image];
}

/// A nearby attraction worth a detour.
class Attraction extends Equatable {
  const Attraction({
    required this.name,
    required this.distance,
    required this.description,
  });

  final String name;
  final String distance;
  final String description;

  factory Attraction.fromJson(Map<String, dynamic> json) => Attraction(
        name: json['name'] as String,
        distance: json['distance'] as String,
        description: json['description'] as String,
      );

  Map<String, dynamic> toJson() =>
      {'name': name, 'distance': distance, 'description': description};

  @override
  List<Object?> get props => [name, distance, description];
}

/// A guest review shown on the destination detail page.
class Review extends Equatable {
  const Review({
    required this.author,
    required this.origin,
    required this.rating,
    required this.comment,
    required this.monthYear,
  });

  final String author;
  final String origin;
  final double rating;
  final String comment;
  final String monthYear;

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        author: json['author'] as String,
        origin: json['origin'] as String,
        rating: (json['rating'] as num).toDouble(),
        comment: json['comment'] as String,
        monthYear: json['month_year'] as String,
      );

  Map<String, dynamic> toJson() => {
        'author': author,
        'origin': origin,
        'rating': rating,
        'comment': comment,
        'month_year': monthYear,
      };

  @override
  List<Object?> get props => [author, origin, rating, comment, monthYear];
}

/// A travel destination with the full editorial payload used by both the
/// card grid and the detail page.
class Destination extends Equatable {
  const Destination({
    required this.id,
    required this.slug,
    required this.name,
    required this.country,
    required this.tagline,
    required this.overview,
    required this.heroImage,
    required this.cardImage,
    required this.gallery,
    required this.videoUrl,
    required this.priceFrom,
    required this.days,
    required this.nights,
    required this.bestSeason,
    required this.rating,
    required this.reviewCount,
    required this.featured,
    required this.tags,
    required this.highlights,
    required this.itinerary,
    required this.included,
    required this.excluded,
    required this.hotels,
    required this.attractions,
    required this.reviews,
    required this.latitude,
    required this.longitude,
    this.seoTitle = '',
    this.seoDescription = '',
  });

  final String id;
  final String slug;
  final String name;
  final String country;
  final String tagline;
  final String overview;
  final String heroImage;
  final String cardImage;
  final List<String> gallery;
  final String videoUrl;
  final int priceFrom;
  final int days;
  final int nights;
  final String bestSeason;
  final double rating;
  final int reviewCount;
  final bool featured;
  final List<String> tags;
  final List<String> highlights;
  final List<ItineraryDay> itinerary;
  final List<String> included;
  final List<String> excluded;
  final List<Hotel> hotels;
  final List<Attraction> attractions;
  final List<Review> reviews;
  final double latitude;
  final double longitude;
  final String seoTitle;
  final String seoDescription;

  bool get isInternational => country != 'India';

  factory Destination.fromJson(Map<String, dynamic> json) => Destination(
        id: json['id'].toString(),
        slug: json['slug'] as String,
        name: json['name'] as String,
        country: json['country'] as String,
        tagline: json['tagline'] as String? ?? '',
        overview: json['overview'] as String? ?? '',
        heroImage: json['hero_image'] as String? ?? '',
        cardImage: json['card_image'] as String? ?? '',
        gallery: _stringList(json['gallery']),
        videoUrl: json['video_url'] as String? ?? '',
        priceFrom: (json['price_from'] as num?)?.toInt() ?? 0,
        days: (json['days'] as num?)?.toInt() ?? 0,
        nights: (json['nights'] as num?)?.toInt() ?? 0,
        bestSeason: json['best_season'] as String? ?? '',
        rating: (json['rating'] as num?)?.toDouble() ?? 0,
        reviewCount: (json['review_count'] as num?)?.toInt() ?? 0,
        featured: json['featured'] as bool? ?? false,
        tags: _stringList(json['tags']),
        highlights: _stringList(json['highlights']),
        itinerary: _mapList(json['itinerary'], ItineraryDay.fromJson),
        included: _stringList(json['included']),
        excluded: _stringList(json['excluded']),
        hotels: _mapList(json['hotels'], Hotel.fromJson),
        attractions: _mapList(json['attractions'], Attraction.fromJson),
        reviews: _mapList(json['reviews'], Review.fromJson),
        latitude: (json['latitude'] as num?)?.toDouble() ?? 0,
        longitude: (json['longitude'] as num?)?.toDouble() ?? 0,
        seoTitle: json['seo_title'] as String? ?? '',
        seoDescription: json['seo_description'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'slug': slug,
        'name': name,
        'country': country,
        'tagline': tagline,
        'overview': overview,
        'hero_image': heroImage,
        'card_image': cardImage,
        'gallery': gallery,
        'video_url': videoUrl,
        'price_from': priceFrom,
        'days': days,
        'nights': nights,
        'best_season': bestSeason,
        'rating': rating,
        'review_count': reviewCount,
        'featured': featured,
        'tags': tags,
        'highlights': highlights,
        'itinerary': itinerary.map((e) => e.toJson()).toList(),
        'included': included,
        'excluded': excluded,
        'hotels': hotels.map((e) => e.toJson()).toList(),
        'attractions': attractions.map((e) => e.toJson()).toList(),
        'reviews': reviews.map((e) => e.toJson()).toList(),
        'latitude': latitude,
        'longitude': longitude,
        'seo_title': seoTitle,
        'seo_description': seoDescription,
      };

  Destination copyWith({
    String? name,
    String? tagline,
    String? overview,
    String? heroImage,
    String? cardImage,
    List<String>? gallery,
    String? videoUrl,
    int? priceFrom,
    int? days,
    int? nights,
    String? bestSeason,
    bool? featured,
    String? seoTitle,
    String? seoDescription,
  }) {
    return Destination(
      id: id,
      slug: slug,
      name: name ?? this.name,
      country: country,
      tagline: tagline ?? this.tagline,
      overview: overview ?? this.overview,
      heroImage: heroImage ?? this.heroImage,
      cardImage: cardImage ?? this.cardImage,
      gallery: gallery ?? this.gallery,
      videoUrl: videoUrl ?? this.videoUrl,
      priceFrom: priceFrom ?? this.priceFrom,
      days: days ?? this.days,
      nights: nights ?? this.nights,
      bestSeason: bestSeason ?? this.bestSeason,
      rating: rating,
      reviewCount: reviewCount,
      featured: featured ?? this.featured,
      tags: tags,
      highlights: highlights,
      itinerary: itinerary,
      included: included,
      excluded: excluded,
      hotels: hotels,
      attractions: attractions,
      reviews: reviews,
      latitude: latitude,
      longitude: longitude,
      seoTitle: seoTitle ?? this.seoTitle,
      seoDescription: seoDescription ?? this.seoDescription,
    );
  }

  static List<String> _stringList(dynamic value) =>
      (value as List?)?.map((e) => e.toString()).toList() ?? const [];

  static List<T> _mapList<T>(
    dynamic value,
    T Function(Map<String, dynamic>) fromJson,
  ) =>
      (value as List?)
          ?.map((e) => fromJson(Map<String, dynamic>.from(e as Map)))
          .toList() ??
      const [];

  @override
  List<Object?> get props => [id, slug, name];
}
