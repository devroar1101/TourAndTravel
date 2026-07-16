import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/content_models.dart';
import '../seed/seed_content.dart';

/// Gallery photographs — public reads and admin CRUD.
class GalleryRepository {
  GalleryRepository(this._client);

  final SupabaseClient? _client;

  static final List<GalleryItem> _memory = List.of(seedGallery);

  Future<List<GalleryItem>> fetchAll() async {
    final client = _client;
    if (client == null) return List.unmodifiable(_memory);
    final rows = await client
        .from('gallery')
        .select()
        .isFilter('deleted_at', null)
        .order('created_at', ascending: false);
    final list = (rows as List)
        .map((e) => GalleryItem.fromJson(Map<String, dynamic>.from(e)))
        .toList();
    return list.isEmpty ? List.unmodifiable(_memory) : list;
  }

  Future<void> upsert(GalleryItem item) async {
    final client = _client;
    if (client == null) {
      final index = _memory.indexWhere((g) => g.id == item.id);
      if (index >= 0) {
        _memory[index] = item;
      } else {
        _memory.insert(0, item);
      }
      return;
    }
    await client.from('gallery').upsert(item.toJson());
  }

  Future<void> delete(String id) async {
    final client = _client;
    if (client == null) {
      _memory.removeWhere((g) => g.id == id);
      return;
    }
    await client
        .from('gallery')
        .update({'deleted_at': DateTime.now().toIso8601String()})
        .eq('id', id);
  }
}

/// Traveller testimonials — public reads and admin CRUD.
class TestimonialRepository {
  TestimonialRepository(this._client);

  final SupabaseClient? _client;

  static final List<Testimonial> _memory = List.of(seedTestimonials);

  Future<List<Testimonial>> fetchAll() async {
    final client = _client;
    if (client == null) return List.unmodifiable(_memory);
    final rows = await client
        .from('testimonials')
        .select()
        .isFilter('deleted_at', null)
        .order('created_at', ascending: false);
    final list = (rows as List)
        .map((e) => Testimonial.fromJson(Map<String, dynamic>.from(e)))
        .toList();
    return list.isEmpty ? List.unmodifiable(_memory) : list;
  }

  Future<void> upsert(Testimonial item) async {
    final client = _client;
    if (client == null) {
      final index = _memory.indexWhere((t) => t.id == item.id);
      if (index >= 0) {
        _memory[index] = item;
      } else {
        _memory.insert(0, item);
      }
      return;
    }
    await client.from('testimonials').upsert(item.toJson());
  }

  Future<void> delete(String id) async {
    final client = _client;
    if (client == null) {
      _memory.removeWhere((t) => t.id == id);
      return;
    }
    await client
        .from('testimonials')
        .update({'deleted_at': DateTime.now().toIso8601String()})
        .eq('id', id);
  }
}

/// FAQs — public reads and admin CRUD.
class FaqRepository {
  FaqRepository(this._client);

  final SupabaseClient? _client;

  static final List<FaqItem> _memory = List.of(seedFaqs);

  Future<List<FaqItem>> fetchAll() async {
    final client = _client;
    if (client == null) return List.unmodifiable(_memory);
    final rows = await client
        .from('faqs')
        .select()
        .isFilter('deleted_at', null)
        .order('created_at');
    final list = (rows as List)
        .map((e) => FaqItem.fromJson(Map<String, dynamic>.from(e)))
        .toList();
    return list.isEmpty ? List.unmodifiable(_memory) : list;
  }

  Future<void> upsert(FaqItem item) async {
    final client = _client;
    if (client == null) {
      final index = _memory.indexWhere((f) => f.id == item.id);
      if (index >= 0) {
        _memory[index] = item;
      } else {
        _memory.add(item);
      }
      return;
    }
    await client.from('faqs').upsert(item.toJson());
  }

  Future<void> delete(String id) async {
    final client = _client;
    if (client == null) {
      _memory.removeWhere((f) => f.id == id);
      return;
    }
    await client
        .from('faqs')
        .update({'deleted_at': DateTime.now().toIso8601String()})
        .eq('id', id);
  }
}
