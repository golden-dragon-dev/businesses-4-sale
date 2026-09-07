/// Runtime configuration.
///
/// Set [useDemoBackend] to false after Firebase + Stripe accounts are wired.
class AppConfig {
  AppConfig._();

  /// When true, listings use in-memory demo data (no Firebase required).
  /// Codex / local tests run against this mode by default.
  static const bool useDemoBackend = bool.fromEnvironment(
    'USE_DEMO_BACKEND',
    defaultValue: true,
  );

  /// Flip to true once `lib/firebase_options.dart` is generated via FlutterFire.
  static const bool firebaseConfigured = bool.fromEnvironment(
    'FIREBASE_CONFIGURED',
    defaultValue: false,
  );

  /// Stripe publishable key (pk_test_... / pk_live_...). Empty = demo donate flow.
  static const String stripePublishableKey = String.fromEnvironment(
    'STRIPE_PUBLISHABLE_KEY',
    defaultValue: '',
  );

  static const String appName = 'Businesses 4 Sale';
  static const String appShortName = 'BUS.SALE';
  static const String supportEmail = 'bus.4sales@gmail.com';
  static const String websiteUrl = 'https://www.bus.4sale.com.au';

  /// Replace with real store URLs after publishing.
  static const String playStoreUrl =
      'https://play.google.com/store/apps/details?id=au.com.bus4sale.businesses_4_sale';
  static const String appStoreUrl =
      'https://apps.apple.com/app/businesses-4-sale/id0000000000';

  static const Duration currentListingsWindow = Duration(days: 2);
  static const Duration typeListingsWindow = Duration(days: 7);
  static const Duration adRotateInterval = Duration(seconds: 5);
  static const int maxPhotoBytes = 500 * 1024;

  static bool get stripeReady => stripePublishableKey.isNotEmpty;
  static bool get useFirebase =>
      !useDemoBackend && firebaseConfigured;
}
