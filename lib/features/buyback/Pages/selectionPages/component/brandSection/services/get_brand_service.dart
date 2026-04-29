import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../../shared/api/api_config.dart';
import '../model/brand_model.dart';

class GetBrandService {
  static Future<BrandList?> fetchBrands(int itemGroupId) async {
    try {
      final url = Uri.parse("${ApiConfig.baseUrl}/GetBrands").replace(
        queryParameters: {
          "item_group_id": itemGroupId.toString(),
        },
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return BrandList.fromJson(decoded);
      } else {
        throw Exception("API Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching brands: $e");
      return null;
    }
  }
}