import 'dart:convert';

class ModelStorageModel {
  final bool success;
  final int count;
  final List<Datum> data;

  ModelStorageModel({
    required this.success,
    required this.count,
    required this.data,
  });

  factory ModelStorageModel.fromRawJson(String str) =>
      ModelStorageModel.fromJson(json.decode(str));

  factory ModelStorageModel.fromJson(Map<String, dynamic> json) {
    return ModelStorageModel(
      success: json["success"] ?? false,
      count: json["count"] ?? 0,
      data: json["data"] == null
          ? []
          : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );
  }
}

class Datum {
  final String specValue;

  Datum({required this.specValue});

  factory Datum.fromJson(Map<String, dynamic> json) {
    return Datum(specValue: json["spec_value"]?.toString() ?? "");
  }
}
