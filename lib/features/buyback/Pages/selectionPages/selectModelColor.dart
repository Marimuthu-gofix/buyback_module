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
  final String selectedStorage; // ✅ MUST come from previous page

  const Selectmodelcolor({
    super.key,
    required this.imageUrl,
    required this.modelId,
    required this.brandId,
    required this.brandName,
    required this.modelName,
    required this.itemGroupId,
    required this.selectedStorage,
  });

  @override
  State<Selectmodelcolor> createState() => _SelectmodelcolorState();
}

class _SelectmodelcolorState extends State<Selectmodelcolor> {
  String? selectedColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceDark,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Select Your Color",
          style: TextStyle(color: Colors.white),
        ),
      ),

      /// ✅ NO SCROLL HERE
      body: SingleChildScrollView(
        child: Column(
          children: [
            ModelColorSelection(
              imageUrl: widget.imageUrl,
              modelId: widget.modelId,
              brandId: widget.brandId,
              selectedStorage: widget.selectedStorage,
              brandName: widget.brandName,
              modelName: widget.modelName,
              itemGroupId: widget.itemGroupId,
              specValue: widget.selectedStorage,

              /// ✅ CALLBACK
              onColorSelected: (value) {
                setState(() {
                  selectedColor = value;
                });

                print("Selected Color: $value");

                /// ✅ NAVIGATION HERE ONLY
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
                      storage: widget.selectedStorage,
                      colour: value,
                    ),
                  ),
                );
              },
            ),
            const FaqSection(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavButton(
        text: "Proceed",
        onTap: () {
          print("Button clicked");

          // Example navigation (uncomment when needed)
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => const NextPage(),
          //   ),
          // );
        },
      ),

    );
  }
}