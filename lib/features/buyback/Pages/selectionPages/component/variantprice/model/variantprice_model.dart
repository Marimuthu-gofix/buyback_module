import 'dart:convert';

class GetItemsModel {
  final bool success;
  final int count;
  final List<ItemData> data;

  GetItemsModel({
    required this.success,
    required this.count,
    required this.data,
  });

  factory GetItemsModel.fromRawJson(String str) =>
      GetItemsModel.fromJson(json.decode(str));

  factory GetItemsModel.fromJson(Map<String, dynamic> json) => GetItemsModel(
    success: json["success"] ?? false,
    count: json["count"] ?? 0,
    data: json["data"] == null
        ? []
        : List<ItemData>.from(json["data"].map((x) => ItemData.fromJson(x))),
  );
}

class ItemData {
  final String itemCode;
  final String name;

  ItemData({
    required this.itemCode,
    required this.name,
  });

  factory ItemData.fromJson(Map<String, dynamic> json) => ItemData(
    itemCode: json["item_code"] ?? "",
    name: json["item_name"] ?? "",
  );
}

class BuybackPriceModel {
  final bool success;
  final int count;
  final List<BuybackData> data;

  BuybackPriceModel({
    required this.success,
    required this.count,
    required this.data,
  });

  factory BuybackPriceModel.fromJson(Map<String, dynamic> json) {
    return BuybackPriceModel(
      success: json["success"] ?? false,
      count: json["count"] ?? 0,
      data: json["data"] == null
          ? []
          : List<BuybackData>.from(
          json["data"].map((x) => BuybackData.fromJson(x))),
    );
  }
}

class BuybackData {
  final double currentMarketPrice;

  BuybackData({required this.currentMarketPrice});

  factory BuybackData.fromJson(Map<String, dynamic> json) {
    return BuybackData(
      currentMarketPrice:
      (json["current_market_price"] ?? 0).toDouble(),
    );
  }
}