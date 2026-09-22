import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:businesses_4_sale/app.dart';
import 'package:businesses_4_sale/data/demo_listing_repository.dart';
import 'package:businesses_4_sale/screens/main_shell_screen.dart';
import 'package:businesses_4_sale/widgets/ad_banner.dart';

Future<void> _openApp(WidgetTester tester, DemoListingRepository repo) async {
  await tester.pumpWidget(Businesses4SaleApp(listingRepository: repo));
  await tester.pump(const Duration(milliseconds: 1500));
  await tester.pump();
}

void main() {
  testWidgets('splash then main shell loads with p1 ad and home',
      (tester) async {
    final repo = DemoListingRepository(seedNow: DateTime.now());
    await tester.binding.setSurfaceSize(const Size(400, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await _openApp(tester, repo);

    expect(find.byType(MainShellScreen), findsOneWidget);
    expect(find.text('Disclaimer'), findsWidgets);
    expect(find.text('1. Join'), findsOneWidget);
    expect(find.text('2. Browse'), findsOneWidget);
    expect(find.text('3. Donate'), findsOneWidget);
    expect(find.textContaining('swipe left or right'), findsWidgets);

    // Pack p1 flyer is the first ad creative.
    final banner = tester.widget<AdBanner>(find.byType(AdBanner).first);
    expect(banner.slides.first.imageAsset, 'assets/ads/p1_flyer.png');

    repo.dispose();
  });

  testWidgets('ad strip is about one third of screen height', (tester) async {
    final repo = DemoListingRepository(seedNow: DateTime.now());
    await tester.binding.setSurfaceSize(const Size(400, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await _openApp(tester, repo);

    final adBox = tester.getSize(find.byType(AdBanner).first);
    // Content ≈ height/3 (clamped) + 40px controls.
    expect(adBox.height, greaterThanOrEqualTo(220));
    expect(adBox.height, lessThanOrEqualTo(380));

    repo.dispose();
  });

  testWidgets('swipe moves to disclaimer page with larger body text',
      (tester) async {
    final repo = DemoListingRepository(seedNow: DateTime.now());
    await tester.binding.setSurfaceSize(const Size(400, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await _openApp(tester, repo);

    await tester.fling(find.byType(PageView).last, const Offset(-400, 0), 1000);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.textContaining('listing platform only'), findsOneWidget);
    expect(find.textContaining('Home  ·  swipe left or right'), findsNothing);
    expect(find.textContaining('Disclaimer  ·  swipe left or right'), findsOneWidget);

    final body = tester.widget<Text>(
      find.textContaining('listing platform only'),
    );
    expect(body.style?.fontSize, 18);

    repo.dispose();
  });

  testWidgets('home menu order opens Join after Disclaimer', (tester) async {
    final repo = DemoListingRepository(seedNow: DateTime.now());
    await tester.binding.setSurfaceSize(const Size(400, 1800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await _openApp(tester, repo);

    await tester.ensureVisible(find.text('Disclaimer').first);
    await tester.tap(find.text('Disclaimer').first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.textContaining('listing platform only'), findsOneWidget);

    // Back to home via swipe right, then Join.
    await tester.fling(find.byType(PageView).last, const Offset(400, 0), 1000);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    await tester.ensureVisible(find.text('1. Join'));
    await tester.tap(find.text('1. Join'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.textContaining('Join  ·  swipe left or right'), findsOneWidget);

    repo.dispose();
  });

  testWidgets('browse current shows seeded listings within 2 days',
      (tester) async {
    final seedNow = DateTime.now();
    final repo = DemoListingRepository(seedNow: seedNow);
    await tester.binding.setSurfaceSize(const Size(400, 1800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await _openApp(tester, repo);

    await tester.ensureVisible(find.text('2. Browse'));
    await tester.tap(find.text('2. Browse'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.textContaining('Current Listings'), findsOneWidget);
    await tester.tap(find.textContaining('Current Listings'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Good po Café'), findsOneWidget);
    expect(find.text('Diamond Café'), findsNothing);

    repo.dispose();
  });
}
