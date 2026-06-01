import 'package:disk_space_plus/disk_space_plus.dart';
import 'package:flutter/services.dart';

Future<String> getStorage() async {
  final diskSpace = DiskSpacePlus();

  double? totalMB = await diskSpace.getTotalDiskSpace;

  if (totalMB == null) {
    return "Storage unavailable";
  }

  double totalGB = totalMB / 1024;

  // 🔥 Round to nearest REAL marketed size
  if (totalGB < 40) return "32GB";
  if (totalGB < 80) return "64GB";
  if (totalGB < 150) return "128GB";
  if (totalGB < 300) return "256GB";
  if (totalGB < 600) return "512GB";
  return "1TB";
}

class DeviceHelper {
  static const platform = MethodChannel('device_info');

  static Future<String> getRam() async {
    try {
      final int ramMB = await platform.invokeMethod('getRam');
      print("RAM MB: $ramMB"); // 👈 DEBUG

      double ramGB = ramMB / 1024;

      if (ramGB <= 4) return "4GB";
      if (ramGB <= 6) return "6GB";
      if (ramGB <= 8) return "8GB";
      if (ramGB <= 12) return "12GB";
      if (ramGB <= 16) return "16GB";

      return "${ramGB.toStringAsFixed(0)}GB";
    } catch (e) {
      print("RAM ERROR: $e"); // 👈 DEBUG
      return "Unknown RAM";
    }
  }
}

