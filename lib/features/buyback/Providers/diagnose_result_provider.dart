import 'package:flutter/material.dart';
import '../Pages/diagnosepage/diagnose_screen.dart';
import '../Pages/diagnosepage/models/DiagnoseQuestion.dart';

class DiagnoseResult {
  final String deviceName;
  final String deviceSpec;
  final String? imageUrl;
  final List<DiagnoseItem> items;
  final DateTime testedAt;

  DiagnoseResult({
    required this.deviceName,
    required this.deviceSpec,
    required this.imageUrl,
    required this.items,
    required this.testedAt,
  });

  int get passed => items.where((e) => e.status == TestStatus.passed).length;
  int get failed => items.where((e) => e.status == TestStatus.failed).length;
  bool get allPassed => failed == 0;
}

class DiagnoseResultProvider extends ChangeNotifier {
  DiagnoseResult? _result;
  DiagnoseResult? get result => _result;

  // ── ADD THESE 4 things ────────────────────────────────────────────────────
  Future<void> Function(String label)? _retestCallback;

  void registerRetestCallback(Future<void> Function(String label) cb) {
    _retestCallback = cb;
  }

  void unregisterRetestCallback() {
    _retestCallback = null;
  }

  bool get canRetest => _retestCallback != null;

  List<DiagnoseQuestion> questions = [];

  Future<void> retest(String label) async {
    await _retestCallback?.call(label);
  }
  // ─────────────────────────────────────────────────────────────────────────

  void saveResult({
    required String deviceName,
    required String deviceSpec,
    required String? imageUrl,
    required List<DiagnoseItem> items,
  }) {
    _result = DiagnoseResult(
      deviceName: deviceName,
      deviceSpec: deviceSpec,
      imageUrl: imageUrl,
      items: List.unmodifiable(items),
      testedAt: DateTime.now(),
    );
    notifyListeners();
  }

  void clear() {
    _result = null;
    notifyListeners();
  }
}