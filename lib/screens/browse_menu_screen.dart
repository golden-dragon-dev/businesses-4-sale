import 'package:flutter/material.dart';
import 'package:businesses_4_sale/screens/browse_current_screen.dart';
import 'package:businesses_4_sale/screens/browse_types_screen.dart';
import 'package:businesses_4_sale/theme/app_theme.dart';
import 'package:businesses_4_sale/widgets/ad_banner.dart';

class BrowseMenuScreen extends StatelessWidget {
  const BrowseMenuScreen({
    super.key,
    this.showAdBanner = true,
    this.embedded = false,
  });

  final bool showAdBanner;
  final bool embedded;

  @override
  Widget build(BuildContext context) {
    final list = Column(
      children: [
        if (embedded)
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 12, 20, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Browse',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
            ),
          ),
        if (showAdBanner) const AdBanner(),
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
    );

    if (embedded) {
      return list;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Browse')),
      body: list,
    );
  }
}
