// import 'package:meta/meta.dart';
// import 'dart:convert';
//
// class Modellist {
//   final bool success;
//   final int count;
//   final List<Datum> data;
//
//   Modellist({required this.success, required this.count, required this.data});
//
//   factory Modellist.fromRawJson(String str) =>
//       Modellist.fromJson(json.decode(str));
//
//   String toRawJson() => json.encode(toJson());
//
//   factory Modellist.fromJson(Map<String, dynamic> json) => Modellist(
//     success: json["success"],
//     count: json["count"],
//     data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "success": success,
//     "count": count,
//     "data": List<dynamic>.from(data.map((x) => x.toJson())),
//   };
// }
//
// class Datum {
//   final String name;
//   final int modelId;
//   final String modelName;
//   final int brandId;
//
//   Datum({
//     required this.name,
//     required this.modelId,
//     required this.modelName,
//     required this.brandId,
//   });
//
//   factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));
//
//   String toRawJson() => json.encode(toJson());
//
//   factory Datum.fromJson(Map<String, dynamic> json) => Datum(
//     name: json["name"],
//     modelId: json["model_id"],
//     modelName: json["model_name"],
//     brandId: json["brand_id"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "name": name,
//     "model_id": modelId,
//     "model_name": modelName,
//     "brand_id": brandId,
//   };
// }
import 'dart:convert';

class Modellist {
  final bool success;
  final int count;
  final List<Datum> data;

  Modellist({
    required this.success,
    required this.count,
    required this.data,
  });

  factory Modellist.fromJson(Map<String, dynamic> json) => Modellist(
    success: json["success"] ?? false,
    count: json["count"] ?? 0,
    data: json["data"] == null
        ? []
        : List<Datum>.from(
      json["data"].map((x) => Datum.fromJson(x)),
    ),
  );
}

class Datum {
  final String name;
  final int modelId;
  final String modelName;
  final int brandId;

  Datum({
    required this.name,
    required this.modelId,
    required this.modelName,
    required this.brandId,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    name: json["name"] ?? "",
    modelId: json["model_id"] ?? 0,
    modelName: json["model_name"] ?? "",
    brandId: json["brand_id"] ?? 0,
  );
}