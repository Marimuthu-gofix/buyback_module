
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../shared/api/api_config.dart';

class AuthService {
  static const String _baseUrl = dotsmartApiConfig.baseUrl;

  /// Check if a customer exists
  static Future<bool> isCustomerExists(String phone) async {
    final url = Uri.parse('$_baseUrl/IsCustomerExists?phone=$phone');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        return result == true;
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect: $e');
    }
  }

  /// Send OTP request
  static Future<Map<String, dynamic>> requestOtp(String phone) async {
    final url = Uri.parse('$_baseUrl/RequestOTP');

    final body = jsonEncode({
      "phoneNo": phone,
      "type": "string",
    });

    try {
      final response = await http.put(
        url,
        headers: {
          'accept': 'text/plain',
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data;
      } else {
        throw Exception('Failed to send OTP: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error sending OTP: $e');
    }
  }

  ///  Verify OTP
  static Future<Map<String, dynamic>> verifyOtp({
    required String phone,
    required String otp,
    bool isExistingCustomer = true,
    String customerName = "",
    String emailAddress = "",
  }) async {
    final url = Uri.parse('$_baseUrl/VerifyOTP');

    final body = jsonEncode({
      "customerName": customerName,
      "emailAddress": emailAddress,
      "phoneNo": phone,
      "otp": otp.toString(),
      "isExistingCustomer": isExistingCustomer,
    });

    try {
      final response = await http.put(
        url,
        headers: {
          'accept': 'text/plain',
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        print("OTP Verification Response: $data");

        /// Save customerId + mobile number permanently
        if (data['status'] == true) {
          final prefs = await SharedPreferences.getInstance();

          // Save customerId
          if (data['customerId'] != null) {
            await prefs.setInt('customerId', data['customerId']);
            print("Saved customerId: ${data['customerId']}");
          }

          // Save mobile number
          await prefs.setString('mobile_number', phone);
          print("Saved Mobile Number: $phone");
        }

        return data;
      } else {
        throw Exception('Failed to verify OTP: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error verifying OTP: $e');
    }
  }
  ///  Clear on logout
  static Future<void> clearCustomerId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('customerId');
    print('Customer ID cleared from storage');
  }

  static Future<Map<String, dynamic>?> getCustomerByPhone(String phone) async {
    final response = await http.get(
      Uri.parse(
        "https://dotsmart-003-site10.gtempurl.com/ViewCustomerByPhoneNo?phoneNo=$phone",
      ),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      /// 🔥 SAVE customerId (same like OTP flow)
      if (data['customerId'] != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('customerId', data['customerId']);
        print("Saved customerId (Test Login): ${data['customerId']}");
      }

      return data;
    }
    return null;
  }
}
