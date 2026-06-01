import 'dart:convert';

class ModelVariantModel {
  final bool success;
  final int count;
  final List<VariantData> data;

  ModelVariantModel({
    required this.success,
    required this.count,
    required this.data,
  });

  factory ModelVariantModel.fromRawJson(String str) =>
      ModelVariantModel.fromJson(json.decode(str));

  factory ModelVariantModel.fromJson(Map<String, dynamic> json) {
    return ModelVariantModel(
      success: json["success"] ?? false,
      count: json["count"] ?? 0,
      data: json["data"] == null
          ? []
          : List<VariantData>.from(
              json["data"].map((x) => VariantData.fromJson(x)),
            ),
    );
  }
}

class VariantData {
  final String ram;
  final String storage;
  final String variant;

  VariantData({
    required this.ram,
    required this.storage,
    required this.variant,
  });

  factory VariantData.fromJson(Map<String, dynamic> json) {
    return VariantData(
      ram: json["ram"]?.toString() ?? "",
      storage: json["storage"]?.toString() ?? "",
      variant: json["variant"]?.toString() ?? "",
    );
  }
}
