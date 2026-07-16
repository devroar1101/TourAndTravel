import 'package:equatable/equatable.dart';

/// The curated collection a package belongs to.
enum PackageCategory {
  luxury('Luxury', 'Suites, private transfers, and unhurried days'),
  adventure('Adventure', 'Peaks, rapids, and trails less travelled'),
  family('Family', 'Journeys designed for every generation'),
  honeymoon('Honeymoon', 'Beginnings written in golden light'),
  weekend('Weekend', 'Short escapes, fully realised'),
  international('International', 'The world, arranged'),
  budget('Budget', 'Thoughtful travel, honest pricing'),
  premium('Premium', 'A step above in every detail'),
  vip('VIP', 'Doors that open only by invitation');

  const PackageCategory(this.label, this.subtitle);

  final String label;
  final String subtitle;

  static PackageCategory fromName(String name) =>
      PackageCategory.values.firstWhere(
        (e) => e.name == name,
        orElse: () => PackageCategory.luxury,
      );
}

/// A bookable tour package built from one or more destinations.
class TourPackage extends Equatable {
  const TourPackage({
    required this.id,
    required this.slug,
    required this.name,
    required this.category,
    required this.description,
    required this.image,
    required this.price,
    required this.days,
    required this.nights,
    required this.route,
    required this.highlights,
    required this.featured,
    required this.rating,
  });

  final String id;
  final String slug;
  final String name;
  final PackageCategory category;
  final String description;
  final String image;
  final int price;
  final int days;
  final int nights;
  final List<String> route;
  final List<String> highlights;
  final bool featured;
  final double rating;

  factory TourPackage.fromJson(Map<String, dynamic> json) => TourPackage(
        id: json['id'].toString(),
        slug: json['slug'] as String,
        name: json['name'] as String,
        category: PackageCategory.fromName(json['category'] as String? ?? ''),
        description: json['description'] as String? ?? '',
        image: json['image'] as String? ?? '',
        price: (json['price'] as num?)?.toInt() ?? 0,
        days: (json['days'] as num?)?.toInt() ?? 0,
        nights: (json['nights'] as num?)?.toInt() ?? 0,
        route: (json['route'] as List?)?.map((e) => e.toString()).toList() ??
            const [],
        highlights:
            (json['highlights'] as List?)?.map((e) => e.toString()).toList() ??
                const [],
        featured: json['featured'] as bool? ?? false,
        rating: (json['rating'] as num?)?.toDouble() ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'slug': slug,
        'name': name,
        'category': category.name,
        'description': description,
        'image': image,
        'price': price,
        'days': days,
        'nights': nights,
        'route': route,
        'highlights': highlights,
        'featured': featured,
        'rating': rating,
      };

  TourPackage copyWith({
    String? name,
    PackageCategory? category,
    String? description,
    String? image,
    int? price,
    int? days,
    int? nights,
    bool? featured,
  }) =>
      TourPackage(
        id: id,
        slug: slug,
        name: name ?? this.name,
        category: category ?? this.category,
        description: description ?? this.description,
        image: image ?? this.image,
        price: price ?? this.price,
        days: days ?? this.days,
        nights: nights ?? this.nights,
        route: route,
        highlights: highlights,
        featured: featured ?? this.featured,
        rating: rating,
      );

  @override
  List<Object?> get props => [id, slug, name, category];
}
