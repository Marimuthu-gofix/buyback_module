import 'dart:convert';
import 'package:http/http.dart' as http;

/// ================= MODEL =================

class BuybackAssessmentResponse {

  final bool success;
  final String assessmentName;
  final double basePrice;
  final double totalPercent;
  final double calculatedPrice;
  final double floorPrice;
  final double estimatedPrice;

  BuybackAssessmentResponse({
    required this.success,
    required this.assessmentName,
    required this.basePrice,
    required this.totalPercent,
    required this.calculatedPrice,
    required this.floorPrice,
    required this.estimatedPrice,
  });

  factory BuybackAssessmentResponse.fromJson(
      Map<String, dynamic> json,
      ) {

    return BuybackAssessmentResponse(

      success: json["success"] ?? false,

      assessmentName:
      json["assessment_name"] ?? '',

      basePrice:
      (json["base_price"] ?? 0).toDouble(),

      totalPercent:
      (json["total_percent"] ?? 0).toDouble(),

      calculatedPrice:
      (json["calculated_price"] ?? 0).toDouble(),

      floorPrice:
      (json["floor_price"] ?? 0).toDouble(),

      estimatedPrice:
      (json["estimated_price"] ?? 0).toDouble(),
    );
  }
}

/// ================= API =================

Future<BuybackAssessmentResponse?>
submitBuybackAssessment({

  required String itemCode,
  required String itemName,
  required String brand,
  required String customer,
  required String customerName,
  required String mobileNo,
  required String email,
  required String imeiSerial,
  required List<Map<String, String>> diagnostics,
  required String ch_customer_id,

}) async {

  const url =
      "http://155.117.46.151:9010/api/v1/buyback-full-assessment-diagonosis";

  try {

    final body = {

      "customer": customer,

      "customer_name": customerName,

      "mobile_no": mobileNo,

      "ch_customer_id": ch_customer_id,

      "email_id": email,

      "item_code": itemCode,

      "item_name": itemName,

      "brand": brand,

      "imei_serial": imeiSerial,

      "source": "Web",

      "company": "",

      "item_group": "",

      "owner": "Administrator",

      "responses": [
        {
          "question_id": "BQB-00001",
          "answer_value": "Yes"
        }
      ],

      "diagnostics": diagnostics,
    };

    /// ✅ PRINT REQUEST

    print("\n========== API REQUEST ==========");

    print(
      const JsonEncoder.withIndent('  ')
          .convert(body),
    );

    print("=================================\n");

    /// ✅ API CALL

    final response = await http.post(

      Uri.parse(url),

      headers: {
        "Content-Type": "application/json",
      },

      body: jsonEncode(body),
    );

    /// ✅ STATUS CODE

    print(
      "STATUS CODE => ${response.statusCode}",
    );

    /// ✅ RESPONSE BODY

    print(
      "\n========== API RESPONSE ==========",
    );

    print(response.body);

    print(
      "==================================\n",
    );

    /// ✅ SUCCESS

    if (response.statusCode == 200 ||
        response.statusCode == 201) {

      final data =
      jsonDecode(response.body);

      final result =
      BuybackAssessmentResponse.fromJson(
        data,
      );

      /// ✅ PRINT MODEL VALUES

      print(
        "SUCCESS => ${result.success}",
      );

      print(
        "ASSESSMENT NAME => ${result.assessmentName}",
      );

      print(
        "BASE PRICE => ${result.basePrice}",
      );

      print(
        "ESTIMATED PRICE => ${result.estimatedPrice}",
      );

      return result;
    }

    return null;

  } catch (e) {

    print("API ERROR => $e");

    return null;
  }
}