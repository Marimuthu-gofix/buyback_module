import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/CustomerResponseModel.dart';

class CustomerService {

  static Future<CustomerResponseModel?> validateCustomer(
      String mobileNo) async {

    try {

      final url =
          "http://155.117.46.151:9010/Customer/ValidateGoFixCustomer?mobile_no=$mobileNo";

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {

        final data = jsonDecode(response.body);

        return CustomerResponseModel.fromJson(data);

      } else {

        print("Status Code : ${response.statusCode}");
        return null;
      }

    } catch (e) {

      print("Error : $e");
      return null;
    }
  }
}