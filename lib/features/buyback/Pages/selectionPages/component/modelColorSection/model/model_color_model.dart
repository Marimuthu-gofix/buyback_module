import 'package:meta/meta.dart';
import 'dart:convert';

class ModelColorModel {
  final bool success;
  final int count;
  final List<Datum> data;

  ModelColorModel({
    required this.success,
    required this.count,
    required this.data,
  });

  ModelColorModel copyWith({bool? success, int? count, List<Datum>? data}) =>
      ModelColorModel(
        success: success ?? this.success,
        count: count ?? this.count,
        data: data ?? this.data,
      );

  factory ModelColorModel.fromRawJson(String str) =>
      ModelColorModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelColorModel.fromJson(Map<String, dynamic> json) =>
      ModelColorModel(
        success: json["success"],
        count: json["count"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "count": count,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  final String specValue;

  Datum({required this.specValue});

  Datum copyWith({String? specValue}) =>
      Datum(specValue: specValue ?? this.specValue);

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) =>
      Datum(specValue: json["spec_value"]);

  Map<String, dynamic> toJson() => {"spec_value": specValue};
}
