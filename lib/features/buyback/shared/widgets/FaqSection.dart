import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../Color/app_colors.dart';

class FaqSection extends StatefulWidget {
  const FaqSection({super.key});

  @override
  State<FaqSection> createState() => _FaqSectionState();
}

class _FaqSectionState extends State<FaqSection> {
  int? expandedIndex;

  final List<Map<String, String>> faqs = [
    {
      "question": "Where is the repair facility located?",
      "answer":
          "GoFix repair hubs are located across Chennai. For customers outside Chennai, we provide a secure courier pickup and delivery service across India.",
    },
    {
      "question": "Do you offer courier pickup and delivery?",
      "answer":
          "Yes, we offer both courier and local pickup options for your convenience.",
    },
    {
      "question": "How long does a repair take?",
      "answer":
          "Most repairs are completed within 24–48 hours depending on the issue and part availability.",
    },
    {
      "question": "Are the parts you use genuine?",
      "answer":
          "Absolutely. We use only high-quality, genuine parts for all repairs to ensure long-lasting performance.",
    },
    {
      "question": "Will my data be safe during repair?",
      "answer":
          "Yes, your data is completely safe. We follow strict privacy and data security protocols during all repairs.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 14.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title
          Text(
            "Frequently Asked Questions",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 12.h),

          /// FAQ List
          Column(
            children: List.generate(faqs.length, (index) {
              final item = faqs[index];
              final isExpanded = expandedIndex == index;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: EdgeInsets.only(bottom: 10.h),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: const Color(0xFFFF64E6)),
                ),
                child: Column(
                  children: [
                    /// Question
                    ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 4.h,
                      ),
                      title: Text(
                        item["question"]!,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: Container(
                        width: 28.w,
                        height: 28.w,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF64E6),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            isExpanded
                                ? LucideIcons.chevronDown
                                : LucideIcons.chevronRight,
                            size: 12.sp,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              expandedIndex = isExpanded ? null : index;
                            });
                          },
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          expandedIndex = isExpanded ? null : index;
                        });
                      },
                    ),

                    /// Answer
                    if (isExpanded)
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 10.h,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(width: 1, color: Colors.white10),
                          ),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10.r),
                            bottomRight: Radius.circular(10.r),
                          ),
                        ),
                        child: Text(
                          item["answer"]!,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 11.sp,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
