import 'package:buyback_module/features/buyback/features/auth/services/buyback_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../features/auth/services/auth_service.dart';
import '../../shared/Color/app_colors.dart';
import 'OtpVerificationPage.dart';
import 'login.dart';
import 'model/CustomerResponseModel.dart';
import 'model/customer_model.dart';
import 'model/selected_mobile_model.dart';
import 'services/customer_service.dart';

class IndianPhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue) {
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

class signup extends StatefulWidget {
  final SelectedMobileModel? mobileData;
  const signup({super.key,
    this.mobileData,});

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  bool _agreeTerms = false;
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _handleSignup() async {

    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    if (!_agreeTerms) {
      return _showSnack(
        "Please agree to the Terms & Conditions",
      );
    }

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _mobileController.text.trim();

    setState(() => _isLoading = true);

    try {

      final exists =
      await AuthService.isCustomerExists(phone);

      if (exists) {

        _showSnack(
          "User already exists. Please sign in.",
        );

        return;
      }

      /// 👉 CREATE GOFIX CUSTOMER

      final customer = Customer(
        customerId: 0,
        customerName: name,
        phoneNo: phone,
        alternatePhoneNo: '',
        emailAddress: email,
        address: null,
        ipAddress: '',
      );

      final service = CustomerService();

      final customerId =
      await service.saveCustomer(customer);

      if (customerId != null) {

        print("GOFIX CUSTOMER CREATED");
        print("GOFIX CUSTOMER ID : $customerId");

        /// 👉 CREATE BUYBACK CUSTOMER

        final buyBackCustomer =
        BuyBackCustomerModel(
          customerId: '',
          customerName: name,
          mobileNo: phone,
          emailId: email,
        );

        final buyBackResponse =
        await BuyBackCustomerService
            .saveCustomer(
          buyBackCustomer,
        );

        if (buyBackResponse != null &&
            buyBackResponse.success) {

          print("BUYBACK CUSTOMER CREATED");

          print(
            "BUYBACK CUSTOMER ID : ${buyBackResponse.customer}",
          );

          print(
            "ACTION : ${buyBackResponse.action}",
          );

          /// 👉 OTP PAGE

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  OtpVerificationPage(
                    phoneNumber: phone,
                    mobileData: widget.mobileData,
                  ),
            ),
          );

        } else {

          print(
            "BUYBACK CUSTOMER CREATION FAILED",
          );

          _showSnack(
            "BuyBack customer creation failed",
          );
        }

      } else {

        print("GOFIX CUSTOMER CREATION FAILED");

        _showSnack(
          "Failed to register customer.",
        );
      }

    } finally {

      setState(() => _isLoading = false);
    }
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      counterText: "",
      filled: true,
      fillColor: AppColors.textField,
      hintText: hint,
      hintStyle: TextStyle(fontSize: 14.sp, color: AppColors.textPrimary),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 14.h,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide.none,
      ),
    );
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

              SizedBox(height: 10.h),

              /// Logo
              Image.asset(
                'Images/logo.png',
                height: 170.h,
              ),

              SizedBox(height: 20.h),

              ///  Card
              Container(
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
                        'Register',
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textWhite,
                        ),
                      ),

                      SizedBox(height: 6.h),

                      Text(
                        'Create your account',
                        style: TextStyle(
                          color: AppColors.textWhite,
                          fontSize: 13.sp,
                        ),
                      ),

                      SizedBox(height: 20.h),

                      /// Name
                      TextFormField(
                        controller: _nameController,
                        validator: (v) =>
                        v!.isEmpty ? "Name is required" : null,
                        style: TextStyle(fontSize: 14.sp),
                        decoration: _inputDecoration("Name"),
                      ),

                      SizedBox(height: 12.h),

                      /// Email
                      TextFormField(
                        controller: _emailController,
                        validator: (v) {
                          if (v!.isEmpty) return "Email required";
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                              .hasMatch(v)) {
                            return "Invalid email";
                          }
                          return null;
                        },
                        style: TextStyle(fontSize: 14.sp),
                        decoration: _inputDecoration("Email Address"),
                      ),

                      SizedBox(height: 12.h),

                      /// Phone
                      TextFormField(
                        controller: _mobileController,
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        inputFormatters: [IndianPhoneFormatter()],
                        onChanged: (v){
                          if (v.length == 10){
                            FocusScope.of(context).unfocus();
                          }
                        },
                        validator: (v) {
                          if (v!.isEmpty) return "Mobile required";
                          if (!RegExp(r'^[6-9]\d{9}$').hasMatch(v)) {
                            return "Invalid number";
                          }
                          return null;
                        },
                        style: TextStyle(fontSize: 14.sp),
                        decoration: _inputDecoration("Mobile Number")
                            .copyWith(
                          prefixText: "+91 ",
                          prefixStyle: TextStyle(fontSize: 14.sp),
                        ),
                      ),

                      SizedBox(height: 10.h),

                      /// Terms
                      Row(
                        children: [
                          Checkbox(
                            value: _agreeTerms,
                            activeColor: AppColors.primary,
                            onChanged: (v) =>
                                setState(() => _agreeTerms = v!),
                          ),
                          Expanded(
                            child: Wrap(
                              children: [
                                Text(
                                  'I agree to the ',
                                  style: TextStyle(fontSize: 12.sp,color: AppColors.textWhite),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (_) =>
                                    //         TermsAndConditionsPage(),
                                    //   ),
                                    // );
                                  },
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
                          )
                        ],
                      ),

                      SizedBox(height: 20.h),

                      /// Signup Button
                      SizedBox(
                        width: double.infinity,
                        height: 48.h,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleSignup,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(12.r),
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
                              color:
                              _isLoading ? Colors.grey : null,
                              borderRadius:
                              BorderRadius.circular(12.r),
                            ),
                            child: Center(
                              child: _isLoading
                                  ? SizedBox(
                                width: 20.w,
                                height: 20.h,
                                child:
                                CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor:
                                  AlwaysStoppedAnimation(
                                      AppColors.textWhite),
                                ),
                              )
                                  : Text(
                                'SIGN UP',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight:
                                  FontWeight.bold,
                                  color: AppColors.textWhite,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 20.h),

                      /// Login Link
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          Text(
                            "I’m already a member. ",
                            style: TextStyle(fontSize: 12.sp,color: AppColors.textWhite),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                    Login(
                                      mobileData: widget.mobileData,
                                    )),
                              );
                            },
                            child: Text(
                              "Sign in",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      )
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