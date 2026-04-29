import 'package:buyback_module/features/buyback/Pages/evaluationpage/physical_condition_page.dart';
import 'package:buyback_module/features/buyback/Pages/evaluationpage/widgets/bottom_nav_button.dart';
import 'package:buyback_module/features/buyback/Pages/evaluationpage/widgets/evaluation_header_card.dart';
import 'package:buyback_module/features/buyback/Pages/evaluationpage/widgets/yes_no_question_card.dart';
import 'package:flutter/material.dart';
import '../../Providers/evaluation_provider.dart';
import '../../shared/Color/app_colors.dart';
import 'package:provider/provider.dart';
import 'model/question_model.dart';

class OverallConditionPage extends StatefulWidget {
  final String itemname;
  final String imageUrl;
  final double progress;

  const OverallConditionPage({
    super.key,
    required this.itemname,
    required this.imageUrl,
    required this.progress,
  });

  @override
  State<OverallConditionPage> createState() => _OverallConditionPageState();
}

class _OverallConditionPageState extends State<OverallConditionPage>
    with TickerProviderStateMixin {
  final Map<int, bool> selectedAnswers = {};
  bool isFirstQuestionNo = false;

  @override
  Widget build(BuildContext context) {
    final questions = ConditionData.questions;
    final firstQuestion = questions.first;

    return WillPopScope(
      onWillPop: () async {
        context.read<EvaluationProvider>()
            .sections["Overall Condition"]
            ?.clear();

        context.read<EvaluationProvider>().notifyListeners();

        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.surfaceDark,
      
        /// APP BAR
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
              /// ✅ CLEAR ONLY PHYSICAL CONDITION
              context.read<EvaluationProvider>()
                  .sections["Overall Condition"]
                  ?.clear();
      
              context.read<EvaluationProvider>().notifyListeners();
      
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
      
        /// BODY
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              /// ✅ HEADER (IMPORTANT FIX: NO const)
              EvaluationHeaderCard(
                itemname: widget.itemname,
                variant: "(128 GB)",
                imageUrl: widget.imageUrl,
                progress: widget.progress,
                selectedAnswers: {},
              ),
      
              const SizedBox(height: 20),
      
              /// QUESTIONS
              ...questions.map((q) {
                final isFirst = q.id == firstQuestion.id;
                final hide = isFirstQuestionNo && !isFirst;
      
                return AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  child: hide
                      ? const SizedBox.shrink()
                      : Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: YesNoQuestionCard(
                            questionNumber: q.id.toString(),
                            question: q.question,
                            description: q.description,
                            onAnswer: (isYes) {
                              setState(() {
                                selectedAnswers[q.id] = isYes;
                                q.answer = isYes;
      
                                if (q.id == firstQuestion.id) {
                                  isFirstQuestionNo = !isYes;
      
                                  if (isFirstQuestionNo) {
                                    selectedAnswers.clear();
                                    selectedAnswers[q.id] = isYes;
                                  }
                                }
                              });
      
                              /// ✅ ADD THIS (IMPORTANT)
                              context.read<EvaluationProvider>().updateAnswer(
                                "Overall Condition",
                                q.question,
                                isYes ? "Yes" : "No",
                              );
                            },
                          ),
                        ),
                );
              }).toList(),
            ],
          ),
        ),
      
        /// NEXT BUTTON
        bottomNavigationBar: BottomNavButton(
          text: "Next →",
          onTap: () {
            /// FIRST QUESTION = NO → skip flow
            if (isFirstQuestionNo) {
              print("Go to Final Price Page");
              return;
            }
      
            /// VALIDATION
            if (selectedAnswers.length != questions.length) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Please answer all questions")),
              );
              return;
            }
      
            /// DEBUG
            for (var q in questions) {
              print("${q.question} → ${q.answer}");
            }
      
            /// ✅ NAVIGATE TO PHYSICAL CONDITION PAGE
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PhysicalConditionPage(
                  itemname: widget.itemname,
                  imageUrl: widget.imageUrl,
                  previousAnswers: selectedAnswers, // ✅ PASS THIS
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
