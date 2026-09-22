import 'package:flutter/material.dart';
import 'package:businesses_4_sale/screens/main_shell_screen.dart';
import 'package:businesses_4_sale/theme/app_theme.dart';
import 'package:businesses_4_sale/widgets/bus_sale_logo.dart';

/// Splash — client-aligned BUS.SALE mark.
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
        MaterialPageRoute<void>(builder: (_) => const MainShellScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Pack p3: white background, BUS.SALE mark centered.
    return const Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Center(
          child: BusSaleLogo(size: 220, showWordmark: true),
        ),
      ),
    );
  }
}
