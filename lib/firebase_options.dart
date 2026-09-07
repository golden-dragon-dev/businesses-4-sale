// File generated-style stub for FlutterFire.
// Replace by running: dart pub global run flutterfire_cli:flutterfire configure
//
// Until real options exist, keep AppConfig.firebaseConfigured = false
// (default) so the app uses DemoListingRepository.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not configured for this platform. '
          'Run flutterfire configure after Firebase project setup.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'REPLACE_ME',
    appId: 'REPLACE_ME',
    messagingSenderId: 'REPLACE_ME',
    projectId: 'businesses-4-sale',
    authDomain: 'businesses-4-sale.firebaseapp.com',
    storageBucket: 'businesses-4-sale.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'REPLACE_ME',
    appId: 'REPLACE_ME',
    messagingSenderId: 'REPLACE_ME',
    projectId: 'businesses-4-sale',
    storageBucket: 'businesses-4-sale.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'REPLACE_ME',
    appId: 'REPLACE_ME',
    messagingSenderId: 'REPLACE_ME',
    projectId: 'businesses-4-sale',
    storageBucket: 'businesses-4-sale.appspot.com',
    iosBundleId: 'au.com.bus4sale.businesses4Sale',
  );
}
