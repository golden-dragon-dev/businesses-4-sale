import 'dart:typed_data';

import 'package:businesses_4_sale/models/business_listing.dart';

abstract class ListingRepository {
  Stream<List<BusinessListing>> watchAll();

  Future<List<BusinessListing>> fetchAll();

  Future<BusinessListing?> getById(String id);

  Future<BusinessListing> create({
    required ListingDraft draft,
    Uint8List? photoBytes,
    String? photoFileName,
  });
}
