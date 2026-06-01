import 'dart:convert';

class ModelColorModel {
  final bool success;
  final String message;
  final List<ColorData> data;

  ModelColorModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ModelColorModel.fromRawJson(String str) =>
      ModelColorModel.fromJson(json.decode(str));

  factory ModelColorModel.fromJson(Map<String, dynamic> json) {
    return ModelColorModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",

      data: json["data"] == null
          ? []
          : List<ColorData>.from(
              json["data"].map((x) => ColorData.fromJson(x)),
            ),
    );
  }
}

class ColorData {
  final String color;

  ColorData({required this.color});

  factory ColorData.fromJson(Map<String, dynamic> json) {
    return ColorData(color: json["color"]?.toString() ?? "");
  }
}
