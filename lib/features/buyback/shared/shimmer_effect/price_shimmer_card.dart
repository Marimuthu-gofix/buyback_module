import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../Color/app_colors.dart';

class PriceShimmerCard extends StatelessWidget {
  const PriceShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade800,
      highlightColor: Colors.grey.shade600,
      child: Container(
        height: 170,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.surface,
          border: Border.all(color: const Color(0xFFFF64E6)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🔹 TOP ROW (IMAGE + TEXT)
            Row(
              children: [
                /// Image
                Container(
                  height: 70,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),

                const SizedBox(width: 12),

                /// Text section
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Evaluation label
                      Container(
                        height: 8,
                        width: 70,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 6),

                      /// Title
                      Container(
                        height: 12,
                        width: double.infinity,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 6),

                      /// Subtitle
                      Container(
                        height: 10,
                        width: 100,
                        color: Colors.white,
                      ),
                    ],
                  ),
                )
              ],
            ),

            const SizedBox(height: 20),

            /// 🔹 PROGRESS BAR
            Container(
              height: 6,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            const SizedBox(height: 12),

            /// 🔹 BOTTOM TEXT
            Center(
              child: Container(
                height: 10,
                width: 150,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}