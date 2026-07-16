import 'package:equatable/equatable.dart';

/// A photograph in the masonry gallery.
class GalleryItem extends Equatable {
  const GalleryItem({
    required this.id,
    required this.image,
    required this.caption,
    required this.location,
    required this.category,
    required this.aspectRatio,
  });

  final String id;
  final String image;
  final String caption;
  final String location;
  final String category;

  /// Width / height hint so the masonry layout is stable before load.
  final double aspectRatio;

  factory GalleryItem.fromJson(Map<String, dynamic> json) => GalleryItem(
        id: json['id'].toString(),
        image: json['image'] as String,
        caption: json['caption'] as String? ?? '',
        location: json['location'] as String? ?? '',
        category: json['category'] as String? ?? 'All',
        aspectRatio: (json['aspect_ratio'] as num?)?.toDouble() ?? 1.0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'image': image,
        'caption': caption,
        'location': location,
        'category': category,
        'aspect_ratio': aspectRatio,
      };

  GalleryItem copyWith({String? image, String? caption, String? location}) =>
      GalleryItem(
        id: id,
        image: image ?? this.image,
        caption: caption ?? this.caption,
        location: location ?? this.location,
        category: category,
        aspectRatio: aspectRatio,
      );

  @override
  List<Object?> get props => [id, image];
}

/// A traveller testimonial.
class Testimonial extends Equatable {
  const Testimonial({
    required this.id,
    required this.name,
    required this.origin,
    required this.avatar,
    required this.rating,
    required this.quote,
    required this.tripName,
  });

  final String id;
  final String name;
  final String origin;
  final String avatar;
  final double rating;
  final String quote;
  final String tripName;

  factory Testimonial.fromJson(Map<String, dynamic> json) => Testimonial(
        id: json['id'].toString(),
        name: json['name'] as String,
        origin: json['origin'] as String? ?? '',
        avatar: json['avatar'] as String? ?? '',
        rating: (json['rating'] as num?)?.toDouble() ?? 5,
        quote: json['quote'] as String? ?? '',
        tripName: json['trip_name'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'origin': origin,
        'avatar': avatar,
        'rating': rating,
        'quote': quote,
        'trip_name': tripName,
      };

  Testimonial copyWith({String? name, String? quote, double? rating}) =>
      Testimonial(
        id: id,
        name: name ?? this.name,
        origin: origin,
        avatar: avatar,
        rating: rating ?? this.rating,
        quote: quote ?? this.quote,
        tripName: tripName,
      );

  @override
  List<Object?> get props => [id, name];
}

/// A frequently asked question.
class FaqItem extends Equatable {
  const FaqItem({
    required this.id,
    required this.question,
    required this.answer,
    required this.category,
  });

  final String id;
  final String question;
  final String answer;
  final String category;

  factory FaqItem.fromJson(Map<String, dynamic> json) => FaqItem(
        id: json['id'].toString(),
        question: json['question'] as String,
        answer: json['answer'] as String,
        category: json['category'] as String? ?? 'General',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'question': question,
        'answer': answer,
        'category': category,
      };

  FaqItem copyWith({String? question, String? answer, String? category}) =>
      FaqItem(
        id: id,
        question: question ?? this.question,
        answer: answer ?? this.answer,
        category: category ?? this.category,
      );

  @override
  List<Object?> get props => [id, question];
}
