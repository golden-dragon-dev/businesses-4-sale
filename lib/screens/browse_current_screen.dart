import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:businesses_4_sale/data/listing_filters.dart';
import 'package:businesses_4_sale/data/listing_repository.dart';
import 'package:businesses_4_sale/models/business_listing.dart';
import 'package:businesses_4_sale/screens/listing_detail_screen.dart';
import 'package:businesses_4_sale/widgets/ad_banner.dart';
import 'package:businesses_4_sale/widgets/listing_list_tile.dart';

class BrowseCurrentScreen extends StatelessWidget {
  const BrowseCurrentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = context.read<ListingRepository>();

    return Scaffold(
      appBar: AppBar(title: const Text('Current (last 2 days)')),
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
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final listings =
                    ListingFilters.currentListings(snapshot.data ?? const []);

                if (listings.isEmpty) {
                  return const Center(
                    child: Text('No listings in the last 2 days.'),
                  );
                }

                return ListView.separated(
                  itemCount: listings.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final listing = listings[index];
                    return ListingListTile(
                      listing: listing,
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
