import 'package:businesses_4_sale/data/listing_repository.dart';
import 'package:businesses_4_sale/data/repository_factory_demo.dart'
    if (dart.library.io) 'package:businesses_4_sale/data/repository_factory_firebase.dart'
    as impl;

/// On web, use the demo factory so Firebase is not compiled into the JS bundle.
/// On IO platforms (Android/iOS/desktop), Firebase wiring is available.
Future<ListingRepository> createListingRepository() =>
    impl.createListingRepository();
