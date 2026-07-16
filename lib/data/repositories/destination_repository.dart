import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/destination.dart';
import '../seed/seed_destinations.dart';

/// Destinations — reads for the public site, full CRUD for the admin panel.
///
/// Backed by Supabase when configured; otherwise operates on an in-memory
/// copy of the bundled catalogue so the whole product remains demonstrable.
class DestinationRepository {
  DestinationRepository(this._client);

  final SupabaseClient? _client;

  static final List<Destination> _memory = List.of(seedDestinations);

  Future<List<Destination>> fetchAll() async {
    final client = _client;
    if (client == null) return List.unmodifiable(_memory);
    final rows = await client
        .from('destinations')
        .select()
        .isFilter('deleted_at', null)
        .order('name');
    final list = (rows as List)
        .map((e) => Destination.fromJson(Map<String, dynamic>.from(e)))
        .toList();
    return list.isEmpty ? List.unmodifiable(_memory) : list;
  }

  Future<Destination?> fetchBySlug(String slug) async {
    final all = await fetchAll();
    for (final d in all) {
      if (d.slug == slug) return d;
    }
    return null;
  }

  Future<void> upsert(Destination destination) async {
    final client = _client;
    if (client == null) {
      final index = _memory.indexWhere((d) => d.id == destination.id);
      if (index >= 0) {
        _memory[index] = destination;
      } else {
        _memory.add(destination);
      }
      return;
    }
    await client.from('destinations').upsert(destination.toJson());
  }

  Future<void> delete(String id) async {
    final client = _client;
    if (client == null) {
      _memory.removeWhere((d) => d.id == id);
      return;
    }
    await client
        .from('destinations')
        .update({'deleted_at': DateTime.now().toIso8601String()})
        .eq('id', id);
  }
}
