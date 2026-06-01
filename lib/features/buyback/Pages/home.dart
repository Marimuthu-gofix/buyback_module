import 'package:buyback_module/features/buyback/Pages/selectionPages/component/brandSection/brandSelection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../shared/Color/app_colors.dart';
import '../shared/widgets/PromoCarousel.dart';
import '../shared/widgets/WhyUsSection.dart';
import '../shared/widgets/location_section/location_section.dart';
import 'diagnosepage/permission_screen.dart';
import 'diagnosepage/widgets/initiatediagostics.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  String imei1 = '';

  @override
  void initState() {
    super.initState();
    _loadImei();
  }

  Future<void> _loadImei() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      imei1 = prefs.getString('imei1') ?? '';
    });

    debugPrint('IMEI1: $imei1');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceDark,
      appBar: AppBar(
        toolbarHeight: 60.h,
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.build, color: Colors.grey),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => imei1.isNotEmpty
                      ? const InitiateDiagostics()
                      : const PermissionScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsetsGeometry.all(10),
            child: Column(
              spacing: 15,
              children: [
                PromoCarousel(),
                Text(
                  "GoFix - Your Trusted Spot to \n Sell or Repair  Phones!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                BrandSelectionSection(itemGroupId: 1),
                WhyUsSection(),
                LocationSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
