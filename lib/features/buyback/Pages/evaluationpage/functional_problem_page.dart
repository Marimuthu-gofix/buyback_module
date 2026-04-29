import 'package:buyback_module/features/buyback/Pages/evaluationpage/widgets/bottom_nav_button.dart';
import 'package:buyback_module/features/buyback/Pages/evaluationpage/widgets/evaluation_header_card.dart';
import 'package:buyback_module/features/buyback/Pages/evaluationpage/widgets/problem_issue_card.dart';
import 'package:flutter/material.dart';
import '../../Providers/evaluation_provider.dart';
import '../../shared/Color/app_colors.dart';
import 'accessories_page.dart';
import 'package:provider/provider.dart';

class FunctionalProblemPage extends StatefulWidget {
  final String itemname;
  final String imageUrl;
  const FunctionalProblemPage({
    super.key,
    required this.itemname,
    required this.imageUrl,
  });

  @override
  State<FunctionalProblemPage> createState() => _FunctionalProblemPageState();
}

class _FunctionalProblemPageState extends State<FunctionalProblemPage> {
  /// Store selected problems
  final Set<int> selectedProblems = {};

  /// STATIC DATA (Replace later if needed)
  final List<Map<String, dynamic>> problems = [
    {
      "id": 1,
      "text": "Front Camera not working",
      "img": "Images/Evaluation/Icons/1.png",
    },
    {
      "id": 2,
      "text": "Back Camera not working",
      "img": "Images/Evaluation/Icons/2.png",
    },
    {
      "id": 3,
      "text": "Volume Button not working",
      "img": "Images/Evaluation/Icons/3.png",
    },
    {
      "id": 4,
      "text": "Finger Touch not working",
      "img": "Images/Evaluation/Icons/4.png",
    },
    {
      "id": 5,
      "text": "WiFi not working",
      "img": "Images/Evaluation/Icons/5.png",
    },
    {
      "id": 6,
      "text": "Battery Faulty",
      "img": "Images/Evaluation/Icons/17.png",
    },
    {"id": 7, "text": "Speaker Faulty", "img": "Images/Evaluation/Icons/6.png"},
    {
      "id": 8,
      "text": "Power Button not working",
      "img": "Images/Evaluation/Icons/9.png",
    },
    {
      "id": 9,
      "text": "Charging Port not working",
      "img": "Images/Evaluation/Icons/7.png",
    },
    {
      "id": 10,
      "text": "Face Sensor not working",
      "img": "Images/Evaluation/Icons/8.png",
    },
    {
      "id": 11,
      "text": "Silent Button not working",
      "img": "Images/Evaluation/Icons/10.png",
    },
    {
      "id": 12,
      "text": "Audio Receiver not working",
      "img": "Images/Evaluation/Icons/11.png",
    },
    {
      "id": 13,
      "text": "Camera Glass Broken",
      "img": "Images/Evaluation/Icons/12.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<EvaluationProvider>()
            .sections["Functional Problems"]
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
              context.read<EvaluationProvider>().clearSection("Functional Problems");
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

        /// BODY (NO FutureBuilder)
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HEADER (STATIC)
              EvaluationHeaderCard(
                itemname: widget.itemname,
                variant: "(128GB)",
                imageUrl: widget.imageUrl,
                progress: 0.55,
                selectedAnswers: {},
              ),

              const SizedBox(height: 20),

              const Text(
                "Functional or Physical Problems",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 16),

              /// GRID OF ISSUES (STATIC)
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: problems.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.90,
                ),
                itemBuilder: (context, index) {
                  final problem = problems[index];
                  final isSelected = selectedProblems.contains(problem["id"]);

                  return ProblemIssueCard(
                    title: problem["text"] ?? "",
                    isSelected: isSelected,
                    iconPath: problem["img"] ?? "",
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedProblems.remove(problem["id"]);

                          /// ❌ REMOVE from provider
                          context.read<EvaluationProvider>()
                              .sections["Functional Problems"]
                              ?.remove(problem["text"]);
                        } else {
                          selectedProblems.add(problem["id"]);

                          /// ✅ ADD to provider
                          context.read<EvaluationProvider>().updateAnswer(
                            "Functional Problems",
                            problem["text"],
                            "Issue",
                          );
                        }
                      });
                    },
                  );
                },
              ),

              const SizedBox(height: 90),
            ],
          ),
        ),

        /// NEXT BUTTON
        bottomNavigationBar: BottomNavButton(
          text: "Next →",
          onTap: () {
            debugPrint("Final Issues: $selectedProblems");

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AccessoriesPage(
                  itemname: widget.itemname,
                  imageUrl: widget.imageUrl,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
