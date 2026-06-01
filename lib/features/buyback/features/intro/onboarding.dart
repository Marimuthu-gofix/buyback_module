import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../shared/Color/app_colors.dart';
import 'authpage.dart';

class onboarding extends StatefulWidget {
  const onboarding({super.key});

  @override
  State<onboarding> createState() => _onboardingState();
}

class _onboardingState extends State<onboarding> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600;

  final List<Map<String, String>> _pages = [
    {
      "title": "Welcome to GoFix",
      "subtitle":
      "The easiest way to repair, diagnose,\nor sell your smartphone.",
      "image": "Images/onboarding/three.png",
    },
    {
      "title": "Smart Diagnosis",
      "subtitle":
      "Check your phone’s health instantly with\nour smart diagnostic system.",
      "image": "Images/onboarding/one.png",
    },
    {
      "title": "Sell or Exchange Effortlessly",
      "subtitle":
      "Get the best price for your old phone — \nfast, secure, and hassle-free.",
      "image": "Images/onboarding/two.png",
    },
  ];

  Future<void> _nextPage() async {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isOnboardingCompleted', true);

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const authPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tablet = isTablet(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: tablet ? 800 : double.infinity,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 30.h,
              ),
              child: Column(
                children: [
                  /// 🔹 Logo
                  Image.asset(
                    "Images/logo.png",
                    height: tablet ? 100.h : 120.h,
                  ),

                  SizedBox(height: 10.h),

                  /// 🔹 PageView
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _pages.length,
                      onPageChanged: (index) {
                        setState(() => _currentPage = index);
                      },
                      itemBuilder: (context, index) {
                        final page = _pages[index];

                        return tablet
                            ? _tabletLayout(page)
                            : _mobileLayout(page);
                      },
                    ),
                  ),

                  SizedBox(height: 20.h),

                  /// 🔹 Bottom Controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: List.generate(
                          _pages.length,
                              (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin:
                            EdgeInsets.symmetric(horizontal: 4.w),
                            width: _currentPage == index ? 12.w : 8.w,
                            height: _currentPage == index ? 12.w : 8.w,
                            decoration: BoxDecoration(
                              color: _currentPage == index
                                  ? AppColors.primary
                                  : Colors.white54,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),

                      GestureDetector(
                        onTap: _nextPage,
                        child: Container(
                          height: 45.h,
                          width: 45.w,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_forward,
                            size: 20.sp,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 🔹 Mobile Layout (same as yours)
  Widget _mobileLayout(Map<String, String> page) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            page["title"]!,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textWhite,
              fontSize: 22.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: 20.h),
        Container(
          height: 0.35.sh,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            image: DecorationImage(
              image: AssetImage(page["image"]!),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 20.h),
        Text(
          page["subtitle"]!,
          style: TextStyle(
            color: AppColors.textWhite,
            fontSize: 16.sp,
          ),
        ),
      ],
    );
  }

  /// 🔥 Tablet Layout (NEW)
  Widget _tabletLayout(Map<String, String> page) {
    return Row(
      children: [
        /// Image
        Expanded(
          child: Container(
            height: 300.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              image: DecorationImage(
                image: AssetImage(page["image"]!),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),

        SizedBox(width: 30.w),

        /// Text
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                page["title"]!,
                style: TextStyle(
                  color: AppColors.textWhite,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                page["subtitle"]!,
                style: TextStyle(
                  color: AppColors.textWhite,
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}