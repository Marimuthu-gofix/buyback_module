import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../shared/shimmer_effect/Select_shimmer_card.dart';
import '../../../../shared/widgets/FaqSection.dart';
import '../modelColorSection/modelColorSelection.dart';
import 'model/model_storage_model.dart';
import 'services/model_storage_services.dart';

class ModelStorageSelection extends StatefulWidget {
  final String imageUrl;
  final int modelId;
  final String brandName;
  final int brandId;
  final String modelName;
  final int itemGroupId;
  final Function(String) onStorageSelected; // ✅ CORRECT PLACE

  const ModelStorageSelection({
    super.key,
    required this.imageUrl,
    required this.modelId,
    required this.brandId,
    required this.brandName,
    required this.modelName,
    required this.itemGroupId,
    required this.onStorageSelected, // ✅ ADD THIS
  });

  @override
  State<ModelStorageSelection> createState() =>
      _ModelStorageSelectionState();
}
class _ModelStorageSelectionState
    extends State<ModelStorageSelection> {
  late Future<ModelStorageModel> _futureStorage;

  final String attributeName = "Storage";

  @override
  void initState() {
    super.initState();

    _futureStorage = ModelStorageService.fetchStorage(
      widget.modelId,
      attributeName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ModelStorageModel>(
      future: _futureStorage,
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
              "No Storage Data Found",
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        final storageList = snapshot.data!.data;

        /// ✅ ONLY ONE SCROLL HERE
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

                /// 🔤 TITLE
                const Text(
                  "Select your Storage Variant",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),

                const SizedBox(height: 16),

                /// ✅ GRID
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: storageList.length,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3.5,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    final item = storageList[index];

                    return GestureDetector(
                      onTap: () {
                        widget.onStorageSelected(item.specValue);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
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
                                    color: Colors.grey),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                item.specValue,
                                style: const TextStyle(
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
        );
      },
    );
  }
}