import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

Future<Map<String, String>> getDeviceDetails() async {
  final deviceInfo = DeviceInfoPlugin();

  String brand = "";
  String model = "";
  String deviceName = "";

  if (Platform.isAndroid) {
    final android = await deviceInfo.androidInfo;

    brand = android.brand ?? "";
    model = android.model ?? "";
    deviceName = android.name ?? "";
    // No android.name → build your own
  }
  else if (Platform.isIOS) {
    final ios = await deviceInfo.iosInfo;

    brand = "Apple";
    model = ios.utsname.machine ?? "";

    deviceName = "Apple ${ios.utsname.machine}";
  }
  String slugify(String input) {
    return input
        .toLowerCase()
        .trim()
        .replaceAll(RegExp(r'[^\w\s-]'), '') // remove special chars
        .replaceAll(RegExp(r'\s+'), '-')     // spaces → hyphen
        .replaceAll(RegExp(r'-+'), '-');     // multiple hyphens → single
  }

  final imageUrl =
      "https://gofix.co.in/assets/device-img/${slugify(deviceName)}.png";

  return {
    "brand": brand.toUpperCase(),
    "model": deviceName,
    "deviceName": deviceName,
    "imageUrl": imageUrl,
  };
}