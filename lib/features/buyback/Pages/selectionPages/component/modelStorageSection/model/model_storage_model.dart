import 'dart:convert';

class GetModelAttributeModel {
  final bool success;
  final int count;
  final List<AttributeData> data;

  GetModelAttributeModel({
    required this.success,
    required this.count,
    required this.data,
  });

  factory GetModelAttributeModel.fromRawJson(String str) =>
      GetModelAttributeModel.fromJson(json.decode(str));

  factory GetModelAttributeModel.fromJson(Map<String, dynamic> json) {
    return GetModelAttributeModel(
      success: json["success"] ?? false,
      count: json["count"] ?? 0,
      data: json["data"] == null
          ? []
          : List<AttributeData>.from(
              json["data"].map((x) => AttributeData.fromJson(x)),
            ),
    );
  }
}

class AttributeData {
  final String spec;

  AttributeData({required this.spec});

  factory AttributeData.fromJson(Map<String, dynamic> json) {
    return AttributeData(spec: json["spec"]?.toString() ?? "");
  }
}
