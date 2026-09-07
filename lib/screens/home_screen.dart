import 'package:flutter/material.dart';
import 'package:businesses_4_sale/constants/legal_copy.dart';
import 'package:businesses_4_sale/screens/browse_menu_screen.dart';
import 'package:businesses_4_sale/screens/donate_screen.dart';
import 'package:businesses_4_sale/screens/join_screen.dart';
import 'package:businesses_4_sale/screens/legal_screen.dart';
import 'package:businesses_4_sale/services/share_service.dart';
import 'package:businesses_4_sale/theme/app_theme.dart';
import 'package:businesses_4_sale/widgets/ad_banner.dart';
import 'package:businesses_4_sale/widgets/bus_sale_logo.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const AdBanner(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                children: [
                  const Center(child: BusSaleLogo(size: 96, showWordmark: true)),
                  const SizedBox(height: 24),
                  _HomeAction(
                    label: '1. Join',
                    subtitle: 'Tap to submit your business detail',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const JoinScreen(),
                      ),
                    ),
                  ),
                  _HomeAction(
                    label: '2. Browse',
                    subtitle: 'Current listings or by business type',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const BrowseMenuScreen(),
                      ),
                    ),
                  ),
                  _HomeAction(
                    label: '3. Donate',
                    subtitle: 'Support via Stripe',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const DonateScreen(),
                      ),
                    ),
                  ),
                  _HomeAction(
                    label: '4. Privacy Policy',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const LegalScreen(
                          title: 'Privacy Policy',
                          body: LegalCopy.privacyPolicy,
                        ),
                      ),
                    ),
                  ),
                  _HomeAction(
                    label: '5. Terms of Use',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const LegalScreen(
                          title: 'Terms of Use',
                          body: LegalCopy.termsOfUse,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ExpansionTile(
                    tilePadding: EdgeInsets.zero,
                    title: const Text(
                      'Disclaimer',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          LegalCopy.disclaimer,
                          style: const TextStyle(
                            height: 1.4,
                            color: AppColors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: IconButton(
                tooltip: 'Share app',
                onPressed: () => ShareService().shareApp(),
                icon: const Icon(Icons.ios_share, size: 28),
              ),
            ),
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
  });

  final String label;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        label,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.black,
        ),
      ),
      subtitle: subtitle == null
          ? null
          : Text(subtitle!, style: const TextStyle(color: AppColors.grey)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
