import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/models/content_models.dart';
import '../data/models/destination.dart';
import '../data/models/enquiry.dart';
import '../data/models/tour_package.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/content_repositories.dart';
import '../data/repositories/destination_repository.dart';
import '../data/repositories/enquiry_repository.dart';
import '../data/repositories/package_repository.dart';
import '../data/services/supabase_service.dart';

// ---------------------------------------------------------------------------
// Infrastructure
// ---------------------------------------------------------------------------

final supabaseClientProvider =
    Provider<SupabaseClient?>((ref) => SupabaseService.client);

final destinationRepositoryProvider = Provider<DestinationRepository>(
    (ref) => DestinationRepository(ref.watch(supabaseClientProvider)));

final packageRepositoryProvider = Provider<PackageRepository>(
    (ref) => PackageRepository(ref.watch(supabaseClientProvider)));

final galleryRepositoryProvider = Provider<GalleryRepository>(
    (ref) => GalleryRepository(ref.watch(supabaseClientProvider)));

final testimonialRepositoryProvider = Provider<TestimonialRepository>(
    (ref) => TestimonialRepository(ref.watch(supabaseClientProvider)));

final faqRepositoryProvider = Provider<FaqRepository>(
    (ref) => FaqRepository(ref.watch(supabaseClientProvider)));

final enquiryRepositoryProvider = Provider<EnquiryRepository>(
    (ref) => EnquiryRepository(ref.watch(supabaseClientProvider)));

final authRepositoryProvider = Provider<AuthRepository>(
    (ref) => AuthRepository(ref.watch(supabaseClientProvider)));

// ---------------------------------------------------------------------------
// Content
// ---------------------------------------------------------------------------

final destinationsProvider = FutureProvider<List<Destination>>(
    (ref) => ref.watch(destinationRepositoryProvider).fetchAll());

final featuredDestinationsProvider = FutureProvider<List<Destination>>(
    (ref) async => (await ref.watch(destinationsProvider.future))
        .where((d) => d.featured)
        .toList());

final destinationBySlugProvider = FutureProvider.family<Destination?, String>(
    (ref, slug) => ref.watch(destinationRepositoryProvider).fetchBySlug(slug));

final packagesProvider = FutureProvider<List<TourPackage>>(
    (ref) => ref.watch(packageRepositoryProvider).fetchAll());

final galleryProvider = FutureProvider<List<GalleryItem>>(
    (ref) => ref.watch(galleryRepositoryProvider).fetchAll());

final testimonialsProvider = FutureProvider<List<Testimonial>>(
    (ref) => ref.watch(testimonialRepositoryProvider).fetchAll());

final faqsProvider = FutureProvider<List<FaqItem>>(
    (ref) => ref.watch(faqRepositoryProvider).fetchAll());

final enquiriesProvider = FutureProvider<List<Enquiry>>(
    (ref) => ref.watch(enquiryRepositoryProvider).fetchAll());

// ---------------------------------------------------------------------------
// Auth
// ---------------------------------------------------------------------------

/// Signed-in state for the admin panel, bridged to a [ValueNotifier] so the
/// router can re-evaluate redirects when it changes.
class AuthController extends Notifier<bool> {
  static final ValueNotifier<bool> listenable = ValueNotifier(false);

  @override
  bool build() {
    final signedIn = ref.read(authRepositoryProvider).isSignedIn;
    listenable.value = signedIn;
    return signedIn;
  }

  Future<void> signIn(String email, String password) async {
    await ref.read(authRepositoryProvider).signIn(email, password);
    state = true;
    listenable.value = true;
  }

  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).signOut();
    state = false;
    listenable.value = false;
  }
}

final authControllerProvider =
    NotifierProvider<AuthController, bool>(AuthController.new);
