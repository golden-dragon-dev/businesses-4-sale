import 'package:flutter/material.dart';
import 'package:businesses_4_sale/screens/browse_current_screen.dart';
import 'package:businesses_4_sale/screens/browse_types_screen.dart';
import 'package:businesses_4_sale/theme/app_theme.dart';
import 'package:businesses_4_sale/widgets/ad_banner.dart';

class BrowseMenuScreen extends StatelessWidget {
  const BrowseMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Browse')),
      body: Column(
        children: [
          const AdBanner(),
          ListTile(
            title: const Text(
              'a. Current Listings (last 2 days)',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            subtitle: const Text(
              'Names and addresses in date order',
              style: TextStyle(color: AppColors.grey),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const BrowseCurrentScreen(),
              ),
            ),
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text(
              'b. By type of business (last 7 days)',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            subtitle: const Text(
              'Choose a business type, then open a listing',
              style: TextStyle(color: AppColors.grey),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const BrowseTypesScreen(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
