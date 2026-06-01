import 'dart:convert';
import 'package:flutter/material.dart';
import '../Pages/diagnosepage/models/DeviceVariant.dart';

class DeviceVariantProvider extends ChangeNotifier {
  List<DeviceVariant> variants = [];
  DeviceVariant? selectedVariant;

  void setVariants(List<DeviceVariant> data) {
    variants = data;
    notifyListeners();
  }

  void selectVariant(DeviceVariant item) {
    selectedVariant = item;

    // 🔥 PRINT JSON (DEBUG)
    debugPrint("SELECTED VARIANT => ${jsonEncode(item.toJson())}");

    notifyListeners();
  }

  // ✅ GET JSON FOR STORAGE
  String getSelectedVariantJson() {
    if (selectedVariant == null) return "";
    return jsonEncode(selectedVariant!.toJson());
  }
}