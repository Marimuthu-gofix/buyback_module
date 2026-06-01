import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Pages/home.dart';
import '../../shared/Color/app_colors.dart';
import '../auth/login.dart';
import '../auth/model/selected_mobile_model.dart';
import '../auth/signup.dart';

class authPage extends StatefulWidget {
  final SelectedMobileModel? mobileData;
  const authPage({super.key,this.mobileData,});

  @override
  State<authPage> createState() => _authPageState();
}

class _authPageState extends State<authPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 30.h,
          ),
          child: SizedBox(
            width: double.maxFinite,
            child: Column(
              children: [
                /// Logo
                Image.asset(
                  "Images/logo.png",
                  height: 200.h,
                ),

                SizedBox(height: 20.h),

                /// Title
                Text(
                  "Let’s Get Started!",
                  style: TextStyle(
                    color: AppColors.textWhite,
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                SizedBox(height: 15.h),

                /// Subtitle
                Text(
                  "Join GoFix today and give your smartphone\nthe care it deserves.",
                  style: TextStyle(
                    color: AppColors.textWhite,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 40.h),

                /// LOGIN BUTTON
                SizedBox(
                  height: 55.h,
                  width: 260.w,
                  child: MaterialButton(
                    color: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                      side: BorderSide(color: AppColors.primary),
                    ),
                    elevation: 0,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Login(mobileData: widget.mobileData)),
                      );
                    },
                    child: Text(
                      "LOG IN",
                      style: TextStyle(
                        color: AppColors.textWhite,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 25.h),

                /// SIGNUP BUTTON
                SizedBox(
                  height: 55.h,
                  width: 260.w,
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                      side: BorderSide(color: AppColors.primary),
                    ),
                    elevation: 0,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => signup(mobileData: widget.mobileData)),
                      );
                    },
                    child: Text(
                      "SIGN UP",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                // SizedBox(height: 25.h),

                /// Guest Login
                // GestureDetector(
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) =>
                //             home(),
                //       ),
                //     );
                //   },
                //   child: Text(
                //     "Continue as Guest",
                //     style: TextStyle(
                //       color: AppColors.textWhite,
                //       fontSize: 14.sp,
                //       fontWeight: FontWeight.w500,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}