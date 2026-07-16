import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/tour_package.dart';
import '../seed/seed_content.dart';
import 'repository_utils.dart';

/// Tour packages — public reads and admin CRUD.
class PackageRepository {
  PackageRepository(this._client);

  final SupabaseClient? _client;

  static final List<TourPackage> _memory = List.of(seedPackages);

  Future<List<TourPackage>> fetchAll() async {
    final client = _client;
    if (client == null) return List.unmodifiable(_memory);
    try {
      final rows = await client
          .from('packages')
          .select()
          .isFilter('deleted_at', null)
          .order('price');
      final list = (rows as List)
          .map((e) => TourPackage.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      return list.isEmpty ? List.unmodifiable(_memory) : list;
    } catch (_) {
      return List.unmodifiable(_memory);
    }
  }

  Future<void> upsert(TourPackage pkg) async {
    final client = _client;
    if (client == null) {
      final index = _memory.indexWhere((p) => p.id == pkg.id);
      if (index >= 0) {
        _memory[index] = pkg;
      } else {
        _memory.add(pkg);
      }
      return;
    }
    await client.from('packages').upsert(upsertPayload(pkg.toJson()));
  }

  Future<void> delete(String id) async {
    final client = _client;
    if (client == null) {
      _memory.removeWhere((p) => p.id == id);
      return;
    }
    if (!isDatabaseId(id)) return;
    await client
        .from('packages')
        .update({'deleted_at': DateTime.now().toIso8601String()})
        .eq('id', id);
  }
}
