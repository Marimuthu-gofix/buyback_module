class SellNowModel {
  final String name;

  SellNowModel({required this.name});

  Map<String, dynamic> toJson() {
    return {"name": name};
  }
}
