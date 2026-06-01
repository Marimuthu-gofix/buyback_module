import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import '../../Pages/evaluationpage/final_price_page.dart';
import '../../shared/Color/app_colors.dart';
import 'OtpVerificationPage.dart';
import 'model/selected_mobile_model.dart';
import 'services/auth_service.dart';
import 'signup.dart';

class IndianPhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    String text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (text.startsWith('91') && text.length > 10) {
      text = text.substring(2);
    }

    if (text.length > 10) {
      text = text.substring(0, 10);
    }

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

class Login extends StatefulWidget {
  final SelectedMobileModel? mobileData;
  const Login({super.key,
    this.mobileData,});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _mobileController = TextEditingController();

  bool _agreeTerms = false;
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    if (!_agreeTerms) {
      _showSnack("Please agree to the Terms & Conditions");
      return;
    }

    final phone = _mobileController.text.trim();

    setState(() => _isLoading = true);

    try {
      /// 🔥 TEST USER FLOW (Skip OTP)
      if (phone == "9999999999") {
        final response = await AuthService.getCustomerByPhone(phone);

        if (response != null) {
          // ✅ Already saved inside service
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (_) => FinalPricePage(
                  mobileData: widget.mobileData!,
                )),
          );
          return;
        } else {
          _showSnack("Test user not found");
          return;
        }
      }

      /// 🔁 NORMAL FLOW
      final exists = await AuthService.isCustomerExists(phone);

      if (!exists) {
        _showSnack("User not found. Please sign up first.");
        return;
      }

      final response = await AuthService.requestOtp(phone);

      if (response["status"] == true) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                OtpVerificationPage(phoneNumber: phone,mobileData: widget.mobileData,),
          ),
        );
      } else {
        _showSnack(response["message"] ?? "Failed to send OTP");
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
              /// Back Button
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

              SizedBox(height: 50.h),

              /// Logo
              Image.asset(
                'Images/logo.png',
                height: 180.h,
              ),

              SizedBox(height: 30.h),

              /// Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text(
                        'Welcome Back',
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textWhite,
                        ),
                      ),

                      SizedBox(height: 6.h),

                      Text(
                        'Login to your account',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13.sp,
                        ),
                      ),

                      SizedBox(height: 20.h),

                      /// Mobile Field
                      TextFormField(
                        controller: _mobileController,
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        inputFormatters: [IndianPhoneFormatter()],
                        onChanged: (value){
                          if (value.length == 10){
                            FocusScope.of(context).unfocus();
                          }
                        },
                        style: TextStyle(
                          color: AppColors.textBlack,
                          fontSize: 14.sp,
                        ),
                        validator: (value) {
                          final phone = value?.trim() ?? "";

                          if (phone.isEmpty) {
                            return "Mobile number is required";
                          }

                          if (!RegExp(r'^[6-9]\d{9}$').hasMatch(phone)) {
                            return "Enter valid mobile number";
                          }

                          return null;
                        },
                        decoration: InputDecoration(
                          counterText: "",
                          filled: true,
                          fillColor: AppColors.textField,
                          hintText: 'Mobile Number',
                          hintStyle: TextStyle(fontSize: 14.sp),
                          prefixText: "+91  ",
                          prefixStyle: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.textBlack,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 14.h,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      SizedBox(height: 10.h),

                      /// Terms
                      Row(
                        children: [
                          Checkbox(
                            activeColor: AppColors.primary,
                            value: _agreeTerms,
                            onChanged: (v) =>
                                setState(() => _agreeTerms = v!),
                          ),
                          Expanded(
                            child: Wrap(
                              children: [
                                Text(
                                  'I agree to the ',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12.sp,
                                  ),
                                ),
                                GestureDetector(
                                  // onTap: () {
                                  //   Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //       builder: (context) =>
                                  //           TermsAndConditionsPage(),
                                  //     ),
                                  //   );
                                  // },
                                  child: Text(
                                    'Terms & Conditions',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 12.sp,
                                      decoration:
                                      TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 20.h),

                      /// Login Button
                      SizedBox(
                        width: double.infinity,
                        height: 48.h,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: _isLoading ? null : LinearGradient(
                                colors: [
                                  AppColors.primary,
                                  AppColors.primary,
                                ],
                              ),
                              color: _isLoading ? Colors.grey : null,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Center(
                              child: _isLoading ? SizedBox(
                                height: 22.h,
                                width: 22.w,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  valueColor: AlwaysStoppedAnimation(
                                      Colors.white
                                  ),
                                ),
                              ) : Text( "LOGIN", style: TextStyle(
                                color: AppColors.textWhite,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,),
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 20.h),

                      /// Sign Up
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don’t have an account? ",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12.sp,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                   signup(
                                    mobileData: widget.mobileData,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}