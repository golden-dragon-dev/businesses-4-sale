import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:businesses_4_sale/data/listing_repository.dart';
import 'package:businesses_4_sale/screens/splash_screen.dart';
import 'package:businesses_4_sale/theme/app_theme.dart';

class Businesses4SaleApp extends StatelessWidget {
  const Businesses4SaleApp({
    super.key,
    required this.listingRepository,
  });

  final ListingRepository listingRepository;

  @override
  Widget build(BuildContext context) {
    return Provider<ListingRepository>.value(
      value: listingRepository,
      child: MaterialApp(
        title: 'Businesses 4 Sale',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        home: const SplashScreen(),
      ),
    );
  }
}
