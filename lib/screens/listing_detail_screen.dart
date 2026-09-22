import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:businesses_4_sale/data/listing_repository.dart';
import 'package:businesses_4_sale/models/business_listing.dart';
import 'package:businesses_4_sale/theme/app_theme.dart';

class ListingDetailScreen extends StatelessWidget {
  const ListingDetailScreen({super.key, required this.listingId});

  final String listingId;

  @override
  Widget build(BuildContext context) {
    final repo = context.read<ListingRepository>();

    return Scaffold(
      appBar: AppBar(title: const Text('Listing details')),
      body: FutureBuilder<BusinessListing?>(
        future: repo.getById(listingId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final listing = snapshot.data;
          if (listing == null) {
            return const Center(child: Text('Listing not found.'));
          }

          final dateLabel =
              DateFormat('dd MMM yyyy, HH:mm').format(listing.createdAt);

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                listing.companyName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                listing.businessTypeLabel,
                style: const TextStyle(
                  color: AppColors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              _DetailRow(label: 'Location', value: listing.location),
              _DetailRow(label: 'Contact name', value: listing.contactName),
              if (listing.contactPhone != null &&
                  listing.contactPhone!.isNotEmpty)
                _DetailRow(
                  label: 'Phone',
                  value: listing.contactPhone!,
                  onTap: () => launchUrl(
                    Uri(scheme: 'tel', path: listing.contactPhone),
                  ),
                ),
              if (listing.contactEmail != null &&
                  listing.contactEmail!.isNotEmpty)
                _DetailRow(
                  label: 'Email',
                  value: listing.contactEmail!,
                  onTap: () => launchUrl(
                    Uri(
                      scheme: 'mailto',
                      path: listing.contactEmail,
                    ),
                  ),
                ),
              if (listing.remarks != null && listing.remarks!.isNotEmpty)
                _DetailRow(label: 'Remarks', value: listing.remarks!),
              _DetailRow(label: 'Listed', value: dateLabel),
              if (listing.photoUrl != null &&
                  listing.photoUrl!.startsWith('http')) ...[
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    listing.photoUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const SizedBox.shrink(),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final child = Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: onTap == null ? AppColors.black : AppColors.red,
              decoration: onTap == null ? null : TextDecoration.underline,
            ),
          ),
        ],
      ),
    );

    if (onTap == null) return child;
    return InkWell(onTap: onTap, child: child);
  }
}
