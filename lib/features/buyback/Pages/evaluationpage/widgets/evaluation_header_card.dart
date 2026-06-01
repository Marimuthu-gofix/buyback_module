import 'package:flutter/material.dart';

import 'BottomSheet.dart';

class EvaluationHeaderCard extends StatelessWidget {
  final Map<String, String> selectedAnswers;

  final String itemname;
  final String variant;
  final String imageUrl;

  final double? progress;

  /// OPTIONAL
  final String? price;

  final VoidCallback? onSellNow;

  const EvaluationHeaderCard({
    super.key,
    required this.itemname,
    required this.variant,
    required this.imageUrl,
    required this.selectedAnswers,

    /// OPTIONAL
    this.price,
    this.onSellNow,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xffFF4FD8), width: 1.2),
      ),

      child: Column(
        children: [
          /// TOP ROW
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              /// IMAGE
              Padding(
                padding: const EdgeInsets.only(top: 10),

                child: Image.network(
                  imageUrl,
                  height: 125,
                  width: 110,
                  fit: BoxFit.contain,

                  errorBuilder: (_, __, ___) {
                    return Image.asset(
                      "Images/logo.png",
                      height: 110,
                      width: 90,
                    );
                  },
                ),
              ),

              const SizedBox(width: 14),

              /// DETAILS
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const Text(
                      "Evaluation",
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      itemname,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      variant,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),

                    /// PRICE
                    if (price != null) ...[
                      // const SizedBox(height: 6),
                      const Text(
                        "Selling Price",
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),

                      //
                      // const SizedBox(height: 5),
                      Text(
                        price!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// PROGRESS BAR
          if (price == null) ...[
            _EvaluationProgressBar(progress: progress ?? 0),

            const SizedBox(height: 15),
          ],

          /// VIEW SUMMARY
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                builder: (_) => const EvaluationBottomSheet(),
              );
            },

            child: const Align(
              alignment: Alignment.center,
              child: Text(
                "View Evaluation Summary",
                style: TextStyle(
                  color: Color(0xffFF4FD8),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          /// SELL NOW BUTTON
          if (onSellNow != null) ...[
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 40,

              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffFF4FD8),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                onPressed: onSellNow,

                child: const Text(
                  "Sell Now",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _EvaluationProgressBar extends StatelessWidget {
  final double progress;

  const _EvaluationProgressBar({required this.progress});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),

      child: Container(
        height: 6,
        width: double.infinity,
        color: Colors.white24,

        child: FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: progress.clamp(0.0, 1.0),

          child: Container(
            decoration: const BoxDecoration(color: Color(0xffFF4FD8)),
          ),
        ),
      ),
    );
  }
}
