import 'package:flutter/material.dart';
import 'package:businesses_4_sale/theme/app_theme.dart';
import 'package:businesses_4_sale/widgets/ad_banner.dart';
import 'package:businesses_4_sale/widgets/bus_sale_logo.dart';

/// Pack p2 home menu.
///
/// When [embedded] in [MainShellScreen], taps jump to swipe pages instead of
/// pushing new routes. Page indexes: 1 Disclaimer, 2 Join, 3 Browse, 4 Donate,
/// 5 Privacy, 6 Terms.
class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    this.showAdBanner = true,
    this.embedded = false,
    this.onOpenSection,
  });

  final bool showAdBanner;
  final bool embedded;
  final ValueChanged<int>? onOpenSection;

  void _open(BuildContext context, int section) {
    if (embedded && onOpenSection != null) {
      onOpenSection!(section);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Under the doubled top ad, keep the Pack p2 menu readable without a long scroll.
    final logoSize = embedded ? 96.0 : 148.0;
    final body = ListView(
      padding: EdgeInsets.fromLTRB(20, embedded ? 8 : 16, 20, 24),
      children: [
        Center(child: BusSaleLogo(size: logoSize, showWordmark: true)),
        const SizedBox(height: 8),
        const Text(
          ' ',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.claret,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            height: 1.35,
          ),
        ),
        SizedBox(height: embedded ? 10 : 20),
        _HomeAction(
          label: 'Disclaimer',
          subtitle: 'Please read before you join or browse',
          emphasize: true,
          onTap: () => _open(context, 1),
        ),
        const SizedBox(height: 2),
        _HomeAction(
          label: '1. Join',
          subtitle: 'Tap to submit your business detail',
          onTap: () => _open(context, 2),
        ),
        _HomeAction(
          label: '2. Browse',
          subtitle: 'Current listings or by business type',
          onTap: () => _open(context, 3),
        ),
        _HomeAction(
          label: '3. Donate',
          subtitle: 'Support via Stripe',
          onTap: () => _open(context, 4),
        ),
        _HomeAction(
          label: '4. Privacy Policy',
          onTap: () => _open(context, 5),
        ),
        _HomeAction(
          label: '5. Terms of Use',
          onTap: () => _open(context, 6),
        ),
        const SizedBox(height: 12),
        const Text(
          'Tip: swipe left or right to move between pages.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.grey, fontSize: 13),
        ),
      ],
    );

    if (embedded) {
      return body;
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            if (showAdBanner) const AdBanner(),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }
}

class _HomeAction extends StatelessWidget {
  const _HomeAction({
    required this.label,
    required this.onTap,
    this.subtitle,
    this.emphasize = false,
  });

  final String label;
  final String? subtitle;
  final VoidCallback onTap;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      dense: true,
      visualDensity: VisualDensity.compact,
      title: Text(
        label,
        style: TextStyle(
          fontSize: emphasize ? 19 : 18,
          fontWeight: FontWeight.w800,
          color: emphasize ? AppColors.claret : AppColors.black,
        ),
      ),
      subtitle: subtitle == null
          ? null
          : Text(
              subtitle!,
              style: const TextStyle(
                color: AppColors.grey,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
