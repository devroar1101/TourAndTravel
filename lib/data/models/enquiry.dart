import 'package:equatable/equatable.dart';

/// Lifecycle of an enquiry in the admin pipeline.
enum EnquiryStatus {
  fresh('new', 'New'),
  contacted('contacted', 'Contacted'),
  quoted('quoted', 'Quoted'),
  confirmed('confirmed', 'Confirmed'),
  completed('completed', 'Completed'),
  cancelled('cancelled', 'Cancelled');

  const EnquiryStatus(this.dbValue, this.label);

  final String dbValue;
  final String label;

  static EnquiryStatus fromDb(String value) => EnquiryStatus.values
      .firstWhere((e) => e.dbValue == value, orElse: () => EnquiryStatus.fresh);
}

/// A travel enquiry submitted through the public form.
class Enquiry extends Equatable {
  const Enquiry({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.destination,
    required this.travelDate,
    required this.adults,
    required this.children,
    required this.budget,
    required this.specialRequirements,
    required this.message,
    required this.status,
    required this.notes,
    required this.createdAt,
  });

  final String id;
  final String name;
  final String phone;
  final String email;
  final String destination;
  final DateTime? travelDate;
  final int adults;
  final int children;
  final String budget;
  final String specialRequirements;
  final String message;
  final EnquiryStatus status;
  final String notes;
  final DateTime createdAt;

  factory Enquiry.fromJson(Map<String, dynamic> json) => Enquiry(
        id: json['id'].toString(),
        name: json['name'] as String,
        phone: json['phone'] as String? ?? '',
        email: json['email'] as String? ?? '',
        destination: json['destination'] as String? ?? '',
        travelDate: json['travel_date'] != null
            ? DateTime.tryParse(json['travel_date'].toString())
            : null,
        adults: (json['adults'] as num?)?.toInt() ?? 1,
        children: (json['children'] as num?)?.toInt() ?? 0,
        budget: json['budget'] as String? ?? '',
        specialRequirements: json['special_requirements'] as String? ?? '',
        message: json['message'] as String? ?? '',
        status: EnquiryStatus.fromDb(json['status'] as String? ?? 'new'),
        notes: json['notes'] as String? ?? '',
        createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ??
            DateTime.now(),
      );

  /// Payload for inserting a fresh enquiry (server assigns id/status/date).
  Map<String, dynamic> toInsertJson() => {
        'name': name,
        'phone': phone,
        'email': email,
        'destination': destination,
        'travel_date': travelDate?.toIso8601String().substring(0, 10),
        'adults': adults,
        'children': children,
        'budget': budget,
        'special_requirements': specialRequirements,
        'message': message,
      };

  Enquiry copyWith({EnquiryStatus? status, String? notes}) => Enquiry(
        id: id,
        name: name,
        phone: phone,
        email: email,
        destination: destination,
        travelDate: travelDate,
        adults: adults,
        children: children,
        budget: budget,
        specialRequirements: specialRequirements,
        message: message,
        status: status ?? this.status,
        notes: notes ?? this.notes,
        createdAt: createdAt,
      );

  @override
  List<Object?> get props => [id, status, notes];
}
