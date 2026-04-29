import 'package:buyback_module/features/buyback/Pages/selectionPages/utils/device_name.dart';
import 'package:flutter/material.dart';
import '../../shared/Color/app_colors.dart';
import '../../shared/widgets/DeviceSelectionProgress.dart';
import 'component/brandSection/brandSearchSection.dart';

class Selectbrands extends StatefulWidget {
  final int itemGroupId;

  const Selectbrands({
    super.key,
    required this.itemGroupId,
  });

  @override
  State<Selectbrands> createState() => _SelectbrandsState();
}

class _SelectbrandsState extends State<Selectbrands> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceDark,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Select Your Brand",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DeviceSelectionProgress(
                currentStep: 1,
                deviceType: DeviceName.getDeviceName(widget.itemGroupId),
              ),
              SizedBox(height: 20),
              BrandSelectionSearch(
                itemGroupId: widget.itemGroupId,
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
