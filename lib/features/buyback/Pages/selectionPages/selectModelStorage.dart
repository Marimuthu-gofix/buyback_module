import 'package:buyback_module/features/buyback/Pages/selectionPages/selectModelColor.dart';
import 'package:flutter/material.dart';
import '../../shared/Color/app_colors.dart';
import '../../shared/widgets/FaqSection.dart';
import '../evaluationpage/widgets/bottom_nav_button.dart';
import 'component/modelColorSection/modelColorSelection.dart';
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
  String? selectedStorage; // ✅ CORRECT
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceDark,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white),
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

      /// ✅ NO SCROLL HERE
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// 🔥 MAIN CONTENT
            ModelStorageSelection(
              imageUrl: widget.imageUrl,
              modelId: widget.modelId,
              brandId: widget.brandId,
              brandName: widget.brandName,
              modelName: widget.modelName,
              itemGroupId: widget.itemGroupId,

              /// ✅ IMPORTANT
              onStorageSelected: (value) {
                setState(() {
                  selectedStorage = value;
                });

                print("Selected Storage: $value");

                /// ✅ Navigate from parent
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
                      selectedStorage: value, // ✅ PASS STORAGE HERE
                    ),
                  ),
                );              },
            ),

            /// 📌 FAQ SECTION
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