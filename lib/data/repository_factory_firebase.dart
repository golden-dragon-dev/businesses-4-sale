import 'package:firebase_core/firebase_core.dart';
import 'package:businesses_4_sale/config/app_config.dart';
import 'package:businesses_4_sale/data/demo_listing_repository.dart';
import 'package:businesses_4_sale/data/firebase_listing_repository.dart';
import 'package:businesses_4_sale/data/listing_repository.dart';
import 'package:businesses_4_sale/firebase_options.dart';

/// Mobile / Firebase-enabled factory.
Future<ListingRepository> createListingRepository() async {
  if (!AppConfig.useFirebase) {
    return DemoListingRepository();
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  return FirebaseListingRepository();
}
