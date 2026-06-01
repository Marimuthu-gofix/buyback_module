import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import '../../Pages/diagnosepage/DiagnoseResultPage.dart';
import '../../Pages/evaluationpage/final_price_page.dart';
import '../../Pages/home.dart';
import '../../shared/Color/app_colors.dart';
import 'model/selected_mobile_model.dart';
import 'services/auth_service.dart';

class OtpVerificationPage extends StatefulWidget {
  final String phoneNumber;
  final SelectedMobileModel? mobileData;

  const OtpVerificationPage({Key? key, required this.phoneNumber,this.mobileData})
      : super(key: key);

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final _otpController = TextEditingController();
  bool _isLoading = false;
  bool _isResending = false;

  int _resendSeconds = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _resendSeconds = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSeconds > 0) {
        setState(() => _resendSeconds--);
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _resendOtp() async {
    setState(() => _isResending = true);
    final res = await AuthService.requestOtp(widget.phoneNumber);
    setState(() => _isResending = false);

    if (res["status"] == true) {
      _startTimer();
      _showSnack("OTP resent successfully");
    } else {
      _showSnack(res["message"] ?? "Failed to resend OTP");
    }
  }

  Future<void> _verifyOtp() async {
    final otp = _otpController.text.trim();

    if (otp.length != 4) {
      _showSnack("Please enter the 4-digit OTP");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final res = await AuthService.verifyOtp(
        phone: widget.phoneNumber,
        otp: otp,
      );

      if (res["status"] == true) {
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //       builder: (_) => home()),
        // );
        if (widget.mobileData != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => FinalPricePage(
                mobileData: widget.mobileData!,
              ),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) =>  DiagnoseResultPage(),
            ),
          );
        }
      } else {
        _showSnack(res["message"] ?? "Invalid OTP");
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            children: [
              /// 🔹 Back
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C1C1E),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 18.sp,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),

              SizedBox(height: 30.h),

              /// 🔹 Logo
              Image.asset(
                'Images/logo.png',
                height: 160.h,
              ),

              SizedBox(height: 30.h),

              /// 🔹 Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1C1E),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Column(
                  children: [
                    Text(
                      'VERIFY OTP',
                      style: TextStyle(
                        color: AppColors.textWhite,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 10.h),

                    Text(
                      "OTP sent to ${widget.phoneNumber}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textWhite,
                        fontSize: 13.sp,
                      ),
                    ),

                    SizedBox(height: 25.h),

                    /// 🔹 OTP BOXES
                    Pinput(
                      length: 5,
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      defaultPinTheme: PinTheme(
                        height: 50.h,
                        width: 50.w,
                        textStyle: TextStyle(
                          fontSize: 18.sp,
                          color: AppColors.textBlack,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.textField,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),

                    SizedBox(height: 30.h),

                    /// 🔹 BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 48.h,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _verifyOtp,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: _isLoading
                                ? null
                                : LinearGradient(
                              colors: [
                                AppColors.primary,
                                AppColors.primary,
                              ],
                            ),
                            color: _isLoading ? Colors.grey : null,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Center(
                            child: _isLoading
                                ? SizedBox(
                              height: 20.h,
                              width: 20.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor:
                                AlwaysStoppedAnimation(
                                    Colors.white),
                              ),
                            )
                                : Text(
                              "CONTINUE",
                              style: TextStyle(
                                color: AppColors.textWhite,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20.h),

                    /// 🔹 RESEND
                    _resendSeconds > 0
                        ? Text(
                      "Resend OTP in ${_resendSeconds}s",
                      style: TextStyle(
                        color: AppColors.textWhite,
                        fontSize: 12.sp,
                      ),
                    )
                        : TextButton(
                      onPressed:
                      _isResending ? null : _resendOtp,
                      child: _isResending
                          ? SizedBox(
                        height: 18.h,
                        width: 18.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                          AlwaysStoppedAnimation(
                              AppColors.primary),
                        ),
                      )
                          : Text(
                        "Resend OTP",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}