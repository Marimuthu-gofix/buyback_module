/// buyback_customer_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/CustomerResponseModel.dart';

class BuyBackCustomerService {
  static const String baseUrl =
      'http://155.117.46.151:9010';

  static Future<BuyBackCustomerResponseModel?>
  saveCustomer(
      BuyBackCustomerModel customer,
      ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/Customer/Save'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(customer.toJson()),
      );

      print("STATUS CODE : ${response.statusCode}");
      print("RESPONSE : ${response.body}");

      if (response.statusCode == 200) {
        return BuyBackCustomerResponseModel.fromJson(
          jsonDecode(response.body),
        );
      }

      return null;
    } catch (e) {
      print("API ERROR : $e");
      return null;
    }
  }
}