import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../../shared/api/api_config.dart';

import '../model/variantprice_model.dart';

class GetItemsService {
  static Future<GetItemsModel> fetchItems({
    required int itemGroupId,
    required int brandId,
    required int modelId,
    required String storage,
    required String colour,
  }) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/GetItemsWithSpec");

    final body = {
      "item_group_id": itemGroupId,
      "brand_id": brandId,
      "model_id": modelId,
      "filters": {"storage": storage, "colour": colour},
    };

    print("📤 BODY: ${jsonEncode(body)}");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "accept": "application/json",
      },
      body: jsonEncode(body),
    );

    print("📥 RESPONSE: ${response.body}");

    if (response.statusCode == 200) {
      return GetItemsModel.fromRawJson(response.body);
    } else {
      throw Exception("API Failed");
    }
  }
}
class BuybackService {
  static Future<BuybackPriceModel> getPrice(String itemCode) async {
    final url = Uri.parse(
        "${ApiConfig.baseUrl}/GetBuybackPrice?item_code=$itemCode");

    final response = await http.get(url);

    print("📥 PRICE RESPONSE: ${response.body}");

    if (response.statusCode == 200) {
      return BuybackPriceModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Price API Failed");
    }
  }
}