import 'package:flutter/material.dart';
import '../../../../shared/shimmer_effect/brand_shimmer_card.dart';
import '../../selectBrand.dart';
import '../../selectModel.dart';
import 'model/brand_model.dart';
import 'services/get_brand_service.dart';
import '../brandSection/brandSearchSection.dart'; // ✅ make sure path correct

class BrandSelectionSection extends StatefulWidget {
  final int itemGroupId;

  const BrandSelectionSection({
    super.key,
    required this.itemGroupId,
  });

  @override
  State<BrandSelectionSection> createState() => _BrandSelectionSectionState();
}

class _BrandSelectionSectionState extends State<BrandSelectionSection> {
  late Future<BrandList?> _futureBrands;
  int? _selectedBrandId;

  @override
  void initState() {
    super.initState();
    _futureBrands = GetBrandService.fetchBrands(
      widget.itemGroupId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BrandList?>(
      future: _futureBrands,
      builder: (context, snapshot) {
        // 🔄 Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 6,
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
          return const Center(child: Text("Error"));
        }

        if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
          return const Center(child: Text("No brands"));
        }
        // snapshot.data!.=is not null
        final brands = snapshot.data!.data.take(6).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Top Mobile Repaired Brands",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),

            const SizedBox(height: 10),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: brands.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 0.99,
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
                    setState(() {
                      _selectedBrandId = brand.brandId;
                    });

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Selectmodels(
                          brandId: brand.brandId,
                          brandName: brand.brand,
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
                        color: _selectedBrandId == brand.brandId
                            ? Color(0xFFFF64E6)
                            : const Color(0xFFFF64E6),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          imageUrl,
                          height: 80,
                          errorBuilder: (_, __, ___) => const Icon(Icons.image),
                        ),
                        // const SizedBox(height: 8),
                        // Text(
                        //   brand.brand,
                        //   style: const TextStyle(color: Colors.black),
                        // ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 15),

            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Selectbrands(
                        itemGroupId: widget.itemGroupId,
                      ),
                    ),
                  );
                },

                label: const Text("See All Brands"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF64E6),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
