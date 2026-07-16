import 'package:aurevia/data/models/enquiry.dart';
import 'package:aurevia/data/seed/seed_content.dart';
import 'package:aurevia/data/seed/seed_destinations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Seed catalogue integrity', () {
    test('ships exactly fifteen destinations with unique slugs', () {
      expect(seedDestinations.length, 15);
      final slugs = seedDestinations.map((d) => d.slug).toSet();
      expect(slugs.length, 15);
    });

    test('every destination carries the complete editorial payload', () {
      for (final d in seedDestinations) {
        expect(d.overview, isNotEmpty, reason: d.slug);
        expect(d.highlights.length, greaterThanOrEqualTo(4), reason: d.slug);
        expect(d.itinerary.length, d.days, reason: d.slug);
        expect(d.included, isNotEmpty, reason: d.slug);
        expect(d.excluded, isNotEmpty, reason: d.slug);
        expect(d.hotels, isNotEmpty, reason: d.slug);
        expect(d.attractions, isNotEmpty, reason: d.slug);
        expect(d.reviews, isNotEmpty, reason: d.slug);
        expect(d.gallery.length, greaterThanOrEqualTo(4), reason: d.slug);
        expect(d.priceFrom, greaterThan(0), reason: d.slug);
        expect(d.rating, inInclusiveRange(0, 5), reason: d.slug);
        expect(d.latitude, isNot(0), reason: d.slug);
      }
    });

    test('destinations survive a JSON round trip', () {
      for (final d in seedDestinations) {
        final restored = d.toJson();
        final copy = d.copyWith();
        expect(restored['slug'], d.slug);
        expect(copy, d);
      }
    });

    test('packages cover every collection at least once overall', () {
      expect(seedPackages, isNotEmpty);
      for (final p in seedPackages) {
        expect(p.price, greaterThan(0), reason: p.slug);
        expect(p.route, isNotEmpty, reason: p.slug);
      }
    });

    test('content sets are populated', () {
      expect(seedGallery.length, greaterThanOrEqualTo(12));
      expect(seedTestimonials.length, greaterThanOrEqualTo(5));
      expect(seedFaqs.length, greaterThanOrEqualTo(6));
    });
  });

  group('Enquiry model', () {
    test('parses and serialises statuses symmetrically', () {
      for (final status in EnquiryStatus.values) {
        expect(EnquiryStatus.fromDb(status.dbValue), status);
      }
    });
  });
}
