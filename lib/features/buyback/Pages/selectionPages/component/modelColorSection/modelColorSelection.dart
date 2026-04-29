import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/shimmer_effect/Select_shimmer_card.dart';
import '../../../../shared/widgets/FaqSection.dart';
import 'model/model_color_model.dart';
import 'services/model_color_service.dart';

class ModelColorSelection extends StatefulWidget {
  final String imageUrl;
  final int modelId;
  final int brandId;
  final String selectedStorage;
  final String brandName;
  final String modelName;
  final int itemGroupId;
  final String specValue;

  final Function(String) onColorSelected; // ✅ CALLBACK

  const ModelColorSelection({
    super.key,
    required this.imageUrl,
    required this.modelId,
    required this.brandId,
    required this.selectedStorage,
    required this.brandName,
    required this.modelName,
    required this.itemGroupId,
    required this.specValue,
    required this.onColorSelected,
  });

  @override
  State<ModelColorSelection> createState() =>
      _ModelColorSelectionState();
}

class _ModelColorSelectionState extends State<ModelColorSelection> {
  late Future<ModelColorModel> _futureColors;

  final String attributeName = "Colour";
  String? selectedColor;

  @override
  void initState() {
    super.initState();
    _futureColors = ModelColorService.fetchStorage(
      widget.modelId,
      attributeName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ModelColorModel>(
      future: _futureColors,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const BrandShimmerBox();
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              "Error: ${snapshot.error}",
              style: const TextStyle(color: Colors.white),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
          return const Center(
            child: Text(
              "No Colors Found",
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        final colorList = snapshot.data!.data;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFFF64E6)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// 📱 IMAGE
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

                    /// TITLE
                    const Text(
                      "Select your color",
                      style:
                      TextStyle(color: Colors.white, fontSize: 16),
                    ),

                    const SizedBox(height: 16),

                    /// GRID
                    GridView.builder(
                      shrinkWrap: true,
                      physics:
                      const NeverScrollableScrollPhysics(),
                      itemCount: colorList.length,
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 3.5,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemBuilder: (context, index) {
                        final item = colorList[index];
                        final isSelected =
                            selectedColor == item.specValue;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedColor = item.specValue;
                            });

                            widget.onColorSelected(
                                item.specValue); // ✅ SEND UP
                          },
                          child: Container(
                            padding:
                            const EdgeInsets.symmetric(
                                horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                              BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 18,
                                  height: 18,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.grey,
                                    ),
                                    color:  Colors.transparent,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    item.specValue,
                                    style: TextStyle(
                                      color: Colors.black,
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

            ],
          ),
        );
      },
    );
  }
}