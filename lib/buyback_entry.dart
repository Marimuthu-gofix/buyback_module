import 'package:flutter/material.dart';
import 'features/buyback/screens/welcome_screen.dart';

class BuybackConfig {
  final String appName;

  BuybackConfig({required this.appName});
}

class BuybackModule extends StatelessWidget {
  final BuybackConfig config;

  const BuybackModule({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return BuybackWelcomeScreen(
      appName: config.appName,
    );
  }
}