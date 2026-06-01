import 'package:buyback_module/features/buyback/Pages/evaluationpage/widgets/bottom_nav_button.dart';
import 'package:buyback_module/features/buyback/Pages/evaluationpage/widgets/evaluation_header_card.dart';
import 'package:buyback_module/features/buyback/Pages/evaluationpage/widgets/problem_grid_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Providers/evaluation_provider.dart';
import '../../shared/Color/app_colors.dart';
import 'accessories_page.dart';
import 'package:provider/provider.dart';
import 'model/question_model.dart';

class FunctionalProblemPage extends StatefulWidget {
  final String itemname;
  final String imageUrl;

  /// ✅ DYNAMIC VALUES
  final String itemCode;
  final String brand;
  final String imeiSerial;
  final String company;
  final String itemGroup;
  final String variant;

  const FunctionalProblemPage({
    super.key,
    required this.itemname,
    required this.imageUrl,
    required this.itemCode,
    required this.brand,
    required this.imeiSerial,
    required this.company,
    required this.itemGroup,
    required this.variant,
  });

  @override
  State<FunctionalProblemPage> createState() => _FunctionalProblemPageState();
}

class _FunctionalProblemPageState extends State<FunctionalProblemPage> {
  /// ✅ STORE SELECTED
  final Map<int, bool> selectedMap = {};

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EvaluationProvider>();

    final List<QuestionModel> questions = provider.functionalQuestions;

    if (provider.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (questions.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("No Functional Data Found")),
      );
    }

    /// ✅ SAME UI LIKE ACCESSORIES
    final Map<String, String> functionalOptions = {
      for (var q in questions) q.questionText: "Images/Evaluation/Icons/1.png",
    };

    return WillPopScope(
      onWillPop: () async {
        context.read<EvaluationProvider>().clearSection("Functional Problems");

        return true;
      },

      child: Scaffold(
        backgroundColor: AppColors.surfaceDark,

        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,

          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 20,
            ),

            onPressed: () {
              context.read<EvaluationProvider>().clearSection(
                "Functional Problems",
              );

              Navigator.pop(context);
            },
          ),

          title: const Text(
            "Your Device",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

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
                progress: 0.55,
                selectedAnswers: {},
              ),

              const SizedBox(height: 20),

              Text(
                "Functional or Physical Problems",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 16),

              /// ✅ PROBLEM GRID CARD
              ProblemGridCard(
                options: functionalOptions,

                selectedItems: selectedMap.entries
                    .where((e) => e.value)
                    .map((e) => questions[e.key].questionText)
                    .toSet(),

                onToggle: (questionText) {
                  final index = questions.indexWhere(
                    (e) => e.questionText == questionText,
                  );

                  final q = questions[index];

                  final isSelected = selectedMap[index] ?? false;

                  /// ✅ QUESTION TYPE
                  final isSingleSelect =
                      q.questionType.toLowerCase() == "single select";

                  setState(() {
                    if (isSingleSelect) {
                      selectedMap.clear();

                      selectedMap[index] = true;
                    } else {
                      if (isSelected) {
                        selectedMap.remove(index);

                        /// REMOVE FROM PROVIDER
                        context
                            .read<EvaluationProvider>()
                            .sections["Functional Problems"]
                            ?.removeWhere(
                              (e) =>
                                  e["question_id"] ==
                                  "${q.questionName}_$index",
                            );
                      } else {
                        selectedMap[index] = true;
                      }
                    }
                  });

                  /// STORE ONLY WHEN SELECTED
                  if (!isSelected || isSingleSelect) {
                    context.read<EvaluationProvider>().updateAnswer(
                      "Functional Problems",
                      q.questionText,
                      "${q.questionName}_$index",
                      q.options.isNotEmpty
                          ? q.options.first.optionValue
                          : q.questionName,
                      q.options.isNotEmpty
                          ? q.options.first.optionLabel
                          : q.questionText,
                    );
                  }
                },
              ),
            ],
          ),
        ),

        /// ✅ NEXT BUTTON
        bottomNavigationBar: BottomNavButton(
          text: "Next →",

          onTap: () {
            debugPrint("Selected Functional: $selectedMap");

            Navigator.push(
              context,

              MaterialPageRoute(
                builder: (_) => AccessoriesPage(
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
