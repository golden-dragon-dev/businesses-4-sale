import 'package:flutter/foundation.dart';

/// Join is mobile-app only (Developer Pack + client confirmation).
class PlatformGuard {
  PlatformGuard._();

  static bool get canSubmitListing {
    if (kIsWeb) return false;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
        return true;
      default:
        // Allow desktop during local Flutter development / Codex tests.
        return !kReleaseMode;
    }
  }

  static String get blockedMessage =>
      'Join is only available in the Businesses 4 Sale mobile app.';
}
