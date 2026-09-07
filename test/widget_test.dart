import 'package:flutter_test/flutter_test.dart';
import 'package:businesses_4_sale/app.dart';
import 'package:businesses_4_sale/data/demo_listing_repository.dart';
import 'package:businesses_4_sale/screens/home_screen.dart';

Future<void> _openApp(WidgetTester tester, DemoListingRepository repo) async {
  await tester.pumpWidget(Businesses4SaleApp(listingRepository: repo));
  // Splash delay is 1400ms; avoid pumpAndSettle (AdBanner uses a periodic timer).
  await tester.pump(const Duration(milliseconds: 1500));
  await tester.pump();
}

void main() {
  testWidgets('splash then home menu loads', (tester) async {
    final repo = DemoListingRepository(seedNow: DateTime(2026, 9, 6));
    await _openApp(tester, repo);

    expect(find.text('BUSINESSES 4 SALE'), findsWidgets);
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.text('1. Join'), findsOneWidget);
    expect(find.text('2. Browse'), findsOneWidget);
    expect(find.text('3. Donate'), findsOneWidget);

    repo.dispose();
  });

  testWidgets('browse current shows seeded listings within 2 days',
      (tester) async {
    final repo = DemoListingRepository(seedNow: DateTime(2026, 9, 6, 12));
    await _openApp(tester, repo);

    await tester.tap(find.text('2. Browse'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    await tester.tap(find.textContaining('Current Listings'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Good po Café'), findsOneWidget);
    expect(find.text('Bright Clinic'), findsOneWidget);
    // 3+ days old should not appear in current (2 day) window.
    expect(find.text('Diamond Café'), findsNothing);

    repo.dispose();
  });
}
