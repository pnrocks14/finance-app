import 'package:finance_ui_kit/finance_ui_kit.dart';
import 'package:flutter/material.dart';

/// Shown for a moment while the app checks whether a PIN exists.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: CoinsIllustration(size: 96)));
}
