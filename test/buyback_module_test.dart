import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:buyback_module/buyback_module.dart';

void main() {
  testWidgets('Buyback module loads welcome screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BuybackModule(
          config: BuybackConfig(appName: "TestApp"),
        ),
      ),
    );

    expect(find.text("Welcome to Buyback Module in TestApp 🚀"), findsOneWidget);
  });
}