import 'package:buyback_module/features/buyback/Pages/evaluationpage/physical_condition_page.dart';
import 'package:buyback_module/features/buyback/Pages/evaluationpage/widgets/bottom_nav_button.dart';
import 'package:buyback_module/features/buyback/Pages/evaluationpage/widgets/evaluation_header_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Providers/evaluation_provider.dart';
import '../../shared/Color/app_colors.dart';
import 'package:provider/provider.dart';
import '../../shared/shimmer_effect/price_shimmer_card.dart';
import 'final_price_page.dart';

class OverallConditionPage extends StatefulWidget {
  final String itemname;
  final String imageUrl;
  final double progress;

  /// ✅ DYNAMIC VALUES
  final String itemCode;
  final String brand;
  final String imeiSerial;
  final String company;
  final String itemGroup;
  final String variant;

  const OverallConditionPage({
    super.key,
    required this.itemname,
    required this.imageUrl,
    required this.progress,
    required this.itemCode,
    required this.brand,
    required this.imeiSerial,
    required this.company,
    required this.itemGroup,
    required this.variant,
  });

  @override
  State<OverallConditionPage> createState() => _OverallConditionPageState();
}

class _OverallConditionPageState extends State<OverallConditionPage> {
  static const Color primaryColor = Color(0xFFFF64E6);

  final Map<int, String> selectedAnswers = {};

  bool isFirstQuestionNo = false;

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

    final questions = provider.generalQuestions;
    if (!provider.isLoading && questions.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text(
            "No Questions Found",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
    /// ✅ FIRST QUESTION
    final firstQuestion =
    questions.isNotEmpty ? questions.first : null;


    return WillPopScope(
      onWillPop: () async {
        context.read<EvaluationProvider>().clearSection("Overall Condition");

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
                "Overall Condition",
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

        body: provider.isLoading
            ? const Padding(
          padding: EdgeInsets.all(16),
          child: SizedBox(
            height: 180,
            child: PriceShimmerCard(),
          ),
        )
            : questions.isEmpty
            ? const Center(
          child: Text(
            "No Questions Found",
            style: TextStyle(color: Colors.white),
          ),
        )
            :  SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              /// ✅ HEADER
              EvaluationHeaderCard(
                itemname: widget.itemname,
                variant: "",
                imageUrl: widget.imageUrl,
                progress: widget.progress,
                selectedAnswers: {},
              ),

              const SizedBox(height: 20),

              /// ✅ QUESTIONS
              ...questions.asMap().entries.map((entry) {
                final index = entry.key;

                final q = entry.value;

                final isFirst =
                    firstQuestion != null &&
                        q.questionName == firstQuestion.questionName;
                final hide = isFirstQuestionNo && !isFirst;

                return AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  child: hide
                      ? const SizedBox.shrink()
                      : Padding(
                    padding: EdgeInsets.only(bottom: 20.sp),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// ✅ QUESTION
                          Text(
                            "${index + 1}. ${q.questionText}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          SizedBox(height: 18.h),

                          /// ✅ OPTIONS
                          Row(
                            children: List.generate(q.options.length, (
                                i,
                                ) {
                              final opt = q.options[i];

                              final isSelected =
                                  selectedAnswers[index] ==
                                      opt.optionValue;

                              final isYes =
                                  opt.optionLabel.toLowerCase() == "yes";

                              return Expanded(
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: () {
                                    setState(() {
                                      selectedAnswers[index] =
                                          opt.optionValue;

                                      /// ✅ FIRST QUESTION NO
                                      if (isFirst) {
                                        isFirstQuestionNo =
                                            opt.optionLabel
                                                .toLowerCase() ==
                                                "no";

                                        if (isFirstQuestionNo) {
                                          selectedAnswers.clear();

                                          selectedAnswers[index] =
                                              opt.optionValue;
                                        }
                                      }
                                    });

                                    context
                                        .read<EvaluationProvider>()
                                        .updateAnswer(
                                      "Overall Condition",
                                      q.questionText,
                                      q.questionName,
                                      opt.optionValue,
                                      opt.optionLabel,
                                    );
                                  },

                                  child: AnimatedScale(
                                    duration: const Duration(
                                      milliseconds: 150,
                                    ),
                                    scale: isSelected ? 1.05 : 1.0,
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 250,
                                      ),
                                      curve: Curves.easeInOut,
                                      margin: EdgeInsets.only(
                                        right: i == 0 ? 10 : 0,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? Colors.white
                                            : const Color(0xFFE0E0E0),
                                        borderRadius:
                                        BorderRadius.circular(10),
                                        border: Border.all(
                                          color: isSelected
                                              ? primaryColor
                                              : Colors.transparent,
                                          width: 2,
                                        ),
                                      ),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            /// ✅ ICON
                                            Icon(
                                              isYes
                                                  ? Icons.check
                                                  : Icons.close,
                                              color: isSelected
                                                  ? primaryColor
                                                  : Colors.black,
                                              size: 18.sp,
                                            ),

                                            const SizedBox(width: 6),

                                            /// ✅ TEXT
                                            Text(
                                              opt.optionLabel,
                                              style: TextStyle(
                                                color: isSelected
                                                    ? primaryColor
                                                    : Colors.black,
                                                fontWeight:
                                                FontWeight.w600,
                                                fontSize: 12.sp,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),

        /// ✅ NEXT BUTTON
        bottomNavigationBar: provider.isLoading
            ? const SizedBox.shrink()
            :BottomNavButton(
          text: "Next →",
          onTap: () {
            final firstAnswer = selectedAnswers[0];

            /// ✅ DIRECT FINAL PAGE
            if (firstAnswer == "No" ||
                firstAnswer == "NO" ||
                firstAnswer == "no") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => FinalPricePage()),
              );

              return;
            }

            /// ✅ VALIDATION
            if (selectedAnswers.length != questions.length) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Please answer all questions")),
              );

              return;
            }

            /// ✅ NEXT PAGE
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PhysicalConditionPage(
                  itemname: widget.itemname,
                  imageUrl: widget.imageUrl,
                  progress: widget.progress + 0.25,
                  previousAnswers: {},
                  itemCode: widget.itemCode,
                  brand: widget.brand,
                  imeiSerial: widget.imeiSerial,
                  company: widget.company,
                  itemGroup: widget.itemGroup,
                  customerName: '',
                  email: '',
                  mobileNo: '',
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
