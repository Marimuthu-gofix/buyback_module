import 'package:flutter/material.dart';

// 👉 import your home screen
import '../Pages/home.dart'; // adjust path if needed

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
        child: InkWell(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => home(), // or HomePage(config: ...)
              ),
            );
          },
          child: Text(
            "Welcome to Buyback Module in $appName 🚀",
            style: const TextStyle(
              fontSize: 18,
              decoration: TextDecoration.underline, // optional UI hint
            ),
          ),
        ),
      ),
    );
  }
}