class DeviceVariant {
  final String itemCode;
  final String itemName;
  final String brand;
  final String category;
  final String subCategory;
  final String model;
  final String modelName;
  final String ram;
  final String storage;
  final String color;

  DeviceVariant({
    required this.itemCode,
    required this.itemName,
    required this.brand,
    required this.category,
    required this.subCategory,
    required this.model,
    required this.modelName,
    required this.ram,
    required this.storage,
    required this.color,
  });

  factory DeviceVariant.fromJson(Map<String, dynamic> json) {
    return DeviceVariant(
      itemCode: json['item_code'] ?? "",
      itemName: json['item_name'] ?? "",
      brand: json['brand'] ?? "",
      category: json['ch_category'] ?? "",
      subCategory: json['ch_sub_category'] ?? "",
      model: json['ch_model'] ?? "",
      modelName: json['model_name'] ?? "",
      ram: json['ram'] ?? "",
      storage: json['storage'] ?? "",
      color: json['color'] ?? "",
    );

  }
  Map<String, dynamic> toJson() {
    return {
      "item_code": itemCode,
      "item_name": itemName,
      "brand": brand,
      "ch_category": category,
      "ch_sub_category": subCategory,
      "ch_model": model,
      "model_name": modelName,
      "ram": ram,
      "storage": storage,
      "color": color,
    };
  }
}