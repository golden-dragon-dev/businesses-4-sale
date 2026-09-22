# Businesses 4 Sale — Client Handover

Prepared for David on 23 September 2026.

## Delivery contents

The accompanying source archive contains the latest local project files for the
Businesses 4 Sale Flutter application, including:

- Flutter/Dart application source
- Android, iOS, and web platform projects
- app artwork, brand assets, and the P1 advertising image
- Firestore and Firebase Storage rules
- automated tests
- dependency manifests and lock file
- brand-generation and local utility scripts
- this handover document

Generated build output, local caches, Git history, editor settings, temporary
files, local Cloudflare configuration, signing keys, and credentials are not
included.

The archive also includes `Developer Pack amended.pdf`, which records the
original project scope and supplied design references.

## Current product status

This is the current prototype/source version (`1.0.0+1`). Its implemented flow
is:

`Splash → Home → Disclaimer → Join → Browse → Donate → Privacy → Terms`

The main sections can be changed by swiping left or right. The advertising
banner has its own carousel controls and displays the P1 flyer first.

The application currently starts in demo mode. Demo listings work without a
cloud account, and the donation screen demonstrates the user flow without
charging money.

This delivery is source code, not a production-ready store release. Production
Firebase, Stripe, app-store signing, store listings, and final account setup
were not completed because the required client-owned accounts and credentials
were not supplied.

## Access and account status

### Source repository

Repository URL:

`https://github.com/golden-dragon-dev/businesses-4-sale`

The repository's remote `main` branch contains the initial commit. The source
archive supplied with this handover is the important copy because it also
contains the latest local work that has not been committed to the remote
repository.

Repository ownership or collaborator access must be arranged separately through
GitHub. No GitHub password or personal access token is included.

### Cloudflare Pages

The former Cloudflare Pages project named `businesses-4-sale` was deleted after
the project was closed. There is no active preview deployment or Cloudflare
access to transfer.

### Firebase

No production Firebase project is connected. `lib/firebase_options.dart`
contains placeholders only, and no Firebase credential files are included.
Firestore and Storage rule drafts are provided in `firestore/`.

### Stripe

No Stripe account or live/test key is connected. The current donation
implementation is a demo flow and does not charge a card. A secure server-side
PaymentIntent/subscription backend is still required.

### Apple and Google

No Apple Developer or Google Play Console account access, certificates,
provisioning profiles, Android upload key, or production signing configuration
is included. These must be created and controlled by the client.

### Domain and business contact

The app references the client-provided contact details:

- Email: `bus.4sales@gmail.com`
- Website: `https://www.bus.4sale.com.au`

No email, domain registrar, hosting, or social-media passwords are stored in the
project.

## Opening and running the project

Prerequisites:

- Flutter SDK compatible with Dart `^3.13.2`
- Android Studio/Android SDK for Android development
- Xcode and an Apple computer for iOS signing and release
- a current web browser for web development

From the project directory:

```bash
flutter pub get
flutter test
flutter run
```

The default command runs the in-memory demo backend.

To connect Firebase later:

1. Create a client-owned Firebase project with Firestore and Storage.
2. Run `flutterfire configure` and replace the placeholder configuration.
3. Review and harden the rules in `firestore/` before production use.
4. Deploy the reviewed rules.
5. Run with:

```bash
flutter run \
  --dart-define=USE_DEMO_BACKEND=false \
  --dart-define=FIREBASE_CONFIGURED=true
```

Do not put Stripe secret keys in the app. Live donations require a
server-controlled endpoint that creates Stripe PaymentIntents or subscriptions.

## Items requiring completion before release

- obtain and verify all client-owned Apple, Google, Firebase, and Stripe accounts
- replace Firebase placeholder configuration
- implement and test the secure Stripe backend
- tighten public Firebase write rules with validation, abuse protection, and App Check
- configure Android release signing (the current release build uses debug signing)
- configure Apple signing, certificates, and provisioning
- confirm final Android application ID and Apple bundle ID
- replace placeholder App Store URL after the Apple listing is created
- review web manifest names, colours, and icons
- perform current Flutter analysis and automated/manual testing
- complete privacy, legal, store, accessibility, and device review
- create production builds and submit them through the client-owned store accounts

## Verification note

No credential files, private keys, keystores, `.env` files, or production API
keys were found in the project tree during packaging.

Fresh `flutter test` and `flutter analyze lib` commands could not be run in the
packaging shell because the Flutter executable was not available on its
`PATH`. The recipient should run both commands in a configured Flutter
environment before relying on or releasing the source.

