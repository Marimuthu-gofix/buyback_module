import 'dart:ui';
import 'package:buyback_module/features/buyback/Pages/evaluationpage/widgets/evaluation_header_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Providers/evaluation_provider.dart';
import '../../features/auth/model/CustomerResponseModel.dart';
import '../../features/auth/model/customer_model.dart';
import '../../features/auth/model/selected_mobile_model.dart';
import '../../features/auth/services/buyback_auth.dart';
import '../../features/auth/services/customer_response_service.dart';
import '../../features/auth/services/customer_service.dart'
    as gofix_service;
import '../../features/auth/signup.dart';
import '../../features/intro/authpage.dart';
import 'final_price_page.dart';

class WarrantyConditionPage extends StatefulWidget {
  final Map<int, dynamic> previousAnswers;
  final String itemname;
  final String imageUrl;
  final double progress;

  final String itemCode;
  final String brand;
  final String imeiSerial;
  final String company;
  final String itemGroup;
  final String variant;

  const WarrantyConditionPage({
    super.key,
    required this.previousAnswers,
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
  State<WarrantyConditionPage> createState() => _WarrantyConditionPageState();
}

class _WarrantyConditionPageState extends State<WarrantyConditionPage> {
  String? selectedValue;
  bool isFinishing = false;

  final TextEditingController phoneController = TextEditingController();
  CustomerResponseModel? customerData;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await getMobile();

      if (mounted) {
        context.read<EvaluationProvider>().loadQuestions(widget.itemCode);
      }
    });
  }

  // FIX 3: getMobile() is now properly awaited in initState via microtask.
  Future<void> getMobile() async {
    final prefs = await SharedPreferences.getInstance();
    final mobile = prefs.getString('mobile_number') ?? '';
    if (mounted) {
      phoneController.text = mobile;
    }
    debugPrint("Mobile Number: $mobile");
  }

  /// Returns true if the user can proceed to FinalPricePage.
  /// Returns false if flow was interrupted (e.g. signup opened, phone empty).
  Future<bool> checkCustomer() async {
    // FIX 2: Provide user-facing feedback when phone is empty.
    if (phoneController.text.trim().isEmpty) {
      if (mounted) {
        final mobileData = SelectedMobileModel(
          itemname: widget.itemname,
          imageUrl: widget.imageUrl,
          itemCode: widget.itemCode,
          brand: widget.brand,
          imeiSerial: widget.imeiSerial,
          company: widget.company,
          itemGroup: widget.itemGroup,
          progress: 0,
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => authPage(mobileData: mobileData),
          ),
        );
      }
      return false;
    }

    setState(() => isLoading = true);

    CustomerResponseModel? result;
    try {
      result = await CustomerService.validateCustomer(
        phoneController.text.trim(),
      );
    } catch (e) {
      // FIX 5: Individual error handling on the API validation call.
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to validate customer: $e")),
        );
      }
      return false;
    } finally {
      if (mounted) setState(() => isLoading = false);
    }

    customerData = result;

    final gofix = result?.gofixResponse;
    final buyback = result?.buybackResponse;

    debugPrint("GoFix message: ${result?.gofixMessage}");
    debugPrint("BuyBack message: ${result?.buybackMessage}");

    // ── BOTH NULL → show signup dialog ────────────────────────────────────
    if (gofix == null && buyback == null) {
      debugPrint("No data found → show signup dialog");

      final shouldGoSignup = await showGeneralDialog<bool>(
        context: context,
        barrierDismissible: false,
        barrierLabel: "Signup",
        barrierColor: Colors.black.withOpacity(0.4),
        pageBuilder: (context, animation, secondaryAnimation) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1719),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Product card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xffFF4FD8),
                            width: 1.2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 110,
                              width: 90,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Image.network(
                                widget.imageUrl,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.itemname,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    widget.variant,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    "Selling Price",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    "₹ XX,XXX",
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFFF6464),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.lock, color: Color(0xffFF4FD8), size: 15),
                          SizedBox(width: 10),
                          Text(
                            "Signup to unlock the best price",
                            style: TextStyle(
                              color: Color(0xffFF4FD8),
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffFF4FD8),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text(
                            "Signup",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );

      if (shouldGoSignup == true) {
        final mobileData = SelectedMobileModel(
          itemname: widget.itemname,
          imageUrl: widget.imageUrl,
          itemCode: widget.itemCode,
          brand: widget.brand,
          imeiSerial: widget.imeiSerial,
          company: widget.company,
          itemGroup: widget.itemGroup,
          progress: 0,
        );
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => signup(mobileData: mobileData),
            ),
          );
        }
      }

      // FIX 1: Explicitly reset isFinishing before returning false so the
      // button is re-enabled immediately when the signup dialog is dismissed.
      if (mounted) setState(() => isFinishing = false);
      return false;
    }
    // ── GOFIX ONLY ────────────────────────────────────────────────────────
    // NOTE: GoFix-only customers are saved to BuyBack's service so they
    // exist in the BuyBack system for subsequent lookups. Intentional
    // cross-system sync — do not swap these branches.
    else if (gofix != null && buyback == null) {
      debugPrint("GoFix data found → syncing to BuyBack store");
      final customer = BuyBackCustomerModel(
        customerId: '',
        customerName: gofix.name ?? '',
        mobileNo: phoneController.text.trim(),
        emailId: gofix.emailAddress ?? '',
      );
      try {
        // FIX 5: Individual error handling on the save call.
        await BuyBackCustomerService.saveCustomer(customer);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to save customer (GoFix): $e")),
          );
        }
        return false;
      }
      return true;
    }
    // ── BUYBACK ONLY ──────────────────────────────────────────────────────
    // NOTE: BuyBack-only customers are saved to GoFix's service so they
    // exist in the GoFix system for subsequent lookups. Intentional
    // cross-system sync — do not swap these branches.
    else if (gofix == null && buyback != null) {
      debugPrint("BuyBack data found → syncing to GoFix store");
      final customer = Customer(
        customerId: 0,
        customerName: buyback.customerName ?? '',
        phoneNo: phoneController.text.trim(),
        alternatePhoneNo: '',
        emailAddress: buyback.emailId ?? '',
        ipAddress: '',
      );
      try {
        // FIX 5: Individual error handling on the save call.
        final customerService = gofix_service.CustomerService();
        await customerService.saveCustomer(customer);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to save customer (BuyBack): $e")),
          );
        }
        return false;
      }
      return true;
    }
    // ── BOTH PRESENT → no save needed ────────────────────────────────────
    else {
      debugPrint("Both GoFix and BuyBack data found → proceed directly");
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EvaluationProvider>();
    final warrantyList = [...provider.warrantyQuestions];
    warrantyList.sort((a, b) => a.questionName.compareTo(b.questionName));

    if (provider.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (warrantyList.isEmpty) {
      return const Scaffold(body: Center(child: Text("No Warranty Found")));
    }

    return WillPopScope(
      onWillPop: () async {
        context.read<EvaluationProvider>().clearSection("Warranty");
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color(0xff1E1E1E),
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
              context.read<EvaluationProvider>().clearSection("Warranty");
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
              EvaluationHeaderCard(
                itemname: widget.itemname,
                imageUrl: widget.imageUrl,
                progress: widget.progress,
                variant: "",
                selectedAnswers: {},
              ),
              const SizedBox(height: 20),
              const Text(
                "Warranty Condition",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              ...warrantyList.map((q) {
                final value = q.questionName;
                final displayText = q.questionText;
                return _WarrantyOptionTile(
                  title: displayText,
                  isSelected: selectedValue == value,
                  onTap: () {
                    setState(() => selectedValue = value);
                    context.read<EvaluationProvider>().clearSection("Warranty");
                    context.read<EvaluationProvider>().updateAnswer(
                      "Warranty",
                      q.questionText,
                      q.questionName,
                      q.options.isNotEmpty
                          ? q.options.first.optionValue
                          : q.questionName,
                      q.options.isNotEmpty
                          ? q.options.first.optionLabel
                          : q.questionText,
                    );
                  },
                );
              }).toList(),
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              height: 55,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isFinishing
                    ? null
                    : () async {
                        if (selectedValue == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Please select a warranty condition",
                              ),
                            ),
                          );
                          return;
                        }

                        setState(() => isFinishing = true);

                        try {
                          final canContinue = await checkCustomer();

                          // checkCustomer() resets isFinishing itself on the
                          // signup-dismissed path (FIX 1), so guard with mounted.
                          if (!mounted) return;
                          if (!canContinue) return;

                          final mobileData = SelectedMobileModel(
                            itemname: widget.itemname,
                            imageUrl: widget.imageUrl,
                            itemCode: widget.itemCode,
                            brand: widget.brand,
                            imeiSerial: widget.imeiSerial,
                            company: widget.company,
                            itemGroup: widget.itemGroup,
                            progress: 0,
                          );

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  FinalPricePage(mobileData: mobileData),
                            ),
                          );
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Unexpected error: $e")),
                            );
                          }
                        } finally {
                          if (mounted) setState(() => isFinishing = false);
                        }
                      },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  disabledBackgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: isFinishing
                        ? null
                        : const LinearGradient(
                            colors: [Color(0xffFF4FD8), Color(0xffFF4FD8)],
                          ),
                    color: isFinishing ? Colors.grey : null,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: isFinishing
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text(
                            "Finish →",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Warranty tile ─────────────────────────────────────────────────────────────

class _WarrantyOptionTile extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _WarrantyOptionTile({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xffFF4FD8) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xffFF4FD8) : Colors.grey,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        height: 10,
                        width: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xffFF4FD8),
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
