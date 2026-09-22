import 'package:flutter/material.dart';
import 'package:businesses_4_sale/theme/app_theme.dart';

class LegalScreen extends StatelessWidget {
  const LegalScreen({
    super.key,
    required this.title,
    required this.body,
    this.showAppBar = true,
  });

  final String title;
  final String body;
  final bool showAppBar;

  @override
  Widget build(BuildContext context) {
    final content = SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!showAppBar) ...[
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(height: 12),
          ],
          Text(
            body,
            style: const TextStyle(
              height: 1.45,
              fontSize: 15,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );

    if (!showAppBar) return content;

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: content,
    );
  }
}
