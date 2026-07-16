import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/enquiry.dart';

/// Enquiries — public submission plus the full admin pipeline.
class EnquiryRepository {
  EnquiryRepository(this._client);

  final SupabaseClient? _client;

  static final List<Enquiry> _memory = _seedEnquiries();

  Future<void> submit(Enquiry enquiry) async {
    final client = _client;
    if (client == null) {
      _memory.insert(
        0,
        Enquiry.fromJson({
          ...enquiry.toInsertJson(),
          'id': 'e${DateTime.now().microsecondsSinceEpoch}',
          'status': 'new',
          'created_at': DateTime.now().toIso8601String(),
        }),
      );
      return;
    }
    await client.from('enquiries').insert(enquiry.toInsertJson());
    // Fire the confirmation email; a delivery hiccup must not fail the
    // submission itself.
    try {
      await client.functions.invoke(
        'send-enquiry-email',
        body: {'email': enquiry.email, 'name': enquiry.name},
      );
    } catch (_) {}
  }

  Future<List<Enquiry>> fetchAll() async {
    final client = _client;
    if (client == null) return List.unmodifiable(_memory);
    final rows = await client
        .from('enquiries')
        .select()
        .isFilter('deleted_at', null)
        .order('created_at', ascending: false);
    return (rows as List)
        .map((e) => Enquiry.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<void> updateStatus(String id, EnquiryStatus status) async {
    final client = _client;
    if (client == null) {
      final index = _memory.indexWhere((e) => e.id == id);
      if (index >= 0) _memory[index] = _memory[index].copyWith(status: status);
      return;
    }
    await client
        .from('enquiries')
        .update({'status': status.dbValue}).eq('id', id);
  }

  Future<void> updateNotes(String id, String notes) async {
    final client = _client;
    if (client == null) {
      final index = _memory.indexWhere((e) => e.id == id);
      if (index >= 0) _memory[index] = _memory[index].copyWith(notes: notes);
      return;
    }
    await client.from('enquiries').update({'notes': notes}).eq('id', id);
  }

  /// Sample pipeline so the admin dashboard demonstrates real shape
  /// in showcase mode.
  static List<Enquiry> _seedEnquiries() {
    final now = DateTime.now();
    Enquiry make(
      int hoursAgo,
      String name,
      String email,
      String phone,
      String destination,
      int adults,
      int children,
      String budget,
      EnquiryStatus status,
      String message,
    ) {
      return Enquiry.fromJson({
        'id': 'seed-$hoursAgo-$name',
        'name': name,
        'email': email,
        'phone': phone,
        'destination': destination,
        'travel_date': now
            .add(Duration(days: 30 + hoursAgo % 60))
            .toIso8601String()
            .substring(0, 10),
        'adults': adults,
        'children': children,
        'budget': budget,
        'message': message,
        'status': status.dbValue,
        'created_at': now.subtract(Duration(hours: hoursAgo)).toIso8601String(),
      });
    }

    return [
      make(2, 'Riya Sharma', 'riya.sharma@example.com', '+91 98111 22334',
          'Maldives', 2, 0, '₹1.5L – ₹2L', EnquiryStatus.fresh,
          'Honeymoon in early December. Overwater villa is a must.'),
      make(6, 'Arjun Mehta', 'arjun.m@example.com', '+91 99887 66554',
          'Switzerland', 2, 1, 'Above ₹3L', EnquiryStatus.fresh,
          'Glacier Express with a 6-year-old — is Excellence Class suitable?'),
      make(26, 'Kavya Reddy', 'kavya.reddy@example.com', '+91 90000 12345',
          'Kerala', 4, 2, '₹75K – ₹1L', EnquiryStatus.contacted,
          'Three generations travelling together, need connecting rooms.'),
      make(50, 'Daniel Fernandes', 'daniel.f@example.com', '+91 98222 33445',
          'Bali', 2, 0, '₹1L – ₹1.5L', EnquiryStatus.quoted,
          'Anniversary trip in April. Interested in the jungle villa.'),
      make(76, 'Sana Kapoor', 'sana.k@example.com', '+91 97654 32109',
          'Ladakh', 6, 0, '₹50K – ₹75K per head', EnquiryStatus.confirmed,
          'Group of college friends, all fit, want the full expedition.'),
      make(120, 'Vikrant Singh', 'vikrant.s@example.com', '+91 96543 21098',
          'Dubai', 2, 2, '₹2L – ₹3L', EnquiryStatus.completed,
          'Winter break with kids — desert camp night please.'),
      make(200, 'Meera Pillai', 'meera.p@example.com', '+91 95432 10987',
          'Kashmir', 2, 0, '₹75K – ₹1L', EnquiryStatus.cancelled,
          'Tulip season houseboat stay.'),
      make(30, 'Rahul Verma', 'rahul.v@example.com', '+91 91234 56789',
          'Jaipur', 8, 3, '₹2L – ₹3L', EnquiryStatus.contacted,
          'Family reunion — need the balloon for all of us.'),
    ];
  }
}
