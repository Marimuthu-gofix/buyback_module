import 'package:flutter/material.dart';

class BuybackWelcomeScreen extends StatelessWidget {
  final String appName;

  const BuybackWelcomeScreen({super.key, required this.appName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Buyback Module"),
      ),
      body: Center(
        child: Text(
          "Welcome to Buyback Module in $appName 🚀",
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}