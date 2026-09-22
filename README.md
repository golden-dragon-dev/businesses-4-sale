# Businesses 4 Sale

Flutter marketplace app for listing and browsing businesses for sale.

Matches Developer Pack v3.0 (amended) and the agreed fixed-scope build:

- Join (seller submission, mobile app only)
- Browse current listings (last 2 days)
- Browse by business type (last 7 days, codes 01–60)
- Donate (Stripe UI; demo mode until keys arrive)
- Privacy Policy, Terms of Use, and a dedicated Disclaimer page
- Rotating ad banner (5s) with pause / next / back
- Horizontal swipe navigation between the main pages
- Share App Store + Play Store links
- White splash screen with the approved Atelier BUS.SALE mark
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
  screens/         # Splash, shell, Home, Disclaimer, Join, Browse, Donate, Legal
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

## Production setup still pending

- Apple Developer + Google Play accounts under client ABN
- production Firebase configuration
- Stripe account and secure payment backend for live donations
- release signing and store submission

See `CLIENT_HANDOVER.md` for the complete delivery and account status.

## Milestones (agreed)

1. Firebase setup, auth-free listings, buyer browse
2. Stripe donations, legal pages, testing
3. Store submission + 30 days support
