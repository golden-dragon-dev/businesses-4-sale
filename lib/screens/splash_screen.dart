import 'package:flutter/material.dart';
import 'package:businesses_4_sale/screens/home_screen.dart';
import 'package:businesses_4_sale/theme/app_theme.dart';
import 'package:businesses_4_sale/widgets/bus_sale_logo.dart';

/// Splash — ivory ground, Atelier seal + wordmark.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.ivory,
      body: SafeArea(
        child: Center(
          child: BusSaleLogo(size: 180, showWordmark: true),
        ),
      ),
    );
  }
}
