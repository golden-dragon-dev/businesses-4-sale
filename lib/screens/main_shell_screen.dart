import 'package:flutter/material.dart';
import 'package:businesses_4_sale/constants/legal_copy.dart';
import 'package:businesses_4_sale/screens/browse_menu_screen.dart';
import 'package:businesses_4_sale/screens/disclaimer_screen.dart';
import 'package:businesses_4_sale/screens/donate_screen.dart';
import 'package:businesses_4_sale/screens/home_screen.dart';
import 'package:businesses_4_sale/screens/join_screen.dart';
import 'package:businesses_4_sale/screens/legal_screen.dart';
import 'package:businesses_4_sale/services/share_service.dart';
import 'package:businesses_4_sale/theme/app_theme.dart';
import 'package:businesses_4_sale/widgets/ad_banner.dart';

/// Root after splash: shared doubled ad strip + swipeable main pages.
class MainShellScreen extends StatefulWidget {
  const MainShellScreen({super.key});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  final _pageController = PageController();
  int _index = 0;

  static const _labels = <String>[
    'Home',
    'Disclaimer',
    'Join',
    'Browse',
    'Donate',
    'Privacy',
    'Terms',
  ];

  void _goTo(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const AdBanner(),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (value) => setState(() => _index = value),
                children: [
                  HomeScreen(
                    showAdBanner: false,
                    embedded: true,
                    onOpenSection: _goTo,
                  ),
                  const DisclaimerScreen(showAppBar: false),
                  const JoinScreen(showAdBanner: false, embedded: true),
                  const BrowseMenuScreen(showAdBanner: false, embedded: true),
                  const DonateScreen(showAdBanner: false, embedded: true),
                  const LegalScreen(
                    title: 'Privacy Policy',
                    body: LegalCopy.privacyPolicy,
                    showAppBar: false,
                  ),
                  const LegalScreen(
                    title: 'Terms of Use',
                    body: LegalCopy.termsOfUse,
                    showAppBar: false,
                  ),
                ],
              ),
            ),
            ColoredBox(
              color: AppColors.ivory,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
                child: Row(
                  children: [
                    IconButton(
                      tooltip: 'Share app',
                      onPressed: () => ShareService().shareApp(),
                      icon: const Icon(Icons.ios_share, size: 22),
                    ),
                    Expanded(
                      child: Text(
                        '${_labels[_index]}  ·  swipe left or right',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(_labels.length, (i) {
                        final active = i == _index;
                        return Container(
                          width: active ? 8 : 6,
                          height: active ? 8 : 6,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: active ? AppColors.claret : AppColors.stone,
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
