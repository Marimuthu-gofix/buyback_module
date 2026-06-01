import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Pages/home.dart';
import '../../shared/Color/app_colors.dart';
import 'onboarding.dart';

class intro extends StatefulWidget {
  const intro({super.key});

  @override
  State<intro> createState() => _introState();
}

class _introState extends State<intro> {
  @override
  void initState() {
    super.initState();
    _navigateBasedOnLogin();
  }

  Future<void> _navigateBasedOnLogin() async {
    // Reduced to 1.5s — 2s feels slow and risks iOS killing the launch
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final hasCustomerId = prefs.containsKey('customerId');
      final isOnboardingCompleted =
          prefs.getBool('isOnboardingCompleted') ?? false;

      if (!mounted) return;

      if (hasCustomerId || isOnboardingCompleted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => home(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) =>  onboarding()),
        );
      }
    } catch (e) {
      debugPrint('Navigation error: $e');
      // Fallback: go to onboarding so user never gets stuck
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) =>  onboarding()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Image.asset(
          'Images/logo.png',
          height: 250.h,
          // Fallback if image fails to load
          errorBuilder: (context, error, stackTrace) {
            debugPrint('Logo load error: $error');
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}