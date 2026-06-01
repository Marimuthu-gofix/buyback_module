import 'package:buyback_module/features/buyback/Pages/evaluationpage/widgets/bottom_nav_button.dart';
import 'package:buyback_module/features/buyback/Pages/evaluationpage/widgets/evaluation_header_card.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Providers/evaluation_provider.dart';

import '../../shared/Color/app_colors.dart';

import 'functional_problem_page.dart';

import 'package:provider/provider.dart';

import 'model/question_model.dart';

class PhysicalConditionPage extends StatefulWidget {
  final Map<int, bool> previousAnswers;

  final String itemname;

  final String imageUrl;

  /// ✅ DYNAMIC VALUES
  final String itemCode;

  final String brand;

  final String imeiSerial;

  final String company;

  final String itemGroup;
  final String variant;

  const PhysicalConditionPage({
    super.key,

    required this.previousAnswers,

    required this.itemname,

    required this.imageUrl,

    required this.itemCode,

    required this.brand,

    required this.imeiSerial,

    required this.company,

    required this.itemGroup,
    required double progress,
    required String customerName,
    required String email,
    required String mobileNo,
    required this.variant,
  });

  @override
  State<PhysicalConditionPage> createState() => _PhysicalConditionPageState();
}

class _PhysicalConditionPageState extends State<PhysicalConditionPage> {
  final Map<int, String> selectedAnswers = {};

  /// ✅ IMAGE MAPPING
  String getImage(String optionLabel) {
    if (optionLabel.toLowerCase().contains("no")) {
      return "Images/Evaluation/Icons/Asset 19.png";
    } else if (optionLabel.toLowerCase().contains("minor")) {
      return "Images/Evaluation/Icons/Asset 18.png";
    } else {
      return "Images/Evaluation/Icons/Asset 17.png";
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EvaluationProvider>();

    final questions = provider.physicalQuestions;

    if (provider.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (questions.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("No Physical Data Found")),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        context.read<EvaluationProvider>().clearSection("Physical Condition");

        return true;
      },

      child: Scaffold(
        backgroundColor: AppColors.surfaceDark,

        /// ✅ APP BAR
        appBar: AppBar(
          backgroundColor: Colors.black,

          elevation: 0,

          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,

              color: Colors.white,
            ),

            onPressed: () {
              context.read<EvaluationProvider>().clearSection(
                "Physical Condition",
              );

              Navigator.pop(context);
            },
          ),

          title: const Text(
            "Your Device",

            style: TextStyle(color: Colors.white),
          ),
        ),

        /// ✅ BODY
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              /// ✅ HEADER
              EvaluationHeaderCard(
                itemname: widget.itemname,

                variant: "",

                imageUrl: widget.imageUrl,

                progress: 0.35,

                selectedAnswers: {},
              ),

              const SizedBox(height: 20),

              /// ✅ QUESTIONS
              ...questions.asMap().entries.map((entry) {
                final index = entry.key;

                final q = entry.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    /// QUESTION
                    Text(
                      q.questionText,

                      style: const TextStyle(
                        color: Colors.white,

                        fontSize: 16,

                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    /// OPTIONS GRID
                    /// OPTIONS GRID
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: q.options.length,

                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,

                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.95,
                            ),

                        itemBuilder: (context, i) {
                          final opt = q.options[i];

                          final label = opt.optionLabel;

                          final value = opt.optionValue;

                          final isSelected = selectedAnswers[index] == value;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedAnswers[index] = value;
                              });

                              /// ✅ STORE PROVIDER
                              context.read<EvaluationProvider>().updateAnswer(
                                "Physical Condition",
                                q.questionText,
                                q.questionName,
                                opt.optionValue,
                                opt.optionLabel,
                              );
                            },

                            child: Container(
                              padding: const EdgeInsets.all(10),

                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,

                                borderRadius: BorderRadius.circular(12),

                                border: Border.all(
                                  color: isSelected
                                      ? Color(0xFFFF64E6)
                                      : Colors.grey.shade300,
                                  width: 2,
                                ),
                              ),

                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,

                                children: [
                                  /// ✅ IMAGE
                                  Image.asset(
                                    getImage(label),
                                    height: 90.h,
                                    fit: BoxFit.contain,
                                  ),

                                  SizedBox(height: 6.h),

                                  /// ✅ TEXT
                                  Text(
                                    label,
                                    textAlign: TextAlign.center,

                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,

                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12.sp,
                                      height: 1.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }).toList(),
            ],
          ),
        ),

        /// ✅ NEXT BUTTON
        bottomNavigationBar: BottomNavButton(
          text: "Next →",

          onTap: () {
            if (selectedAnswers.length != questions.length) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Please answer all questions")),
              );

              return;
            }

            final allAnswers = {...widget.previousAnswers, ...selectedAnswers};

            print("All Answers: $allAnswers");

            Navigator.push(
              context,

              MaterialPageRoute(
                builder: (_) => FunctionalProblemPage(
                  itemname: widget.itemname,

                  imageUrl: widget.imageUrl,

                  /// ✅ PASS VALUES
                  itemCode: widget.itemCode,

                  brand: widget.brand,

                  imeiSerial: widget.imeiSerial,

                  company: widget.company,

                  itemGroup: widget.itemGroup,
                  variant: widget.variant,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
