import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../models/DeviceVariant.dart';

class DeviceVariantService {
  static const String url =
      "http://155.117.46.151:9010/api/v1/GetDeviceVariants";

  Future<List<DeviceVariant>> getDeviceVariants({
    required String deviceName,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"device_name": deviceName}),
      );

      debugPrint("STATUS => ${response.statusCode}");
      debugPrint("RAW RESPONSE => ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final List variants = data['variants'] ?? [];

        return variants
            .map((e) => DeviceVariant.fromJson(e))
            .toList();
      }

      return [];
    } catch (e) {
      debugPrint("ERROR => $e");
      return [];
    }
  }
}