import 'package:flutter/material.dart';

import '../../shared/Color/app_colors.dart';

import '../../shared/widgets/DeviceSelectionProgress.dart';

import 'component/modelComponent/ModelSelectionSearch.dart';

class Selectmodels extends StatefulWidget {
  final int itemGroupId;
  final int brandId;
  final String brandName;
  const Selectmodels({
    super.key,
    required this.itemGroupId,
    required this.brandId,
    required this.brandName,
  });

  @override
  State<Selectmodels> createState() => _SelectmodelsState();
}

class _SelectmodelsState extends State<Selectmodels> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceDark,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Select Your Device",
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
              DeviceSelectionProgress(currentStep: 2, deviceType: "Mobiles"),
              SizedBox(height: 20),
              ModelSelectionSearch(
                brandId: widget.brandId,
                itemGroupId: widget.itemGroupId,
                brandName: widget.brandName,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
