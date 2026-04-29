import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../../shared/api/api_config.dart';
import '../model/model_color_model.dart';

class ModelColorService {
  static Future<ModelColorModel> fetchStorage(int modelId, String spec) async {
    final url = Uri.parse(
      "${ApiConfig.baseUrl}/GetModelAttributeValues"
      "?model_id=$modelId&spec=$spec",
    );

    print("📤 REQUEST URL: $url");

    final response = await http.get(
      url,
      headers: {"accept": "application/json"},
    );

    print("📥 STATUS: ${response.statusCode}");
    print("📥 BODY: ${response.body}");

    if (response.statusCode == 200) {
      return ModelColorModel.fromRawJson(response.body);
    } else {
      throw Exception("Failed to load storage values");
    }
  }
}
