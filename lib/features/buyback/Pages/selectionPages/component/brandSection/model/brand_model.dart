// import 'dart:convert';
//
// class BrandList {
//   final bool success;
//   final int count;
//   final List<BrandData> data;
//
//   BrandList({required this.success, required this.count, required this.data});
//
//   factory BrandList.fromJson(Map<String, dynamic> json) => BrandList(
//     success: json["success"] ?? false,
//     count: json["count"] ?? 0,
//     data: json["data"] == null
//         ? []
//         : List<BrandData>.from(json["data"].map((x) => BrandData.fromJson(x))),
//   );
// }
//
// class BrandData {
//   final int brandId;
//   final String brand;
//
//   BrandData({required this.brandId, required this.brand});
//
//   factory BrandData.fromJson(Map<String, dynamic> json) =>
//       BrandData(brandId: json["brand_id"] ?? 0, brand: json["brand"] ?? "");
// }

class BrandList {
  final bool success;
  final int count;
  final List<BrandData> data;

  BrandList({
    required this.success,
    required this.count,
    required this.data,
  });

  factory BrandList.fromJson(Map<String, dynamic> json) => BrandList(
    success: json["success"] ?? false,
    count: json["count"] ?? 0,
    data: json["data"] == null
        ? []
        : List<BrandData>.from(
      json["data"].map((x) => BrandData.fromJson(x)),
    ),
  );
}

class BrandData {
  final int brandId;
  final String brand;

  BrandData({
    required this.brandId,
    required this.brand,
  });

  factory BrandData.fromJson(Map<String, dynamic> json) => BrandData(
    brandId: json["brand_id"] ?? 0,
    brand: json["brand"] ?? "",
  );
}