import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'package:hugeicons/hugeicons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import '../../color/app_colors.dart';
import '../../shimmer_effect/store_card_shimmer.dart';
import 'model/location_model.dart';
import 'services/get_location_service.dart';

class LocationSection extends StatefulWidget {
  const LocationSection({super.key});

  @override
  State<LocationSection> createState() => _LocationSectionState();
}

class _LocationSectionState extends State<LocationSection>
    with WidgetsBindingObserver {
  late Future<LocationModel?> _futureLocations;
  Future<Position?>? _locationFuture;

  String _searchQuery = '';
  Timer? _debounce;

  bool _hasLocationPermission = false;
  double? _userLat;
  double? _userLng;


  /// INIT
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _futureLocations = GetLocationService.fetchLocations();
    _requestPermissionOnce();
    _locationFuture = _getCurrentPosition();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _debounce?.cancel();
    super.dispose();
  }


  /// APP RESUME HANDLER
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {
        _locationFuture = _getCurrentPosition();
      });
    }
  }


  /// Request permission ONCE

  Future<void> _requestPermissionOnce() async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
      if (mounted) {
        setState(() {
          _locationFuture = _getCurrentPosition();
        });
      }
    }
  }


  /// Safe location fetch

  Future<Position?> _getCurrentPosition() async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }


  /// Distance Calculator (KM)

  double _distanceInKm(
      double startLat,
      double startLng,
      double endLat,
      double endLng,
      ) {
    return Geolocator.distanceBetween(startLat, startLng, endLat, endLng) /
        1000;
  }

  String _formatDistance(double km) {
    if (km < 1) {
      return "${(km * 1000).toStringAsFixed(0)} m away";
    }
    return "${km.toStringAsFixed(1)} km away";
  }

  /// Search (Debounced)

  void _onSearchChanged(String v) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() => _searchQuery = v.trim());
    });
  }


  /// URL Launcher

  void _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint("Could not launch $url");
    }
  }


  /// Load Store Image
  Future<String> _getImage(String locationName) async {
    final slug =
    locationName.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
    final assetPath = "Images/store-locator/$slug.jpg";
    try {
      await rootBundle.load(assetPath);
      return assetPath;
    } catch (_) {
      return "Images/store-locator/default.png";
    }
  }

  /// Store Card
  Widget _buildStoreCard(
      Location loc, {
        bool isNearest = false,
        double? distanceKm,
      }) {
    final screenWidth = 1.sw;
    final cardWidth = (screenWidth * 0.70).clamp(220.0, 300.0);

    final imageHeight = (cardWidth * 0.50).clamp(110.0, 150.0);

    return FutureBuilder<String>(
      future: _getImage(loc.locationName),
      builder: (context, imgSnap) {
        final img = imgSnap.data ?? "Images/store-locator/default.png";

        return Container(
          width: cardWidth,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: const Color(0xFFFF64E6),
              width: isNearest ? 2.5.w : 1.5.w,
            ),
          ),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Store Image
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.r),
                      topRight: Radius.circular(16.r),
                    ),
                    child: Image.asset(
                      img,
                      height: imageHeight,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                  /// Card Content
                  Padding(
                    padding: EdgeInsets.all(10.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Store Name
                        Text(
                          loc.locationName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 3.h),

                        /// Address
                        Text(
                          "${loc.address}, ${loc.stateName}",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 11.sp,
                          ),
                        ),
                        SizedBox(height: 6.h),

                        /// Timings
                        Text(
                          "Timings: 10:30 AM – 09:30 PM",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        /// Distance
                        if (distanceKm != null) ...[
                          SizedBox(height: 4.h),
                          Row(
                            children: [
                              HugeIcon(
                                icon: HugeIcons.strokeRoundedRoute02,
                                size: 14.sp,
                                color: Colors.green,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                _formatDistance(distanceKm),
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                        SizedBox(height: 10.h),

                        /// Action Buttons
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () =>
                                    _launchUrl("tel:${loc.phoneNumber}"),
                                icon: Icon(
                                  Icons.phone,
                                  color: Colors.white,
                                  size: 13.sp,
                                ),
                                label: Text(
                                  "Call",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.sp,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 6.h,
                                    horizontal: 4.w,
                                  ),
                                  side: BorderSide(color: AppColors.primary),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: loc.location != null
                                    ? () => _launchUrl(loc.location!)
                                    : null,
                                icon: HugeIcon(
                                  icon: HugeIcons.strokeRoundedLocation04,
                                  size: 13.sp,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  "Directions",
                                  style: TextStyle(fontSize: 10.sp),
                                ),
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 6.h,
                                    horizontal: 4.w,
                                  ),
                                  backgroundColor: const Color(0xFFFF64E6),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              /// Nearest Badge
              if (isNearest)
                Positioned(
                  top: 8.h,
                  right: 8.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      "Nearest Store",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 9.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }


  /// UI Builder
  Widget _buildUI(List<Location> filtered) {
    final listHeight = (0.38.sh).clamp(300.0, 420.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Header Row
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Our Stores",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // GestureDetector(
              //   onTap: () => Navigator.push(
              //     context,
              //     MaterialPageRoute(builder: (_) => Placeholder()),
              //   ),
              //   child: Text(
              //     "See all",
              //     style: TextStyle(
              //       color: const Color(0xFFFF64E6),
              //       fontSize: 12.sp,
              //       fontWeight: FontWeight.w500,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),

        /// Search Bar
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: TextField(
            onChanged: _onSearchChanged,
            cursorColor: AppColors.primary,
            style: TextStyle(fontSize: 13.sp),
            decoration: InputDecoration(
              hintText: "Search location",
              hintStyle: TextStyle(fontSize: 13.sp),
              filled: true,
              fillColor: Colors.white,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                vertical: 10.h,
                horizontal: 12.w,
              ),
              prefixIcon: Icon(
                Icons.search,
                size: 18.sp,
                color: Colors.black87,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        SizedBox(height: 14.h),

        // ── Horizontal Card List ──
        SizedBox(
          height: listHeight,
          child: filtered.isEmpty
              ? Center(
            child: Text(
              "No stores found",
              style: TextStyle(color: Colors.white70, fontSize: 13.sp),
            ),
          )
              : ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            itemCount: filtered.length,
            itemBuilder: (_, i) {
              final loc = filtered[i];
              double? distanceKm;

              if (_userLat != null &&
                  _userLng != null &&
                  loc.latitude != null &&
                  loc.longitude != null) {
                final lat = double.tryParse(loc.latitude!);
                final lng = double.tryParse(loc.longitude!);
                if (lat != null && lng != null) {
                  distanceKm = _distanceInKm(
                    _userLat!,
                    _userLng!,
                    lat,
                    lng,
                  );
                }
              }

              return _buildStoreCard(
                loc,
                isNearest: _hasLocationPermission && i == 0,
                distanceKm: distanceKm,
              );
            },
            separatorBuilder: (_, __) => SizedBox(width: 12.w),
          ),
        ),
      ],
    );
  }

  /// MAIN BUILD
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LocationModel?>(
      future: _futureLocations,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 60.h),
            child: const StoreCardShimmer(),
          );
        }

        if (!snap.hasData || snap.data!.locations.isEmpty) {
          return Center(
            child: Text(
              "No store locations found",
              style: TextStyle(color: Colors.white70, fontSize: 13.sp),
            ),
          );
        }

        final locations = List<Location>.from(snap.data!.locations);

        return FutureBuilder<Position?>(
          future: _locationFuture,
          builder: (context, posSnap) {
            _hasLocationPermission =
                posSnap.hasData && posSnap.data != null;

            if (_hasLocationPermission) {
              _userLat = posSnap.data!.latitude;
              _userLng = posSnap.data!.longitude;

              locations.sort((a, b) {
                double getDistance(Location loc) {
                  if (_userLat == null ||
                      _userLng == null ||
                      loc.latitude == null ||
                      loc.longitude == null) {
                    return double.infinity;
                  }
                  final lat = double.tryParse(loc.latitude!);
                  final lng = double.tryParse(loc.longitude!);
                  if (lat == null || lng == null) return double.infinity;
                  return _distanceInKm(_userLat!, _userLng!, lat, lng);
                }

                return getDistance(a).compareTo(getDistance(b));
              });
            } else {
              _userLat = null;
              _userLng = null;
            }

            final filtered = locations
                .where((e) => e.locationName
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()))
                .toList();

            return _buildUI(filtered);
          },
        );
      },
    );
  }
}