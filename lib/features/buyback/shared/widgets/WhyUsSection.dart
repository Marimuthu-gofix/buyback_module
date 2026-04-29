import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../Color/app_colors.dart';

class WhyUsSection extends StatefulWidget {
  const WhyUsSection({super.key});

  @override
  State<WhyUsSection> createState() => _WhyUsSectionState();
}

class _WhyUsSectionState extends State<WhyUsSection> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  final List<Map<String, dynamic>> allItems = [
    {"icon": LucideIcons.truck, "text": "Courier & Local Pickups Available"},
    {"icon": LucideIcons.badgePercent, "text": "Assured Competitive Pricing"},
    {"icon": LucideIcons.shieldCheck, "text": "Warranty Coverage Provided"},
    {"icon": LucideIcons.headphones, "text": "Exceptional Customer Service"},
    {"icon": LucideIcons.cpu, "text": "Quality Replacement Parts"},
    {"icon": LucideIcons.lock, "text": "Secure & Private Data Handling"},
    {"icon": LucideIcons.clock, "text": "Quick Turnaround Time"},
    {"icon": LucideIcons.userCheck, "text": "Trusted by 1000+ Customers"},
  ];

  List<List<Map<String, dynamic>>> get paginatedItems {
    List<List<Map<String, dynamic>>> pages = [];
    for (int i = 0; i < allItems.length; i += 6) {
      pages.add(allItems.sublist(i, (i + 6).clamp(0, allItems.length)));
    }
    return pages;
  }

  void _nextPage() {
    if (currentPage < paginatedItems.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
      );
    }
  }

  void _prevPage() {
    if (currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = paginatedItems;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Why Us",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
          ),

          SizedBox(height: 6.h),

          Text(
            "Expert Service • Reliable Support • Quality Assured",
            style: TextStyle(
              color: Colors.white60,
              fontSize: 12.sp,
            ),
          ),

          SizedBox(height: 20.h),

          /// Carousel Grid
          SizedBox(
            height: 325.h,
            child: PageView.builder(
              controller: _pageController,
              itemCount: pages.length,
              onPageChanged: (index) =>
                  setState(() => currentPage = index),
              itemBuilder: (context, pageIndex) {
                final items = pages[pageIndex];

                return GridView.builder(
                  physics:
                  const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 14.h,
                    crossAxisSpacing: 14.w,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];

                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius:
                        BorderRadius.circular(12.r),
                        border: Border.all(
                          color:
                          const Color(0xFFFF64E6),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color:
                            Colors.black.withOpacity(0.25),
                            blurRadius: 5,
                            offset: Offset(0, 3.h),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          ///  Icon
                          Container(
                            padding: EdgeInsets.all(10.w),
                            decoration: BoxDecoration(
                              color:
                              const Color(0xFFFF64E6),
                              borderRadius:
                              BorderRadius.circular(
                                  10.r),
                            ),
                            child: Icon(
                              item["icon"],
                              color: Colors.white,
                              size: 18.sp,
                            ),
                          ),

                          SizedBox(height: 10.h),

                          ///  Text
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 6.w),
                            child: Text(
                              item["text"],
                              textAlign:
                              TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10.sp,
                                height: 1.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),

          SizedBox(height: 12.h),

          ///  Navigation
          Row(
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: [
              _navButton(
                icon: LucideIcons.chevronLeft,
                onTap: _prevPage,
                isDisabled: currentPage == 0,
              ),

              SizedBox(width: 18.w),

              _navButton(
                icon: LucideIcons.chevronRight,
                onTap: _nextPage,
                isDisabled:
                currentPage == pages.length - 1,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _navButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool isDisabled,
  }) {
    return InkWell(
      onTap: isDisabled ? null : onTap,
      borderRadius: BorderRadius.circular(40.r),
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: isDisabled
              ? Colors.grey.shade600
              : Color(0xFFFF64E6),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 14.sp,
        ),
      ),
    );
  }
}