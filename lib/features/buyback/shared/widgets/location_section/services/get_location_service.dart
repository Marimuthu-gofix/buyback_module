import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../location_api.dart';
import '../model/location_model.dart';

class GetLocationService {
  static const String apiUrl = LocationApi.baseUrl;

  static Future<LocationModel?> fetchLocations() async {
    try {
      final url = Uri.parse("$apiUrl/GetLocationList");

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data["status"] == true) {
          return LocationModel.fromJson(data);
        } else {
          if (kDebugMode) {
            print("API Error: ${data["message"]}");
          }
          return null;
        }
      } else {
        if (kDebugMode) {
          print("HTTP Error: ${response.statusCode}");
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Exception in fetchLocations: $e");
      }
      return null;
    }
  }
}
