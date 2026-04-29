import 'package:buyback_module/features/buyback/Pages/evaluationpage/warranty_condition_page.dart';
import 'package:buyback_module/features/buyback/Pages/evaluationpage/widgets/bottom_nav_button.dart';
import 'package:buyback_module/features/buyback/Pages/evaluationpage/widgets/evaluation_header_card.dart';
import 'package:buyback_module/features/buyback/Pages/evaluationpage/widgets/problem_grid_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Providers/evaluation_provider.dart';
import '../../shared/Color/app_colors.dart';

class AccessoriesPage extends StatefulWidget {
  final String itemname;
  final String imageUrl;
  const AccessoriesPage({
    super.key,
    required this.itemname,
    required this.imageUrl,
  });

  @override
  State<AccessoriesPage> createState() => _AccessoriesPageState();
}

class _AccessoriesPageState extends State<AccessoriesPage> {
  /// Multi-select accessories
  final Set<String> selectedAccessories = {};

  /// STATIC DATA (Replace with your own if needed)
  final String questionText = " accessories?";
  final Map<String, String> accessoriesOptions = {
    "Orginal Charger of Device": "Images/Evaluation/Icons/Asset 3.png",
    "Orginal Box with Same Imei": "Images/Evaluation/Icons/Asset 2.png",
    "Bill with Same IMEI": "Images/Evaluation/Icons/Asset 1.png",
  };

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<EvaluationProvider>()
            .sections["Accessories"]
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
              context.read<EvaluationProvider>().clearSection("Accessories");
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
              /// HEADER (STATIC VALUES)
              EvaluationHeaderCard(
                itemname: widget.itemname,
                variant: "(128GB)",
                imageUrl: widget.imageUrl,
                progress: 0.75,
                selectedAnswers: {},
              ),

              const SizedBox(height: 20),

              Text(
                questionText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 12),

              /// ACCESSORIES GRID
              ProblemGridCard(
                selectedItems: selectedAccessories,
                onToggle: (value) {
                  setState(() {
                    if (selectedAccessories.contains(value)) {
                      selectedAccessories.remove(value);

                      /// ❌ REMOVE
                      context.read<EvaluationProvider>()
                          .sections["Accessories"]
                          ?.remove(value);
                    } else {
                      selectedAccessories.add(value);

                      /// ✅ ADD
                      context.read<EvaluationProvider>().updateAnswer(
                        "Accessories",
                        value,
                        "Available",
                      );
                    }
                  });
                },
                options: accessoriesOptions,
              ),

              const SizedBox(height: 90),
            ],
          ),
        ),

        /// NEXT BUTTON
        bottomNavigationBar: BottomNavButton(
          text: "Next →",
          onTap: () {
            debugPrint("Final Accessories: $selectedAccessories");
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WarrantyConditionPage(
                  itemname: widget.itemname,
                  imageUrl: widget.imageUrl,
                  progress: 0.6,
                  previousAnswers: {},
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
