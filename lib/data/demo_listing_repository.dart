import 'dart:async';
import 'dart:typed_data';

import 'package:businesses_4_sale/models/business_listing.dart';
import 'package:businesses_4_sale/data/listing_repository.dart';
import 'package:uuid/uuid.dart';

/// In-memory repository used when Firebase is not configured yet.
class DemoListingRepository implements ListingRepository {
  DemoListingRepository({DateTime? seedNow, List<BusinessListing>? seed})
      : _items = List<BusinessListing>.from(
          seed ?? _defaultSeed(seedNow ?? DateTime.now()),
        );

  final List<BusinessListing> _items;
  final _controller = StreamController<List<BusinessListing>>.broadcast();
  final _uuid = const Uuid();

  void _emit() {
    if (!_controller.isClosed) {
      _controller.add(List.unmodifiable(_items));
    }
  }

  @override
  Stream<List<BusinessListing>> watchAll() {
    scheduleMicrotask(_emit);
    return _controller.stream;
  }

  @override
  Future<List<BusinessListing>> fetchAll() async {
    return List.unmodifiable(_items);
  }

  @override
  Future<BusinessListing?> getById(String id) async {
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<BusinessListing> create({
    required ListingDraft draft,
    Uint8List? photoBytes,
    String? photoFileName,
  }) async {
    final error = draft.validate();
    if (error != null) {
      throw ArgumentError(error);
    }

    final listing = BusinessListing(
      id: _uuid.v4(),
      companyName: draft.companyName.trim(),
      businessTypeCode: draft.businessType!.code,
      location: draft.location.trim(),
      contactName: draft.contactName.trim(),
      contactPhone: draft.contactPhone.trim().isEmpty
          ? null
          : draft.contactPhone.trim(),
      contactEmail: draft.contactEmail.trim().isEmpty
          ? null
          : draft.contactEmail.trim(),
      photoUrl: photoBytes == null ? null : 'demo://photo/${_uuid.v4()}',
      remarks: draft.remarks.trim().isEmpty ? null : draft.remarks.trim(),
      createdAt: DateTime.now(),
    );

    _items.insert(0, listing);
    _emit();
    return listing;
  }

  void dispose() {
    _controller.close();
  }

  static List<BusinessListing> _defaultSeed(DateTime now) {
    return [
      BusinessListing(
        id: 'seed-1',
        companyName: 'Good po Café',
        businessTypeCode: '15',
        location: '2 Water St., North Sydney NSW 2011',
        contactName: 'Ms B',
        contactPhone: '0412 000 111',
        remarks: 'Busy corner location.',
        createdAt: now.subtract(const Duration(hours: 6)),
      ),
      BusinessListing(
        id: 'seed-2',
        companyName: 'Bright Clinic',
        businessTypeCode: '28',
        location: '33 Split Rd., Rhodes NSW 2114',
        contactName: 'Mr A',
        contactEmail: 'bright@example.com',
        createdAt: now.subtract(const Duration(hours: 20)),
      ),
      BusinessListing(
        id: 'seed-3',
        companyName: 'Burwood Chinese Restaurant',
        businessTypeCode: '49',
        location: '114 Burwood Rd., Burwood 2134',
        contactName: 'Owner',
        contactPhone: '0298765432',
        createdAt: now.subtract(const Duration(days: 1, hours: 4)),
      ),
      BusinessListing(
        id: 'seed-4',
        companyName: 'Campsie Milk Bar',
        businessTypeCode: '01',
        location: '78 First Ave., Campsie NSW 2216',
        contactName: 'Sam',
        contactEmail: 'campsie@example.com',
        createdAt: now.subtract(const Duration(days: 1, hours: 10)),
      ),
      BusinessListing(
        id: 'seed-5',
        companyName: 'Diamond Café',
        businessTypeCode: '15',
        location: '10 First Street, Burwood NSW 2134',
        contactName: 'Di',
        contactPhone: '0400 111 222',
        createdAt: now.subtract(const Duration(days: 3)),
      ),
      BusinessListing(
        id: 'seed-6',
        companyName: 'Golden Café',
        businessTypeCode: '15',
        location: '20 Second Street, Burwood NSW 2134',
        contactName: 'Gold',
        contactEmail: 'golden@example.com',
        createdAt: now.subtract(const Duration(days: 4)),
      ),
      BusinessListing(
        id: 'seed-7',
        companyName: 'Silver Café',
        businessTypeCode: '15',
        location: '30 Third Street, Burwood NSW 2134',
        contactName: 'Sil',
        contactPhone: '0400 333 444',
        createdAt: now.subtract(const Duration(days: 5)),
      ),
      // Outside type window (older than 7 days) — stored but hidden from browse.
      BusinessListing(
        id: 'seed-old',
        companyName: 'Old Town Bakery',
        businessTypeCode: '09',
        location: '1 Past St, Sydney NSW 2000',
        contactName: 'Baker',
        contactPhone: '0400 999 000',
        createdAt: now.subtract(const Duration(days: 10)),
      ),
    ];
  }
}
