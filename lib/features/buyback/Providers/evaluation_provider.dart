import 'package:flutter/material.dart';
import '../Pages/evaluationpage/Service/questions_service.dart';
import '../Pages/evaluationpage/model/question_model.dart';

class EvaluationProvider extends ChangeNotifier {
  /// =========================
  /// STORE ANSWERS
  /// =========================
  final Map<String, List<Map<String, String>>> _sections = {
    "Overall Condition": [],
    "Physical Condition": [],
    "Functional Problems": [],
    "Accessories": [],
    "Warranty": [],
  };

  /// =========================
  /// GETTER
  /// =========================
  Map<String, List<Map<String, String>>> get sections => _sections;

  /// =========================
  /// API DATA
  /// =========================
  List<CategoryModel> _categories = [];

  /// =========================
  /// CATEGORY LISTS
  /// =========================
  List<QuestionModel> _general = [];

  List<QuestionModel> _physical = [];

  List<QuestionModel> _functional = [];

  List<QuestionModel> _accessories = [];

  List<QuestionModel> _warranty = [];

  /// =========================
  /// GETTERS
  /// =========================
  List<QuestionModel> get generalQuestions => _general;

  List<QuestionModel> get physicalQuestions => _physical;

  List<QuestionModel> get functionalQuestions => _functional;

  List<QuestionModel> get accessoriesQuestions => _accessories;

  List<QuestionModel> get warrantyQuestions => _warranty;

  /// =========================
  /// LOADING
  /// =========================
  bool isLoading = false;

  /// =========================
  /// LOAD QUESTIONS
  /// =========================
  /// =========================
  /// LOAD QUESTIONS
  /// =========================
  Future<void> loadQuestions(String itemCode) async {
    try {
      isLoading = true;

      notifyListeners();

      _categories = await QuestionsService.fetchQuestions(itemCode: itemCode);

      _general = _getCategory("general");

      _physical = _getCategory("physical");

      _functional = _getCategory("functional");

      _accessories = _getCategory("accessories");

      _warranty = _getCategory("warrenty");

      isLoading = false;

      notifyListeners();
    } catch (e) {
      isLoading = false;

      notifyListeners();

      print(e);
    }
  }

  /// =========================
  /// HELPER
  /// =========================
  List<QuestionModel> _getCategory(String name) {
    try {
      return _categories
          .firstWhere(
            (c) => c.category.toLowerCase().trim() == name.toLowerCase().trim(),
          )
          .questions;
    } catch (e) {
      return [];
    }
  }

  /// =========================
  /// STORE ANSWER
  /// =========================
  void updateAnswer(
    String section,
    String questionText,
    String questionId,
    String answerValue,
    String answerLabel,
  ) {
    final sectionList = _sections[section];

    if (sectionList == null) return;

    /// REMOVE OLD ANSWER
    sectionList.removeWhere((e) => e["question_id"] == questionId);

    /// ADD NEW ANSWER
    sectionList.add({
      "question_text": questionText,
      "question_id": questionId,
      "answer_value": answerValue,
      "answer_label": answerLabel,
    });

    print(_sections);

    notifyListeners();
  }

  /// =========================
  /// REMOVE ANSWER
  /// =========================
  void removeAnswer(String section, String questionId) {
    final sectionList = _sections[section];

    if (sectionList == null) return;

    sectionList.removeWhere((e) => e["question_id"] == questionId);

    notifyListeners();
  }

  /// =========================
  /// CLEAR SECTION
  /// =========================
  void clearSection(String section) {
    _sections[section]?.clear();

    notifyListeners();
  }

  /// =========================
  /// CLEAR ALL
  /// =========================
  void clearAll() {
    _sections.forEach((key, value) {
      value.clear();
    });

    notifyListeners();
  }
}
