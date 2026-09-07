import 'package:businesses_4_sale/config/app_config.dart';
import 'package:businesses_4_sale/models/business_listing.dart';

/// Filters listings for Browse screens per Developer Pack rules.
class ListingFilters {
  ListingFilters._();

  /// Current listings: last 2 days, newest first.
  static List<BusinessListing> currentListings(
    List<BusinessListing> source, {
    DateTime? now,
  }) {
    final clock = now ?? DateTime.now();
    final filtered = source
        .where((listing) => listing.isVisibleInCurrentWindow(clock))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return filtered;
  }

  /// By type: last 7 days for a given business type code, newest first.
  static List<BusinessListing> byType(
    List<BusinessListing> source,
    String typeCode, {
    DateTime? now,
  }) {
    final clock = now ?? DateTime.now();
    final code = typeCode.padLeft(2, '0');
    final filtered = source
        .where(
          (listing) =>
              listing.businessTypeCode == code &&
              listing.isVisibleInTypeWindow(clock),
        )
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return filtered;
  }

  static Duration get currentWindow => AppConfig.currentListingsWindow;
  static Duration get typeWindow => AppConfig.typeListingsWindow;
}
