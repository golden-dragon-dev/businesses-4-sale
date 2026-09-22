import 'package:businesses_4_sale/config/app_config.dart';

enum DonationFrequency { oneOff, monthly }

class DonationRequest {
  const DonationRequest({
    required this.frequency,
    required this.amountAud,
  });

  final DonationFrequency frequency;
  final int amountAud;
}

class DonationResult {
  const DonationResult({
    required this.success,
    required this.message,
    this.demo = false,
  });

  final bool success;
  final String message;
  final bool demo;
}

/// Handles Stripe donations.
///
/// Without a publishable key + PaymentIntent backend, runs a safe demo flow
/// so UI and milestones can be tested end-to-end.
class DonationService {
  Future<DonationResult> donate(DonationRequest request) async {
    if (request.amountAud < 1) {
      return const DonationResult(
        success: false,
        message: 'Enter a valid donation amount.',
      );
    }

    if (!AppConfig.stripeReady) {
      await Future<void>.delayed(const Duration(milliseconds: 600));
      final label = request.frequency == DonationFrequency.monthly
          ? 'monthly'
          : 'one-off';
      return DonationResult(
        success: true,
        demo: true,
        message:
            'Demo donation recorded: \$${request.amountAud} AUD ($label). '
            'Connect Stripe to take live payments.',
      );
    }

    // Live Stripe Payment Sheet wiring goes here once keys + Cloud Function
    // PaymentIntent / Subscription endpoints are available.
    return const DonationResult(
      success: false,
      message:
          'Stripe key is set but PaymentIntent backend is not connected yet.',
    );
  }
}
