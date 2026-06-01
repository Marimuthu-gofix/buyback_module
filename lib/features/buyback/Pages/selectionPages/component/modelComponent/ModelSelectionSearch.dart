import 'package:flutter/material.dart';
import '../../../../shared/shimmer_effect/brand_shimmer_card.dart';
import '../../selectModelStorage.dart';
import 'model/model_model.dart';
import 'services/get_model_service.dart';

class ModelSelectionSearch extends StatefulWidget {
  final int brandId;
  final String brandName;
  final int itemGroupId;

  const ModelSelectionSearch({
    super.key,
    required this.brandId,
    required this.brandName,
    required this.itemGroupId,
  });

  @override
  State<ModelSelectionSearch> createState() => _ModelSelectionSearchState();
}

class _ModelSelectionSearchState extends State<ModelSelectionSearch> {
  late Future<Modellist?> _futureModels;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _futureModels = GetModelService.fetchModels(
      widget.brandId,
      widget.itemGroupId,
    );
  }

  /// ✅ Clean filename for image URL
  String formatFileName(String name) {
    return name
        .toLowerCase()
        .replaceAll(" ", "-")
        .replaceAll("(", "")
        .replaceAll(")", "")
        .replaceAll(".", "")
        .replaceAll("/", "")
        .replaceAll("__", "_");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// 🔹 Header + Search
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Select your Model",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),

            SizedBox(
              width: 160,
              height: 40,
              child: TextField(
                style: const TextStyle(color: Colors.white),
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  hintText: 'Search Model',
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.grey.shade800,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  setState(() => _searchQuery = value);
                },
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        /// 🔹 API Data
        FutureBuilder<Modellist?>(
          future: _futureModels,
          builder: (context, snapshot) {
            /// 🔄 Loading
            if (snapshot.connectionState == ConnectionState.waiting) {
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 9,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                ),
                itemBuilder: (_, __) => const BrandShimmerCard(),
              );
            }

            /// ❌ Error
            if (snapshot.hasError || snapshot.data == null) {
              return const Center(
                child: Text(
                  "Failed to load models",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            final allModels = snapshot.data!.data;

            /// ❌ Empty
            if (allModels.isEmpty) {
              return const Center(
                child: Text(
                  "No Models Found",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            /// 🔍 Filter
            final models = allModels
                .where(
                  (m) => m.modelName.toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  ),
                )
                .toList();

            /// ❌ No search result
            if (models.isEmpty) {
              return const Center(
                child: Text(
                  "No matching models",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            /// ✅ Grid UI
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: models.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 0.8,
              ),
              itemBuilder: (context, index) {
                final model = models[index];

                final fileName = formatFileName(model.modelName);

                final imageUrl =
                    "https://gofix.co.in/assets/device-img/$fileName.png";

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Selectmodelstorage(
                          brandId: widget.brandId,
                          imageUrl: imageUrl,
                          modelId: model.modelId,
                          brandName: widget.brandName,
                          modelName: model.modelName,
                          itemGroupId: widget.itemGroupId,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEEEEE),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFFF64E6),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          imageUrl,
                          height: 50,
                          errorBuilder: (_, __, ___) => const Icon(Icons.image),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          model.modelName,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
