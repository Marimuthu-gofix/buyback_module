import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../Providers/evaluation_provider.dart';

class EvaluationBottomSheet extends StatelessWidget {
  const EvaluationBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EvaluationProvider>();
    final sections = provider.sections;

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF2A2A2A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TITLE
          const Text(
            "Evaluation Summary",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          /// CONTENT
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: sections.entries.map((sectionEntry) {
                  final sectionName = sectionEntry.key;
                  final questions = sectionEntry.value;

                  if (questions.isEmpty) {
                    return const SizedBox();
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// SECTION TITLE
                      Text(
                        sectionName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      /// QUESTIONS
                      ...questions.asMap().entries.map((entry) {
                        int index = entry.key + 1;

                        final q = entry.value;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 4),

                          child: Text(
                            "$index. ${q["question_text"]} : ${q["answer_value"]}",

                            style: const TextStyle(color: Colors.white70),
                          ),
                        );
                      }).toList(),

                      const SizedBox(height: 16),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),

          /// DONE BUTTON
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: SizedBox(
                width: double.infinity,
                height: 52,

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF64E6),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  onPressed: () {
                    Navigator.pop(context);
                  },

                  child: Text(
                    "Done",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
