import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../../shared/api/api_config.dart';
import '../model/model_model.dart';

class GetModelService {
  static Future<Modellist?> fetchModels(
      int brandId,
      int itemGroupId,
      ) async {
    try {
      final url = Uri.parse("${ApiConfig.baseUrl}/GetModelsByBrand").replace(
        queryParameters: {
          "brand_id": brandId.toString(),
          "item_group_id": itemGroupId.toString(),
        },
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return Modellist.fromJson(decoded);
      } else {
        throw Exception("API Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Model API Error: $e");
      return null;
    }
  }
}