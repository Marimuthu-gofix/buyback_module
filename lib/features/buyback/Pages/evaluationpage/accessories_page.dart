// import 'package:buyback/Pages/evaluationpage/warranty_condition_page.dart';
// import 'package:buyback/Pages/evaluationpage/widgets/bottom_nav_button.dart';
// import 'package:buyback/Pages/evaluationpage/widgets/evaluation_header_card.dart';
// import 'package:buyback/Pages/evaluationpage/widgets/problem_grid_card.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../../../Providers/evaluation_provider.dart';
// import '../../shared/Color/app_colors.dart';
//
// class AccessoriesPage extends StatefulWidget {
//   final String itemname;
//   final String imageUrl;
//
//   const AccessoriesPage({
//     super.key,
//     required this.itemname,
//     required this.imageUrl,
//     required String itemCode,
//     required String brand,
//     required String imeiSerial,
//     required String company,
//     required String itemGroup,
//   });
//
//   @override
//   State<AccessoriesPage> createState() => _AccessoriesPageState();
// }
//
// class _AccessoriesPageState extends State<AccessoriesPage> {
//   /// store selected using optionValue
//   final Map<String, String> selectedAccessories = {};
//
//   @override
//   void initState() {
//     super.initState();
//
//     Future.microtask(() {
//       context.read<EvaluationProvider>().loadQuestions();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<EvaluationProvider>();
//     final questions = provider.accessoriesQuestions;
//
//     if (provider.isLoading) {
//       return const Scaffold(body: Center(child: CircularProgressIndicator()));
//     }
//
//     if (questions.isEmpty) {
//       return const Scaffold(body: Center(child: Text("No Accessories Found")));
//     }
//
//     /// 🔥 KEEP UI SAME (questionText)
//     final Map<String, String> accessoriesOptions = {
//       for (var q in questions) q.questionText: "Images/Evaluation/Icons/1.png",
//     };
//
//     return WillPopScope(
//       onWillPop: () async {
//         context.read<EvaluationProvider>().clearSection("Accessories");
//         return true;
//       },
//       child: Scaffold(
//         backgroundColor: AppColors.surfaceDark,
//
//         appBar: AppBar(
//           backgroundColor: Colors.black,
//           elevation: 0,
//           leading: IconButton(
//             icon: const Icon(
//               Icons.arrow_back_ios_new_rounded,
//               color: Colors.white,
//               size: 20,
//             ),
//             onPressed: () {
//               context.read<EvaluationProvider>().clearSection("Accessories");
//               Navigator.pop(context);
//             },
//           ),
//           title: const Text(
//             "Your Device",
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 22,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ),
//
//         body: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               EvaluationHeaderCard(
//                 itemname: widget.itemname,
//                 variant: "(128GB)",
//                 imageUrl: widget.imageUrl,
//                 progress: 0.75,
//                 selectedAnswers: {},
//               ),
//
//               const SizedBox(height: 20),
//
//               const Text(
//                 "Accessories",
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//
//               const SizedBox(height: 12),
//
//               /// 🔥 SAME UI
//               ProblemGridCard(
//                 options: accessoriesOptions,
//                 selectedItems: selectedAccessories.keys.toSet(),
//
//                 onToggle: (questionText) {
//                   final q = questions.firstWhere(
//                     (e) => e.questionText == questionText,
//                   );
//
//                   /// ✅ TAKE FIRST OPTION (since no UI for options)
//                   final opt = q.options.isNotEmpty ? q.options.first : null;
//
//                   final value = opt?.optionValue ?? "Available";
//
//                   final isSingle =
//                       q.questionType.toLowerCase() == "single select";
//
//                   setState(() {
//                     if (isSingle) {
//                       selectedAccessories.clear();
//                       selectedAccessories[questionText] = value;
//                     } else {
//                       if (selectedAccessories.containsKey(questionText)) {
//                         selectedAccessories.remove(questionText);
//
//                         context
//                             .read<EvaluationProvider>()
//                             .sections["Accessories"]
//                             ?.remove(questionText);
//                       } else {
//                         selectedAccessories[questionText] = value;
//                       }
//                     }
//                   });
//
//                   /// ✅ STORE VALUE (not hardcoded)
//                   context.read<EvaluationProvider>().updateAnswer(
//                     "Accessories",
//
//                     /// SHOW TEXT
//                     questionText,
//
//                     /// STORE ID
//                     q.questionName,
//
//                     /// STORE ANSWER
//                     value,
//                   );
//                 },
//               ),
//
//               const SizedBox(height: 90),
//             ],
//           ),
//         ),
//
//         bottomNavigationBar: BottomNavButton(
//           text: "Next →",
//           onTap: () {
//             debugPrint("Accessories: $selectedAccessories");
//
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => WarrantyConditionPage(
//                   itemname: widget.itemname,
//                   imageUrl: widget.imageUrl,
//                   progress: 1.0,
//                   previousAnswers: {},
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

import 'package:buyback_module/features/buyback/Pages/evaluationpage/warranty_condition_page.dart';
import 'package:buyback_module/features/buyback/Pages/evaluationpage/widgets/bottom_nav_button.dart';
import 'package:buyback_module/features/buyback/Pages/evaluationpage/widgets/evaluation_header_card.dart';
import 'package:buyback_module/features/buyback/Pages/evaluationpage/widgets/problem_grid_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../Providers/evaluation_provider.dart';
import '../../shared/Color/app_colors.dart';

class AccessoriesPage extends StatefulWidget {
  final String itemname;

  final String imageUrl;

  /// ✅ DYNAMIC VALUES
  final String itemCode;

  final String brand;

  final String imeiSerial;

  final String company;

  final String itemGroup;
  final String variant;

  const AccessoriesPage({
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
  State<AccessoriesPage> createState() => _AccessoriesPageState();
}

class _AccessoriesPageState extends State<AccessoriesPage> {
  /// ✅ STORE SELECTED
  final Map<String, String> selectedAccessories = {};

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<EvaluationProvider>().loadQuestions(widget.itemCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EvaluationProvider>();

    final questions = provider.accessoriesQuestions;

    if (provider.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (questions.isEmpty) {
      return const Scaffold(body: Center(child: Text("No Accessories Found")));
    }

    /// ✅ SAME UI
    final Map<String, String> accessoriesOptions = {
      for (var q in questions) q.questionText: "Images/Evaluation/Icons/1.png",
    };

    return WillPopScope(
      onWillPop: () async {
        context.read<EvaluationProvider>().clearSection("Accessories");

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

                progress: 0.75,

                selectedAnswers: {},
              ),

              const SizedBox(height: 20),

              Text(
                "Accessories",

                style: TextStyle(
                  color: Colors.white,

                  fontSize: 16.sp,

                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 12),

              /// ✅ GRID
              ProblemGridCard(
                options: accessoriesOptions,

                selectedItems: selectedAccessories.keys.toSet(),

                onToggle: (questionText) {
                  final q = questions.firstWhere(
                    (e) => e.questionText == questionText,
                  );

                  final opt = q.options.isNotEmpty ? q.options.first : null;

                  final value = opt?.optionValue ?? "Available";

                  setState(() {
                    /// UNSELECT
                    if (selectedAccessories.containsKey(questionText)) {
                      /// REMOVE UI
                      selectedAccessories.remove(questionText);

                      /// REMOVE PROVIDER
                      context
                          .read<EvaluationProvider>()
                          .sections["Accessories"]
                          ?.removeWhere(
                            (item) => item["question_id"] == q.questionName,
                          );
                    }
                    /// SELECT
                    else {
                      /// ADD UI
                      selectedAccessories[questionText] = value;

                      /// ADD PROVIDER
                      context.read<EvaluationProvider>().updateAnswer(
                        "Accessories",

                        q.questionText,

                        q.questionName,

                        q.options.isNotEmpty
                            ? q.options.first.optionValue
                            : q.questionName,

                        q.options.isNotEmpty
                            ? q.options.first.optionLabel
                            : q.questionText,
                      );
                    }
                  });
                },
              ),
            ],
          ),
        ),

        /// ✅ NEXT BUTTON
        bottomNavigationBar: BottomNavButton(
          text: "Next →",

          onTap: () {
            debugPrint("Accessories: $selectedAccessories");

            Navigator.push(
              context,

              MaterialPageRoute(
                builder: (context) => WarrantyConditionPage(
                  itemname: widget.itemname,

                  imageUrl: widget.imageUrl,

                  progress: 1.0,

                  previousAnswers: {},

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
