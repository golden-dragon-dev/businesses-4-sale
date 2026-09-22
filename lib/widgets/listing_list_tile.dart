import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:businesses_4_sale/models/business_listing.dart';
import 'package:businesses_4_sale/theme/app_theme.dart';

class ListingListTile extends StatelessWidget {
  const ListingListTile({
    super.key,
    required this.listing,
    required this.onTap,
    this.showDate = true,
  });

  final BusinessListing listing;
  final VoidCallback onTap;
  final bool showDate;

  @override
  Widget build(BuildContext context) {
    final dateLabel = DateFormat('dd/MM/yy').format(listing.createdAt);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    listing.companyName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    listing.location,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),
            if (showDate)
              Text(
                dateLabel,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.grey,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
