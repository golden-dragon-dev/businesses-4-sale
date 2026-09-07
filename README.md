# Businesses 4 Sale

Flutter marketplace app for listing and browsing businesses for sale.

Matches Developer Pack v3.0 (amended) and the agreed fixed-scope build:

- Join (seller submission, mobile app only)
- Browse current listings (last 2 days)
- Browse by business type (last 7 days, codes 01–60)
- Donate (Stripe UI; demo mode until keys arrive)
- Privacy Policy, Terms of Use, expandable Disclaimer
- Rotating ad banner (5s) with pause / next / back
- Share App Store + Play Store links
- Splash screen matches pack p3 (white + centered BUS.SALE badge)
- Admin via Firebase Console (no separate web dashboard)

## Run (demo mode — default)

Demo mode uses in-memory seed listings. No Firebase or Stripe account required.

```bash
flutter pub get
flutter test
flutter run
```

## Project layout

```
lib/
  config/          # AppConfig (demo vs Firebase flags)
  constants/       # Business types 01–60, legal copy
  data/            # Repositories + browse filters
  models/          # BusinessListing, ListingDraft
  screens/         # Splash, Home, Join, Browse, Donate, Legal
  services/        # Donations, share, platform guard
  widgets/         # Logo, ad banner, list tiles
firestore/         # Firestore + Storage security rules
```

## Switch on Firebase

1. Create Firebase project (Firestore + Storage).
2. Run `flutterfire configure` and replace `lib/firebase_options.dart`.
3. Deploy rules from `firestore/`.
4. Build with:

```bash
flutter run --dart-define=USE_DEMO_BACKEND=false --dart-define=FIREBASE_CONFIGURED=true
```

## Stripe donations

Donate screen supports one-off / monthly and amounts $20 / $30 / $50 / Other.

Until `STRIPE_PUBLISHABLE_KEY` is provided (and a PaymentIntent backend exists), donations run in demo mode and show a success message without charging a card.

```bash
flutter run --dart-define=STRIPE_PUBLISHABLE_KEY=pk_test_xxx
```

## Client assets still pending

- Clean PNG/SVG logo (placeholder painter used until then)
- Apple Developer + Google Play accounts under client ABN
- Stripe account for live donations

## Milestones (agreed)

1. Firebase setup, auth-free listings, buyer browse
2. Stripe donations, legal pages, testing
3. Store submission + 30 days support
