import 'package:flutter/material.dart';
import 'package:businesses_4_sale/constants/legal_copy.dart';
import 'package:businesses_4_sale/theme/app_theme.dart';

/// Pack p2-1 — Disclaimer as its own page, larger body type.
class DisclaimerScreen extends StatelessWidget {
  const DisclaimerScreen({
    super.key,
    this.showAppBar = true,
  });

  final bool showAppBar;

  @override
  Widget build(BuildContext context) {
    final content = SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!showAppBar) ...[
            const Text(
              'Disclaimer',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(height: 12),
          ],
          const Text(
            LegalCopy.disclaimer,
            style: TextStyle(
              height: 1.55,
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.ink,
            ),
          ),
        ],
      ),
    );

    if (!showAppBar) return content;

    return Scaffold(
      appBar: AppBar(title: const Text('Disclaimer')),
      body: content,
    );
  }
}
