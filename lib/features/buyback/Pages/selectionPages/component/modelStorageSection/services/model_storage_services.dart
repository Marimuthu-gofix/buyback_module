import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../../shared/api/api_config.dart';

import '../model/model_variant_model.dart';

class ModelStorageService {
  static Future<ModelVariantModel> getModelVariants({
    required int modelId,
    required List<String> attributes,
  }) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/GetModelVariants");

    final body = {"model_id": modelId, "attributes": attributes};

    print("POST BODY : ${jsonEncode(body)}");

    final response = await http.post(
      url,
      headers: {
        "accept": "application/json",
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );

    print("POST RESPONSE : ${response.body}");

    if (response.statusCode == 200) {
      return ModelVariantModel.fromRawJson(response.body);
    } else {
      throw Exception("Failed to load variants");
    }
  }
}
