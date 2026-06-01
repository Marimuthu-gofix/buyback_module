import 'package:buyback_module/features/buyback/Pages/selectionPages/selectModelColor.dart';
import 'package:flutter/material.dart';
import '../../shared/Color/app_colors.dart';
import '../../shared/widgets/FaqSection.dart';
import '../evaluationpage/widgets/bottom_nav_button.dart';
import 'component/modelStorageSection/modelStorageSelection.dart';

class Selectmodelstorage extends StatefulWidget {
  final String imageUrl;
  final int modelId;
  final String brandName;
  final int brandId;
  final String modelName;
  final int itemGroupId;

  const Selectmodelstorage({
    super.key,
    required this.imageUrl,
    required this.modelId,
    required this.brandId,
    required this.brandName,
    required this.modelName,
    required this.itemGroupId,
  });

  @override
  State<Selectmodelstorage> createState() => _SelectmodelstorageState();
}

class _SelectmodelstorageState extends State<Selectmodelstorage> {
  /// ✅ RAM
  String? selectedRam;

  /// ✅ STORAGE
  String? selectedStorage;

  /// ✅ VARIANT
  String? displayVariant;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceDark,

      appBar: AppBar(
        backgroundColor: Colors.black,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),

          onPressed: () => Navigator.pop(context),
        ),

        title: const Text(
          "Select Your Storage",

          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            /// ✅ STORAGE SECTION
            ModelStorageSelection(
              imageUrl: widget.imageUrl,
              modelId: widget.modelId,
              brandId: widget.brandId,
              brandName: widget.brandName,
              modelName: widget.modelName,
              itemGroupId: widget.itemGroupId,

              /// ✅ GET RAM + STORAGE
              onStorageSelected: (ram, storage, variant) {
                setState(() {
                  selectedRam = ram;

                  selectedStorage = storage;

                  displayVariant = variant;
                });

                print("Selected RAM : $ram");

                print("Selected Storage : $storage");

                print("Display Variant : $variant");

                /// ✅ NAVIGATION
                Navigator.push(
                  context,

                  MaterialPageRoute(
                    builder: (context) => Selectmodelcolor(
                      imageUrl: widget.imageUrl,

                      modelId: widget.modelId,

                      brandId: widget.brandId,

                      brandName: widget.brandName,

                      modelName: widget.modelName,

                      itemGroupId: widget.itemGroupId,

                      /// ✅ DIRECT VALUE
                      selectedRam: ram,

                      /// ✅ DIRECT VALUE
                      selectedStorage: storage,

                      /// ✅ DIRECT VALUE
                      displayVariant: variant,
                    ),
                  ),
                );
              },
            ),

            /// ✅ FAQ
            const FaqSection(),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavButton(
        text: "Proceed",

        onTap: () {
          print("Button Clicked");

          print("RAM : $selectedRam");

          print("Storage : $selectedStorage");
        },
      ),
    );
  }
}
