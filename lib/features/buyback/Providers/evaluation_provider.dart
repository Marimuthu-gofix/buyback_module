import 'package:flutter/material.dart';

class EvaluationProvider extends ChangeNotifier {
  final Map<String, Map<String, String>> _sections = {
    "Overall Condition": {},
    "Physical Condition": {},
    "Functional Problems": {},
    "Accessories": {},
    "Warranty": {},
  };

  Map<String, Map<String, String>> get sections => _sections;

  void updateAnswer(String section, String question, String answer) {
    _sections[section]?[question] = answer;
    notifyListeners();
  }

  /// ✅ ADD HERE
  void clearSection(String section) {
    _sections[section]?.clear();
    notifyListeners();
  }

  /// (optional)
  void clearAll() {
    for (var section in _sections.values) {
      section.clear();
    }
    notifyListeners();
  }
}