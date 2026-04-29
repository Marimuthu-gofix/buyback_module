import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:buyback_module/buyback_module.dart';

void main() {
  testWidgets('Buyback module loads home screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: BuybackModule(
          config: BuybackConfig(appName: "TestApp"),
        ),
      ),
    );

    // Wait for UI to build properly
    await tester.pumpAndSettle();

    // ✅ Check AppBar title (based on your HomePage)
    expect(find.text("Buyback - TestApp"), findsOneWidget);
  });
}