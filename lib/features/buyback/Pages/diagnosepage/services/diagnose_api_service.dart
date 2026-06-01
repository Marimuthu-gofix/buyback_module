import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/DiagnoseQuestion.dart';

class DiagnoseApiService {
  static const String _baseUrl =
      'http://155.117.46.151:9010/api/v2/GetAutomatedTestList';

  Future<List<DiagnoseQuestion>> fetchQuestions() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final List list = data['data'];

      return list
          .map((e) => DiagnoseQuestion.fromJson(e))
          .toList();
    } else {
      throw Exception('Failed to load questions');
    }
  }
}