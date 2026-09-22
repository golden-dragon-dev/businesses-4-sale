import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:businesses_4_sale/constants/business_types.dart';
import 'package:businesses_4_sale/data/listing_filters.dart';
import 'package:businesses_4_sale/data/listing_repository.dart';
import 'package:businesses_4_sale/models/business_listing.dart';
import 'package:businesses_4_sale/screens/listing_detail_screen.dart';
import 'package:businesses_4_sale/theme/app_theme.dart';
import 'package:businesses_4_sale/widgets/ad_banner.dart';
import 'package:businesses_4_sale/widgets/listing_list_tile.dart';

class BrowseTypesScreen extends StatelessWidget {
  const BrowseTypesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('By business type')),
      body: Column(
        children: [
          const AdBanner(),
          Expanded(
            child: ListView.separated(
              itemCount: BusinessTypes.all.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final type = BusinessTypes.all[index];
                return ListTile(
                  title: Text(
                    type.label,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => BrowseByTypeScreen(type: type),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class BrowseByTypeScreen extends StatelessWidget {
  const BrowseByTypeScreen({super.key, required this.type});

  final BusinessType type;

  @override
  Widget build(BuildContext context) {
    final repo = context.read<ListingRepository>();

    return Scaffold(
      appBar: AppBar(title: Text(type.label)),
      body: Column(
        children: [
          const AdBanner(),
          Expanded(
            child: StreamBuilder<List<BusinessListing>>(
              stream: repo.watchAll(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting &&
                    !snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final listings = ListingFilters.byType(
                  snapshot.data ?? const [],
                  type.code,
                );

                if (listings.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'No listings for this type in the last 7 days.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.grey),
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: listings.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final listing = listings[index];
                    return ListingListTile(
                      listing: listing,
                      showDate: false,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) =>
                              ListingDetailScreen(listingId: listing.id),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
