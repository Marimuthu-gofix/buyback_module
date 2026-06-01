import 'package:flutter/material.dart';

import '../../shared/Color/app_colors.dart';
import '../../shared/widgets/FaqSection.dart';

import '../evaluationpage/widgets/bottom_nav_button.dart';

import 'component/modelColorSection/modelColorSelection.dart';
import 'component/variantprice/variant_price.dart';

class Selectmodelcolor extends StatefulWidget {
  final String imageUrl;
  final int modelId;
  final String brandName;
  final int brandId;
  final String modelName;
  final int itemGroupId;

  /// ✅ RAM
  final String selectedRam;

  /// ✅ STORAGE
  final String selectedStorage;

  /// ✅ VARIANT DISPLAY
  final String displayVariant;

  const Selectmodelcolor({
    super.key,
    required this.imageUrl,
    required this.modelId,
    required this.brandId,
    required this.brandName,
    required this.modelName,
    required this.itemGroupId,

    /// ✅ RAM
    required this.selectedRam,

    /// ✅ STORAGE
    required this.selectedStorage,

    /// ✅ VARIANT
    required this.displayVariant,
  });

  @override
  State<Selectmodelcolor> createState() => _SelectmodelcolorState();
}

class _SelectmodelcolorState extends State<Selectmodelcolor> {
  /// ✅ SELECTED COLOR
  String? selectedColor;

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
          "Select Your Color",

          style: TextStyle(color: Colors.white),
        ),
      ),

      /// ✅ BODY
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// ✅ COLOR SECTION
            ModelColorSelection(
              imageUrl: widget.imageUrl,

              modelId: widget.modelId,

              brandId: widget.brandId,

              /// ✅ STORAGE
              selectedStorage: widget.selectedStorage,

              /// ✅ VARIANT DISPLAY
              displayVariant: widget.displayVariant,

              brandName: widget.brandName,

              modelName: widget.modelName,

              itemGroupId: widget.itemGroupId,

              /// ✅ STORAGE VALUE
              specValue: widget.selectedStorage,

              /// ✅ COLOR SELECT
              onColorSelected: (value) {
                setState(() {
                  selectedColor = value;
                });

                print("Selected Color : $value");

                print("Selected RAM : ${widget.selectedRam}");

                print("Selected Storage : ${widget.selectedStorage}");

                /// ✅ NEXT PAGE
                Navigator.push(
                  context,

                  MaterialPageRoute(
                    builder: (context) => VariantPriceScreen(
                      imageUrl: widget.imageUrl,

                      modelId: widget.modelId,

                      brandId: widget.brandId,

                      brandName: widget.brandName,

                      modelName: widget.modelName,

                      itemGroupId: widget.itemGroupId,

                      /// ✅ PASS RAM
                      ram: widget.selectedRam,

                      /// ✅ PASS STORAGE
                      storage: widget.selectedStorage,

                      /// ✅ PASS VARIANT
                      displayVariant: widget.displayVariant,

                      /// ✅ PASS COLOR
                      colour: value,
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

      /// ✅ BOTTOM BUTTON
      bottomNavigationBar: BottomNavButton(
        text: "Proceed",

        onTap: () {
          print("Button clicked");

          print("RAM : ${widget.selectedRam}");

          print("Storage : ${widget.selectedStorage}");

          print("Color : $selectedColor");
        },
      ),
    );
  }
}
