import 'dart:convert';
import 'package:http/http.dart' as http;
import '../location_api.dart';
import '../model/location_tile_model.dart';

class GetLocationService {

  static const String apiUrl = LocationApi.baseUrl;
  static Future<List<Location>> fetchLocations() async {

    final locationResponse = await http.get(
      Uri.parse("$apiUrl/GetLocationList"),
    );

    final reviewResponse = await http.get(
      Uri.parse("$apiUrl/GetGoogleReviewStoreInfo"),
    );

    if (locationResponse.statusCode != 200 ||
        reviewResponse.statusCode != 200) {
      throw Exception("Failed to load store locations");
    }

    final locationJson = jsonDecode(locationResponse.body);
    final reviewJson = jsonDecode(reviewResponse.body);

    final List locations = locationJson['locations'];
    final List stores = reviewJson['stores'];

    List<Location> mergedList = [];

    for (var loc in locations) {

      final matchedStore = stores.firstWhere(
            (store) => store['locId'] == loc['locationID'],
        orElse: () => null,
      );

      mergedList.add(
        Location(
          locationID: loc['locationID'],
          locationName: loc['locationName'] ?? '',
          address: loc['address'] ?? '',
          stateName: loc['stateName'] ?? '',
          phoneNumber: loc['phoneNumber'] ?? '',
          location: loc['location'],
          latitude: loc['latitude'],
          longitude: loc['longitude'],

          averageRating: matchedStore != null
              ? (matchedStore['averageRating'] ?? 0).toDouble()
              : 0.0,

          totalReviewCount:
          matchedStore != null ? matchedStore['totalReviewCount'] ?? 0 : 0,

          mondayOpen: matchedStore?['mondayOpen'],
          mondayClose: matchedStore?['mondayClose'],
          tuesdayOpen: matchedStore?['tuesdayOpen'],
          tuesdayClose: matchedStore?['tuesdayClose'],
          wednesdayOpen: matchedStore?['wednesdayOpen'],
          wednesdayClose: matchedStore?['wednesdayClose'],
          thursdayOpen: matchedStore?['thursdayOpen'],
          thursdayClose: matchedStore?['thursdayClose'],
          fridayOpen: matchedStore?['fridayOpen'],
          fridayClose: matchedStore?['fridayClose'],
          saturdayOpen: matchedStore?['saturdayOpen'],
          saturdayClose: matchedStore?['saturdayClose'],
          sundayOpen: matchedStore?['sundayOpen'],
          sundayClose: matchedStore?['sundayClose'],
        ),
      );
    }

    return mergedList;
  }
}