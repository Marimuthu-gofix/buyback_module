import 'package:flutter/material.dart';

import '../../../../shared/shimmer_effect/Select_shimmer_card.dart';

import 'model/model_variant_model.dart';
import 'services/model_storage_services.dart';

class ModelStorageSelection extends StatefulWidget {
  final String imageUrl;
  final int modelId;
  final String brandName;
  final int brandId;
  final String modelName;
  final int itemGroupId;

  /// ✅ PASS RAM + STORAGE + VARIANT
  final Function(String ram, String storage, String displayVariant)
  onStorageSelected;

  const ModelStorageSelection({
    super.key,
    required this.imageUrl,
    required this.modelId,
    required this.brandId,
    required this.brandName,
    required this.modelName,
    required this.itemGroupId,
    required this.onStorageSelected,
  });

  @override
  State<ModelStorageSelection> createState() => _ModelStorageSelectionState();
}

class _ModelStorageSelectionState extends State<ModelStorageSelection> {
  Future<ModelVariantModel>? _futureVariants;

  String selectedVariant = "";

  @override
  void initState() {
    super.initState();
    loadVariants();
  }

  Future<void> loadVariants() async {
    try {
      List<String> attributes = [];

      /// ✅ APPLE ONLY STORAGE
      if (widget.brandName.toLowerCase() == "apple") {
        attributes.add("Storage");
      } else {
        /// ✅ ANDROID RAM + STORAGE
        attributes.add("Ram");
        attributes.add("Storage");
      }

      setState(() {
        _futureVariants = ModelStorageService.getModelVariants(
          modelId: widget.modelId,
          attributes: attributes,
        );
      });
    } catch (e) {
      print("LOAD ERROR : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_futureVariants == null) {
      return const BrandShimmerBox();
    }

    return FutureBuilder<ModelVariantModel>(
      future: _futureVariants,

      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const BrandShimmerBox();
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              "Error : ${snapshot.error}",

              style: const TextStyle(color: Colors.white),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
          return const Center(
            child: Text(
              "No Variant Found",

              style: TextStyle(color: Colors.white),
            ),
          );
        }

        final variantList = snapshot.data!.data;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),

          child: Container(
            padding: const EdgeInsets.all(16),

            decoration: BoxDecoration(
              color: Colors.grey[900],

              borderRadius: BorderRadius.circular(16),

              border: Border.all(color: const Color(0xFFFF64E6)),
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                /// ✅ IMAGE
                Center(
                  child: Image.network(
                    widget.imageUrl,

                    height: 150,

                    fit: BoxFit.contain,

                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        "Images/logo.png",

                        height: 80,

                        fit: BoxFit.contain,
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Select your Storage Variant",

                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),

                const SizedBox(height: 16),

                /// ✅ GRID
                GridView.builder(
                  shrinkWrap: true,

                  physics: const NeverScrollableScrollPhysics(),

                  itemCount: variantList.length,

                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,

                    childAspectRatio: 3.5,

                    crossAxisSpacing: 10,

                    mainAxisSpacing: 10,
                  ),

                  itemBuilder: (context, index) {
                    final item = variantList[index];

                    /// ✅ DISPLAY TEXT
                    final String displayText =
                        widget.brandName.toLowerCase() == "apple"
                        ? item.storage
                        : "${item.ram} / ${item.storage}";

                    final bool isSelected = selectedVariant == item.variant;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedVariant = item.variant;
                        });

                        /// ✅ PASS RAM + STORAGE
                        widget.onStorageSelected(
                          item.ram,
                          item.storage,
                          displayText,
                        );

                        print("RAM : ${item.ram}");

                        print("STORAGE : ${item.storage}");
                      },

                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),

                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFFF64E6)
                              : Colors.white,

                          borderRadius: BorderRadius.circular(10),
                        ),

                        child: Row(
                          children: [
                            Container(
                              width: 18,
                              height: 18,

                              decoration: BoxDecoration(
                                shape: BoxShape.circle,

                                border: Border.all(color: Colors.grey),
                              ),
                            ),

                            const SizedBox(width: 8),

                            Expanded(
                              child: Text(
                                displayText,

                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black,

                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
