import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../../shared/api/api_config.dart';

import '../model/model_color_model.dart';

class ModelColorService {
  static Future<ModelColorModel> fetchColors({
    required int modelId,
    required String storageValue,
  }) async {
    final url = Uri.parse(
      "${ApiConfig.baseUrl}/api/v1/get-colors-by-storage"
      "?model_id=$modelId"
      "&storage_value=$storageValue",
    );

    print("COLOR URL : $url");

    final response = await http.get(
      url,
      headers: {"accept": "application/json"},
    );

    print("COLOR RESPONSE : ${response.body}");

    if (response.statusCode == 200) {
      return ModelColorModel.fromRawJson(response.body);
    } else {
      throw Exception("Failed to load colors");
    }
  }
}
