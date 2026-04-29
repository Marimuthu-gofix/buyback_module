import 'package:flutter/material.dart';
import '../../../../shared/Color/app_colors.dart';
import '../../../../shared/shimmer_effect/brand_shimmer_card.dart';
import 'model/brand_model.dart';
import 'services/get_brand_service.dart';
import '../../selectModel.dart';

class BrandSelectionSearch extends StatefulWidget {
  final int itemGroupId;

  const BrandSelectionSearch({
    super.key,
    required this.itemGroupId,
  });

  @override
  State<BrandSelectionSearch> createState() => _BrandSelectionSearchState();
}

class _BrandSelectionSearchState extends State<BrandSelectionSearch> {
  late Future<BrandList?> _futureBrands;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();

    _futureBrands = GetBrandService.fetchBrands(
      widget.itemGroupId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surfaceDark,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔍 TITLE + SEARCH
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Select your Brand",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 160,
                height: 40,
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  textAlignVertical: TextAlignVertical.center, // ✅ center vertically
                  decoration: InputDecoration(
                    hintText: 'Search Brand',
                    hintStyle: const TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: AppColors.surface,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12), // 👈 important
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

          const SizedBox(height: 15),

          /// 🔥 GRID AREA (FIXED OVERFLOW)
          FutureBuilder<BrandList?>(
            future: _futureBrands,
            builder: (context, snapshot) {
              // 🔄 Loading
              if (snapshot.connectionState == ConnectionState.waiting) {
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 9,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 1.0,
                  ),
                  itemBuilder: (context, index) {
                    return const BrandShimmerCard();
                  },
                );
              }

              if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    'Failed to load brands',
                    style: TextStyle(color: Colors.red),
                  ),
                );
              }

              if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
                return const Center(
                  child: Text(
                    'No brands found',
                    style: TextStyle(color: Colors.white54),
                  ),
                );
              }

              final brands = snapshot.data!.data
                  .where(
                    (brand) => brand.brand.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ),
                  )
                  .toList();

              return GridView.builder(
                shrinkWrap: true,
                itemCount: brands.length,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 0.80,
                ),
                itemBuilder: (context, index) {
                  final brand = brands[index];

                  String fileName = brand.brand.toLowerCase() == "apple"
                      ? "iphone"
                      : brand.brand.toLowerCase();

                  final imageUrl =
                      "https://gofix.co.in/assets/brands/$fileName.png";

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Selectmodels(
                            itemGroupId: widget.itemGroupId,
                            brandId: brand.brandId,
                            brandName: brand.brand,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEEEEE),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFFF64E6),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Image.network(
                              imageUrl,
                              height: 60,
                              fit: BoxFit.contain,

                              /// ✅ FIX 3: Removed asset error
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.image, size: 40),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            brand.brand,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
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
      ),
    );
  }
}
