class Address {
  final int customerAddressId;
  final int customerId;
  final String addressName;
  final String houseAddress;
  final String areaAddress;
  final String pincode;
  final String city;
  final String stateName;
  final String otherInfo;
  final String locationDetails;
  final String latitude;
  final String longitude;
  final bool isDefaultAddress;
  final bool isActive;
  final String shipRocketAddressName;

  Address({
    required this.customerAddressId,
    required this.customerId,
    required this.addressName,
    required this.houseAddress,
    required this.areaAddress,
    required this.pincode,
    required this.city,
    required this.stateName,
    required this.otherInfo,
    required this.locationDetails,
    required this.latitude,
    required this.longitude,
    required this.isDefaultAddress,
    required this.isActive,
    required this.shipRocketAddressName,
  });

  Map<String, dynamic> toJson() => {
    "customerAddressId": customerAddressId,
    "customerId": customerId,
    "addressName": addressName,
    "houseAddress": houseAddress,
    "areaAddress": areaAddress,
    "pincode": pincode,
    "city": city,
    "stateName": stateName,
    "otherInfo": otherInfo,
    "locationDetails": locationDetails,
    "latitude": latitude,
    "longitude": longitude,
    "isDefaultAddress": isDefaultAddress,
    "isActive": isActive,
    "shipRocketAddressName": shipRocketAddressName,
  };
}

class Customer {
  final int customerId;
  final String customerName;
  final String phoneNo;
  final String alternatePhoneNo;
  final String emailAddress;
  final Address? address;
  final String ipAddress;

  Customer({
    required this.customerId,
    required this.customerName,
    required this.phoneNo,
    required this.alternatePhoneNo,
    required this.emailAddress,
     this.address,
    required this.ipAddress,
  });

  Map<String, dynamic> toJson() => {
    "customerId": customerId,
    "customerName": customerName,
    "phoneNo": phoneNo,
    "alternatePhoneNo": alternatePhoneNo,
    "emailAddress": emailAddress,
    if (address != null) "address": address!.toJson(),
    "ipAddress": ipAddress,
  };
}
