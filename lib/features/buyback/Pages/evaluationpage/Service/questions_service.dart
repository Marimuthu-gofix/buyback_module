import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/question_model.dart';

class QuestionsService {
  static const String baseUrl =
      "http://155.117.46.151:9010/api/v2/GetBuybackQuestionsByModel";

  static Future<List<CategoryModel>> fetchQuestions({
    required String itemCode,
  }) async {
    try {
      final url = Uri.parse("$baseUrl?item_code=$itemCode");

      final response = await http.get(
        url,
        headers: {"accept": "application/json"},
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        final result = BuybackResponse.fromJson(jsonData);

        return result.data;
      } else {
        throw Exception("Failed to load questions");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}
