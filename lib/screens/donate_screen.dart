import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:businesses_4_sale/config/app_config.dart';
import 'package:businesses_4_sale/services/donation_service.dart';
import 'package:businesses_4_sale/theme/app_theme.dart';
import 'package:businesses_4_sale/widgets/ad_banner.dart';

class DonateScreen extends StatefulWidget {
  const DonateScreen({super.key});

  @override
  State<DonateScreen> createState() => _DonateScreenState();
}

class _DonateScreenState extends State<DonateScreen> {
  DonationFrequency _frequency = DonationFrequency.oneOff;
  int? _selectedAmount = 20;
  final _otherController = TextEditingController();
  bool _busy = false;
  final _service = DonationService();

  @override
  void dispose() {
    _otherController.dispose();
    super.dispose();
  }

  int? get _amount {
    if (_selectedAmount != null) return _selectedAmount;
    return int.tryParse(_otherController.text.trim());
  }

  Future<void> _donate() async {
    final amount = _amount;
    if (amount == null || amount < 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Choose or enter a valid amount.')),
      );
      return;
    }

    setState(() => _busy = true);
    try {
      final result = await _service.donate(
        DonationRequest(frequency: _frequency, amountAud: amount),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.message)),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Donate')),
      body: Column(
        children: [
          const AdBanner(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text(
                  'Support Businesses 4 Sale',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                Text(
                  AppConfig.stripeReady
                      ? 'Pay securely with Stripe (Card / Apple Pay / Google Pay).'
                      : 'Demo mode: Stripe keys not connected yet. You can still try the flow.',
                  style: const TextStyle(color: AppColors.grey),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Frequency',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                SegmentedButton<DonationFrequency>(
                  segments: const [
                    ButtonSegment(
                      value: DonationFrequency.oneOff,
                      label: Text('One off'),
                    ),
                    ButtonSegment(
                      value: DonationFrequency.monthly,
                      label: Text('Monthly'),
                    ),
                  ],
                  selected: {_frequency},
                  onSelectionChanged: (value) {
                    setState(() => _frequency = value.first);
                  },
                ),
                const SizedBox(height: 24),
                const Text(
                  'Amount (AUD)',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final amount in [20, 30, 50])
                      ChoiceChip(
                        label: Text('\$$amount'),
                        selected: _selectedAmount == amount,
                        onSelected: (_) {
                          setState(() {
                            _selectedAmount = amount;
                            _otherController.clear();
                          });
                        },
                      ),
                    ChoiceChip(
                      label: const Text('Other'),
                      selected: _selectedAmount == null,
                      onSelected: (_) {
                        setState(() => _selectedAmount = null);
                      },
                    ),
                  ],
                ),
                if (_selectedAmount == null) ...[
                  const SizedBox(height: 12),
                  TextField(
                    controller: _otherController,
                    decoration: const InputDecoration(
                      labelText: 'Other amount',
                      prefixText: '\$ ',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (_) => setState(() {}),
                  ),
                ],
                const SizedBox(height: 24),
                const Text(
                  'Payment method',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Stripe · Card / Apple Pay / Google Pay',
                  style: TextStyle(color: AppColors.grey),
                ),
                const SizedBox(height: 28),
                ElevatedButton(
                  onPressed: _busy ? null : _donate,
                  child: _busy
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Donate'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
