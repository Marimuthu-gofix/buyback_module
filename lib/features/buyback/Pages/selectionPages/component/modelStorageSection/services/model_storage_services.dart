import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../../shared/api/api_config.dart';
import '../model/model_storage_model.dart';

class ModelStorageService {
  static Future<ModelStorageModel> fetchStorage(
    int modelId,
    String spec,
  ) async {
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
      return ModelStorageModel.fromRawJson(response.body);
    } else {
      throw Exception("Failed to load storage values");
    }
  }
}
