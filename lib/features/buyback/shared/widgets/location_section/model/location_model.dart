import 'dart:convert';

LocationModel locationModelFromJson(String str) =>
    LocationModel.fromJson(json.decode(str));

class LocationModel {
  final List<Location> locations;
  final bool status;
  final String? message;
  final List<dynamic>? errors;

  LocationModel({
    required this.locations,
    required this.status,
    this.message,
    this.errors,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      locations: json["locations"] == null
          ? []
          : List<Location>.from(
          json["locations"].map((x) => Location.fromJson(x))),
      status: json["status"] ?? false,
      message: json["message"],
      errors: json["errors"],
    );
  }
}

class Location {
  final int locationID;
  final String locationName;
  final int stateID;
  final String stateName;
  final String address;
  final String phoneNumber;
  final String emailAddress;

  final String? location;
  final String? latitude;
  final String? longitude;

  Location({
    required this.locationID,
    required this.locationName,
    required this.stateID,
    required this.stateName,
    required this.address,
    required this.phoneNumber,
    required this.emailAddress,
    this.location,
    this.latitude,
    this.longitude,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      locationID: json["locationID"] ?? 0,
      locationName: json["locationName"] ?? "",
      stateID: json["stateID"] ?? 0,
      stateName: json["stateName"] ?? "",
      address: json["address"] ?? "",
      phoneNumber: json["phoneNumber"] ?? "",
      emailAddress: json["emailAddress"] ?? "",
      location: json["location"],
      latitude: json["latitude"],
      longitude: json["longitude"],
    );
  }
}
