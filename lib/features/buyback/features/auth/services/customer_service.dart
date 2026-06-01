import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../shared/api/api_config.dart';
import '../model/customer_model.dart';


class CustomerService {
  static const String _baseUrl = dotsmartApiConfig.baseUrl;

  ///Save Customer
  Future<int?> saveCustomer(Customer customer) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/SaveCustomer'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(customer.toJson()),
      );

      if (response.statusCode == 200) {
        final body = response.body.trim();
        print('Raw API response: $body');

        final customerId = int.tryParse(body);
        if (customerId != null) {
          print(' Customer saved with ID: $customerId');
          /// Persist ID locally (survives app close)
          final prefs = await SharedPreferences.getInstance();
          await prefs.setInt('customerId', customerId);
          print(' Customer ID stored permanently');
          return customerId;
        } else {
          print(' Could not parse customer ID: $body');
          return null;
        }
      } else {
        print(' Failed to save customer: ${response.statusCode}');
        print('Response: ${response.body}');
        return null;
      }
    } catch (e) {
      print(' Error saving customer: $e');
      return null;
    }
  }

  static  validateCustomer(String text) async {}
}
