// import 'dart:convert';
//
// import 'package:http/http.dart' as http;
//
// import '../model/buyback_assessment_model.dart';
//
// class BuybackPostService {
//   static Future<Map<String, dynamic>?> submitEvaluation(
//     BuybackPostModel model,
//   ) async {
//     try {
//       final body = jsonEncode(model.toJson());
//
//       print("POST BODY:");
//       print(body);
//
//       final response = await http.post(
//         Uri.parse(
//           "http://155.117.46.151:9010/api/v1/buyback-assessment-questionresult",
//         ),
//
//         headers: {
//           "accept": "application/json",
//
//           "Content-Type": "application/json",
//         },
//
//         body: body,
//       );
//
//       print("STATUS CODE:");
//       print(response.statusCode);
//
//       print("RESPONSE:");
//       print(response.body);
//
//       /// ✅ SUCCESS
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         return jsonDecode(response.body);
//       }
//
//       /// ✅ ERROR RESPONSE
//       return {"estimated_price": 0, "error": response.body};
//     } catch (e) {
//       print(e);
//
//       return {"estimated_price": 0, "error": e.toString()};
//     }
//   }
// }

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/buyback_assessment_model.dart';

class BuybackPostService {

  static Future<Map<String, dynamic>?> submitEvaluation({

    required String customer,
    required String customerName,
    required String email,
    required String mobileNo,
    required String chCustomerId,

    required String itemCode,
    required String itemName,
    required String brand,
    required String imeiSerial,
    required String company,
    required String itemGroup,
    required List<ResponseModel> responses,

  }) async {

    try {

      final model = BuybackPostModel(

        customer: customer,
        customerName: customerName,
        mobileNo: mobileNo,
        email: email,
        chCustomerId: chCustomerId,

        source: "Web",
        owner: "Administrator",

        itemCode: itemCode,
        itemName: itemName,
        brand: brand,
        imeiSerial: imeiSerial,
        company: company,
        itemGroup: itemGroup,

        responses: responses,
      );

      final body = jsonEncode(model.toJson());

      print("FINAL BODY:");
      print(body);

      final response = await http.post(

        Uri.parse(
          "http://155.117.46.151:9010/api/v1/buyback-assessment-questionresult",
        ),

        headers: {
          "accept": "application/json",
          "Content-Type": "application/json",
        },

        body: body,
      );

      print("STATUS CODE:");
      print(response.statusCode);

      print("RESPONSE:");
      print(response.body);

      if (response.statusCode == 200 ||
          response.statusCode == 201) {

        return jsonDecode(response.body);
      }

      return {
        "estimated_price": 0,
        "error": response.body,
      };

    } catch (e) {

      print(e);

      return {
        "estimated_price": 0,
        "error": e.toString(),
      };
    }
  }
}