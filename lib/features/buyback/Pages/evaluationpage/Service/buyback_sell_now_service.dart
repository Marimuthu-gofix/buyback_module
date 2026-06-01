import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/buyback_sell_now_model.dart';

class SellNowService {
  static Future<Map<String, dynamic>> sellNow({
    required String assessmentName,
  }) async {
    try {
      final model = SellNowModel(name: assessmentName);

      final response = await http.post(
        Uri.parse("http://155.117.46.151:9010/api/v1/buyback-sell-now"),

        headers: {
          "accept": "application/json",
          "Content-Type": "application/json",
        },

        body: jsonEncode(model.toJson()),
      );

      print("SELL NOW STATUS CODE:");
      print(response.statusCode);

      print("SELL NOW RESPONSE:");
      print(response.body);

      return jsonDecode(response.body);
    } catch (e) {
      return {"success": false, "message": e.toString()};
    }
  }
}
