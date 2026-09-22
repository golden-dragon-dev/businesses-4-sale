import 'package:flutter_test/flutter_test.dart';
import 'package:businesses_4_sale/constants/business_types.dart';
import 'package:businesses_4_sale/data/demo_listing_repository.dart';
import 'package:businesses_4_sale/data/listing_filters.dart';
import 'package:businesses_4_sale/models/business_listing.dart';
import 'package:businesses_4_sale/services/donation_service.dart';

void main() {
  group('BusinessTypes', () {
    test('contains codes 01 through 60', () {
      expect(BusinessTypes.all.length, 60);
      expect(BusinessTypes.all.first.code, '01');
      expect(BusinessTypes.all.last.code, '60');
      expect(BusinessTypes.byCode('15')?.name, 'Café');
    });
  });

  group('ListingDraft validation', () {
    test('requires company, type, location, contact name, and phone or email',
        () {
      final draft = ListingDraft();
      expect(draft.validate(), isNotNull);

      draft.companyName = 'Test Co';
      draft.businessType = BusinessTypes.byCode('15');
      draft.location = '1 Test St';
      draft.contactName = 'Mr A';
      expect(draft.validate(), contains('mobile number or email'));

      draft.contactEmail = 'owner@example.com';
      expect(draft.validate(), isNull);
    });

    test('rejects invalid email when provided', () {
      final draft = ListingDraft()
        ..companyName = 'Test'
        ..businessType = BusinessTypes.byCode('01')
        ..location = 'Sydney'
        ..contactName = 'A'
        ..contactEmail = 'not-an-email';
      expect(draft.validate(), contains('valid email'));
    });
  });

  group('ListingFilters', () {
    final now = DateTime(2026, 9, 6, 12);

    final listings = [
      BusinessListing(
        id: 'a',
        companyName: 'Fresh',
        businessTypeCode: '15',
        location: 'A',
        contactName: 'A',
        createdAt: now.subtract(const Duration(hours: 5)),
      ),
      BusinessListing(
        id: 'b',
        companyName: 'Week old café',
        businessTypeCode: '15',
        location: 'B',
        contactName: 'B',
        createdAt: now.subtract(const Duration(days: 3)),
      ),
      BusinessListing(
        id: 'c',
        companyName: 'Stale',
        businessTypeCode: '15',
        location: 'C',
        contactName: 'C',
        createdAt: now.subtract(const Duration(days: 10)),
      ),
      BusinessListing(
        id: 'd',
        companyName: 'Clinic',
        businessTypeCode: '28',
        location: 'D',
        contactName: 'D',
        createdAt: now.subtract(const Duration(hours: 2)),
      ),
    ];

    test('current listings only include last 2 days', () {
      final current = ListingFilters.currentListings(listings, now: now);
      expect(current.map((e) => e.id), ['d', 'a']);
    });

    test('by type includes last 7 days for that code only', () {
      final cafes = ListingFilters.byType(listings, '15', now: now);
      expect(cafes.map((e) => e.id), ['a', 'b']);
    });
  });

  group('DemoListingRepository', () {
    test('seeds sample data and accepts new joins', () async {
      final repo = DemoListingRepository(seedNow: DateTime(2026, 9, 6));
      final all = await repo.fetchAll();
      expect(all.length, greaterThanOrEqualTo(7));

      final draft = ListingDraft()
        ..companyName = 'New Shop'
        ..businessType = BusinessTypes.byCode('50')
        ..location = '10 Retail Rd'
        ..contactName = 'Seller'
        ..contactPhone = '0400111222';

      final created = await repo.create(draft: draft);
      expect(created.companyName, 'New Shop');

      final updated = await repo.fetchAll();
      expect(updated.first.id, created.id);
      repo.dispose();
    });
  });

  group('DonationService', () {
    test('demo donation succeeds without Stripe key', () async {
      final result = await DonationService().donate(
        const DonationRequest(
          frequency: DonationFrequency.oneOff,
          amountAud: 20,
        ),
      );
      expect(result.success, isTrue);
      expect(result.demo, isTrue);
    });
  });
}
