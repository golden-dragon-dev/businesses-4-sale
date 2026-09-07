import 'package:flutter/material.dart';
import 'package:businesses_4_sale/app.dart';
import 'package:businesses_4_sale/data/repository_factory.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final repository = await createListingRepository();
  runApp(Businesses4SaleApp(listingRepository: repository));
}
