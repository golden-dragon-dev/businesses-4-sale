import 'package:businesses_4_sale/data/demo_listing_repository.dart';
import 'package:businesses_4_sale/data/listing_repository.dart';

/// Default factory for preview / demo builds (no Firebase JS in the bundle).
Future<ListingRepository> createListingRepository() async {
  return DemoListingRepository();
}
