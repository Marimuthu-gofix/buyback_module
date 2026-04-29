class Location {
  final int locationID;
  final String locationName;
  final String address;
  final String stateName;
  final String phoneNumber;
  final String? location;
  final String? latitude;
  final String? longitude;

  final double? averageRating;
  final int? totalReviewCount;

  final String? mondayOpen;
  final String? mondayClose;
  final String? tuesdayOpen;
  final String? tuesdayClose;
  final String? wednesdayOpen;
  final String? wednesdayClose;
  final String? thursdayOpen;
  final String? thursdayClose;
  final String? fridayOpen;
  final String? fridayClose;
  final String? saturdayOpen;
  final String? saturdayClose;
  final String? sundayOpen;
  final String? sundayClose;

  Location({
    required this.locationID,
    required this.locationName,
    required this.address,
    required this.stateName,
    required this.phoneNumber,
    this.location,
    this.latitude,
    this.longitude,
    this.averageRating,
    this.totalReviewCount,
    this.mondayOpen,
    this.mondayClose,
    this.tuesdayOpen,
    this.tuesdayClose,
    this.wednesdayOpen,
    this.wednesdayClose,
    this.thursdayOpen,
    this.thursdayClose,
    this.fridayOpen,
    this.fridayClose,
    this.saturdayOpen,
    this.saturdayClose,
    this.sundayOpen,
    this.sundayClose,
  });
}