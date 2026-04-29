import 'package:buyback_module/features/buyback/Pages/selectionPages/component/brandSection/brandSelection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../shared/Color/app_colors.dart';
import '../shared/widgets/PromoCarousel.dart';
import '../shared/widgets/WhyUsSection.dart';
import '../shared/widgets/location_section/location_section.dart';
import 'package:buyback_module/buyback_module.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceDark,
      appBar: AppBar(toolbarHeight: 60.h, backgroundColor: Colors.black,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BuybackModule(
                    config: BuybackConfig(appName: "Gofix"),
                  ),
                ),
              );
            },
            child: Text(
              "Buyback",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
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
              BrandSelectionSection(itemGroupId: 1,),
              WhyUsSection(),
              LocationSection(),
            ],
          ),
        ),
      ),
    );
  }
}
