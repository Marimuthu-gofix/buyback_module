import 'package:buyback_module/features/buyback/Pages/evaluationpage/widgets/bottom_nav_button.dart';
import 'package:buyback_module/features/buyback/Pages/evaluationpage/widgets/evaluation_header_card.dart';
import 'package:flutter/material.dart';
import '../../Providers/evaluation_provider.dart';
import '../../shared/Color/app_colors.dart';
import 'functional_problem_page.dart';
import 'package:provider/provider.dart';

class PhysicalConditionPage extends StatefulWidget {
  final Map<int, bool> previousAnswers;
  final String itemname;
  final String imageUrl;

  const PhysicalConditionPage({
    super.key,
    required this.previousAnswers,
    required this.itemname,
    required this.imageUrl,
  });

  @override
  State<PhysicalConditionPage> createState() => _PhysicalConditionPageState();
}

class _PhysicalConditionPageState extends State<PhysicalConditionPage> {
  final Map<int, String> selectedAnswers = {};

  /// ✅ GROUPED QUESTIONS (LIKE YOUR UI)
  final List<Map<String, dynamic>> sections = [
    {
      "title": "Screen Condition",
      "id": 1,
      "options": [
        {"text": "No Spot", "img": "Images/Evaluation/Icons/Asset 19.png"},
        {"text": "Minor Spot", "img": "Images/Evaluation/Icons/Asset 18.png"},
        {"text": "Major Spot", "img": "Images/Evaluation/Icons/Asset 17.png"},
      ],
    },
    {
      "title": "Touch Glass Condition",
      "id": 2,
      "options": [
        {"text": "No Spot", "img": "Images/Evaluation/Icons/Asset 19.png"},
        {"text": "Minor Spot", "img": "Images/Evaluation/Icons/Asset 18.png"},
        {"text": "Major Spot", "img": "Images/Evaluation/Icons/Asset 17.png"},
      ],
    },
    {
      "title": "Back Panel Condition",
      "id": 3,
      "options": [
        {"text": "No Spot", "img": "Images/Evaluation/Icons/Asset 19.png"},
        {"text": "Minor Spot", "img": "Images/Evaluation/Icons/Asset 18.png"},
        {"text": "Major Spot", "img": "Images/Evaluation/Icons/Asset 17.png"},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<EvaluationProvider>()
            .sections["Physical Condition"]
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
            ),
            onPressed: () {
              /// ✅ CLEAR ONLY PHYSICAL CONDITION
              context.read<EvaluationProvider>()
                  .sections["Physical Condition"]
                  ?.clear();

              context.read<EvaluationProvider>().notifyListeners();

              Navigator.pop(context);
            },
          ),
          title: const Text("Your Device", style: TextStyle(color: Colors.white)),
        ),

        /// BODY
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HEADER
              EvaluationHeaderCard(
                itemname: widget.itemname,
                variant: "(128 GB)",
                imageUrl: widget.imageUrl,
                progress: 0.35,
                selectedAnswers: {},
              ),

              const SizedBox(height: 20),

              /// 🔥 LOOP SECTIONS
              ...sections.map((section) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// TITLE
                    Text(
                      section["title"],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// GRID
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: section["options"].length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.90,
                          ),
                      itemBuilder: (context, index) {
                        final opt = section["options"][index];
                        final text = opt["text"];
                        final img = opt["img"];

                        final isSelected = selectedAnswers[section["id"]] == text;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedAnswers[section["id"]] = text;
                            });

                            /// ✅ ADD THIS
                            context.read<EvaluationProvider>().updateAnswer(
                              "Physical Condition",          // section name
                              section["title"],              // question
                              text,                          // selected answer
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.pink
                                    : Colors.grey.shade300,
                                width: 2,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(img, height: 100),
                                const SizedBox(height: 8),
                                Text(
                                  text,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 20),
                  ],
                );
              }).toList(),

              const SizedBox(height: 90),
            ],
          ),
        ),

        /// NEXT BUTTON
        bottomNavigationBar: BottomNavButton(
          text: "Next →",
          onTap: () {
            if (selectedAnswers.length != sections.length) {
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
                ),
              ),
            );
            print("Go to next page");
          },
        ),
      ),
    );
  }
}
