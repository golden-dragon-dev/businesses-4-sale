import 'package:flutter/material.dart';
import 'package:businesses_4_sale/theme/app_theme.dart';

class LegalScreen extends StatelessWidget {
  const LegalScreen({
    super.key,
    required this.title,
    required this.body,
  });

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Text(
          body,
          style: const TextStyle(
            height: 1.45,
            fontSize: 15,
            color: AppColors.black,
          ),
        ),
      ),
    );
  }
}
