import 'package:flutter/material.dart';

import 'BottomSheet.dart';

class EvaluationHeaderCard extends StatelessWidget {
  final Map<String, String> selectedAnswers;
  final String itemname;
  final String variant;
  final String imageUrl;
  final double progress; // 0.0 to 1.0

  const EvaluationHeaderCard({
    super.key,
    required this.itemname,
    required this.variant,
    required this.imageUrl,
    required this.progress,
    required this.selectedAnswers,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xffFF4FD8)),
      ),
      child: Column(
        children: [
          /// TOP ROW
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                imageUrl,
                height: 100,
                errorBuilder: (_, __, ___) =>
                    Image.asset("Images/logo.png", height: 100),
              ),
              const SizedBox(width: 14),
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
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          /// PROGRESS BAR
          _EvaluationProgressBar(progress: progress),

          const SizedBox(height: 15),

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
