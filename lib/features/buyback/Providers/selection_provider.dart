import 'package:flutter/material.dart';

class SelectionProvider extends ChangeNotifier {
  int? brandId;
  String? brandName;
  int? itemGroupId;

  void setBrand({
    required int id,
    required String name,
    required int groupId,
  }) {
    brandId = id;
    brandName = name;
    itemGroupId = groupId;
    notifyListeners();
  }
}