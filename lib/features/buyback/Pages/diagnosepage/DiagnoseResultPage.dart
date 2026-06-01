import 'dart:ui';
import 'package:buyback_module/features/buyback/Pages/diagnosepage/services/diagnose_api_service.dart';
import 'package:buyback_module/features/buyback/Pages/diagnosepage/services/submitBuybackAssessment.dart';
import 'package:buyback_module/features/buyback/Pages/diagnosepage/widgets/signuppopup.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Providers/DeviceVariantProvider.dart';
import '../../Providers/diagnose_result_provider.dart';
import '../../features/auth/model/CustomerResponseModel.dart';
import '../../features/auth/model/customer_model.dart';
import '../../features/auth/services/buyback_auth.dart';
import '../../features/auth/services/customer_response_service.dart';
import '../../features/auth/signup.dart';
import '../../features/intro/authpage.dart';
import '../../shared/Color/app_colors.dart';
import '../evaluationpage/Service/buyback_sell_now_service.dart';
import '../selectionPages/utils/booking_page.dart';
import 'diagnose_screen.dart';
import 'models/DiagnoseQuestion.dart';
import '../../features/auth/services/customer_service.dart'
    as gofix_service;

class DiagnoseResultPage extends StatefulWidget {
  const DiagnoseResultPage({super.key});

  @override
  State<DiagnoseResultPage> createState() => _DiagnoseResultPageState();
}

class _DiagnoseResultPageState extends State<DiagnoseResultPage> {
  bool isLoading = false;
  bool isFinishing = false;
  bool? shouldGoSignup;
  String? gofixCustomerId;
  String? gofixName;
  String? gofixEmail;
  String? buybackCustomerId;
  String? buybackMobile;
  final TextEditingController phoneController = TextEditingController();
  CustomerResponseModel? customerData;
  String assessmentName = '';
  @override
  void initState() {
    super.initState();
    _initCustomerData();
  }

  Future<void> sellNowApi() async {
    if (assessmentName.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Assessment Name Missing")));

      return;
    }
    final appointmentDate = DateFormat(
      'dd MMM yyyy',
    ).format(DateTime.now().add(const Duration(days: 2)));
    final sellNowResponse = await SellNowService.sellNow(
      assessmentName: assessmentName,
    );

    print("SELL NOW RESPONSE:");
    print(sellNowResponse);

    if (sellNowResponse["success"] == true) {
      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text(
              "Appointment Booking",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: const Text(
              "Do you want to book your device pickup appointment?",
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffFF4FD8),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);

                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => BookingSuccessPopup(
                      customerName: gofixName ?? "",
                      email: gofixEmail ?? '',
                      appointmentDate: appointmentDate,
                      appointmentTime: buybackMobile ?? '',
                      mobileNo: '',
                    ),
                  );
                },
                child: const Text(
                  "Book Now",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(sellNowResponse["message"].toString())),
      );
    }
  }

  Future<void> _initCustomerData() async {
    await getMobile(); // ✅ getMobile runs first
    final response = await CustomerService.validateCustomer(
      phoneController.text.trim(),
    );

    if (!mounted) return; // ✅ always guard after await

    setState(() {
      customerData = response;

      gofixCustomerId = response?.gofixResponse?.customerId?.toString();
      gofixName = response?.gofixResponse?.name;
      gofixEmail = response?.gofixResponse?.emailAddress;

      buybackCustomerId = response?.buybackResponse?.customerId?.toString();
      buybackMobile = response?.buybackResponse?.mobileNo;
    });
  }

  Future<void> getMobile() async {
    final prefs = await SharedPreferences.getInstance();
    final mobile = prefs.getString('mobile_number') ?? '';

    if (!mounted) return;

    phoneController.text = mobile;

    debugPrint("Mobile Number: $mobile");
  }

  Future<bool> checkCustomer() async {
    if (phoneController.text.trim().isEmpty) {
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => authPage(),
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

    // ── BOTH NULL → show signup dialog ──────────────────────────────────────
    if (gofix == null && buyback == null) {
      debugPrint("No data found → show signup dialog");
      final diagnoseResult = context.read<DiagnoseResultProvider>().result;

      showSignupPopup(
        context,
        imageUrl: diagnoseResult?.imageUrl ?? "",
        deviceName: diagnoseResult?.deviceName ?? "",
        deviceSpec: diagnoseResult?.deviceSpec ?? "",
        price: "XX,XXX",
      );

      if (shouldGoSignup == true) {
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => signup()),
          );
        }
      }

      if (mounted) setState(() => isFinishing = false);
      return false;
    }
    // ── GOFIX ONLY ───────────────────────────────────────────────────────────
    else if (gofix != null && buyback == null) {
      debugPrint("GoFix data found → syncing to BuyBack store");
      final customer = BuyBackCustomerModel(
        customerId: '',
        customerName: gofix.name ?? '',
        mobileNo: phoneController.text.trim(),
        emailId: gofix.emailAddress ?? '',
      );
      try {
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
    // ── BUYBACK ONLY ─────────────────────────────────────────────────────────
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
    // ── BOTH PRESENT ─────────────────────────────────────────────────────────
    else {
      debugPrint("Both GoFix and BuyBack data found → proceed directly");
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final result = context.watch<DiagnoseResultProvider>().result;
    final provider = context.read<DiagnoseResultProvider>();

    if (result == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF121212),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.health_and_safety_rounded,
                  size: 80,
                  color: Color(0xffFF4FD8),
                ),
                const SizedBox(height: 20),
                const Text(
                  'No Diagnostic Results Found',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Run a full device diagnosis to check hardware and functionality status.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffFF4FD8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => GoFixDiagnoseScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "Run Diagnostics",
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.textWhite,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final testedItems = result.items
        .where((e) => e.status != TestStatus.idle)
        .toList();

    final testedFailed = testedItems
        .where((e) => e.status == TestStatus.failed)
        .length;

    final testedAllPassed =
        testedItems.length == result.items.length && testedFailed == 0;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Diagnose Result',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          // ── Device Info Card ───────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: testedAllPassed
                      ? [const Color(0xFF123524), const Color(0xFF0B2016)]
                      : [const Color(0xFF3A1B1B), const Color(0xFF1F0D0D)],
                ),
                border: Border.all(
                  color: testedAllPassed
                      ? const Color(0xFF00E676)
                      : const Color(0xFFFF5252),
                  width: 1.3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: testedAllPassed
                        ? const Color(0xFF00E676).withOpacity(0.25)
                        : const Color(0xFFFF5252).withOpacity(0.25),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    height: 100,
                    color: Colors.grey[800],
                    child:
                        result.imageUrl != null && result.imageUrl!.isNotEmpty
                        ? Image.network(
                            result.imageUrl!,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) =>
                                Image.asset("Images/logo.png", height: 80),
                          )
                        : Image.asset("Images/logo.png", height: 80, width: 80),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          result.deviceName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          result.deviceSpec,
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${testedItems.length} of ${result.items.length} tests run',
                          style: const TextStyle(
                            color: Colors.white38,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              testedAllPassed
                                  ? Icons.check_circle
                                  : Icons.cancel,
                              color: testedAllPassed
                                  ? const Color(0xFF00E676)
                                  : const Color(0xFFFF5252),
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              testedAllPassed
                                  ? 'All Tests Passed'
                                  : testedFailed > 0
                                  ? '$testedFailed Test(s) Failed'
                                  : 'Tests Incomplete',
                              style: TextStyle(
                                color: testedAllPassed
                                    ? const Color(0xFF00E676)
                                    : const Color(0xFFFF5252),
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          if (testedItems.isEmpty)
            const Expanded(
              child: Center(
                child: Text(
                  'No tests have been run yet.',
                  style: TextStyle(color: Colors.white38, fontSize: 14),
                ),
              ),
            )
          else
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                itemCount: testedItems.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final item = testedItems[index];
                  final isFailed = item.status == TestStatus.failed;
                  final statusColor = item.status == TestStatus.passed
                      ? const Color(0xFF00E676)
                      : isFailed
                      ? const Color(0xFFFF5252)
                      : Colors.white38;
                  final statusIcon = item.status == TestStatus.passed
                      ? Icons.check_circle_rounded
                      : isFailed
                      ? Icons.cancel_rounded
                      : Icons.radio_button_unchecked;

                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(12),
                      border: isFailed
                          ? Border.all(
                              color: const Color(0xFFFF5252).withOpacity(0.4),
                            )
                          : null,
                    ),
                    child: Row(
                      children: [
                        Icon(item.icon, color: Colors.white54, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.label,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              if (item.note != null) ...[
                                const SizedBox(height: 2),
                                Text(
                                  item.note!,
                                  style: const TextStyle(
                                    color: Colors.white38,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        if (isFailed && provider.canRetest) ...[
                          GestureDetector(
                            onTap: () => provider.retest(item.label),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFFFF007F,
                                ).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: const Color(
                                    0xFFFF007F,
                                  ).withOpacity(0.5),
                                ),
                              ),
                              child: const Text(
                                'Retest',
                                style: TextStyle(
                                  color: Color(0xFFFF007F),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        Icon(statusIcon, color: statusColor, size: 22),
                      ],
                    ),
                  );
                },
              ),
            ),

          // ── Bottom Buttons ─────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            decoration: const BoxDecoration(
              color: Color(0xFF121212),
              border: Border(
                top: BorderSide(color: Color(0xFF2A2A2A), width: 1),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF444444)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Back',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: isFinishing
                        ? null
                        : () async {
                            setState(() => isFinishing = true);
                            try {
                              await checkCustomer();
                              // showSignupPopup(
                              //   context,
                              //   imageUrl: result.imageUrl ?? "",
                              //   deviceName: result.deviceName,
                              //   deviceSpec: result.deviceSpec,
                              //   price: "XX,XXX",
                              // );

                              final service = DiagnoseApiService();
                              final questions = await service.fetchQuestions();

                              final currentResult = context
                                  .read<DiagnoseResultProvider>()
                                  .result;

                              if (currentResult == null) {
                                debugPrint("No result found");
                                return;
                              }

                              List<Map<String, String>> diagnostics = [];

                              String statusToApi(String status) {
                                switch (status.toLowerCase()) {
                                  case "passed":
                                    return "Pass";
                                  case "failed":
                                    return "Fail";
                                  default:
                                    return "Fail";
                                }
                              }

                              for (var q in questions) {
                                String enumName = q.questionText
                                    .toLowerCase()
                                    .replaceAll(" ", "")
                                    .replaceAll("-", "");

                                switch (enumName) {
                                  case "screen":
                                    enumName = "singletouch";
                                    break;
                                  case "powerbutton":
                                    enumName = "screenlock";
                                    break;
                                  case "proximitysensor":
                                    enumName = "proximity";
                                    break;
                                  case "earreceiver":
                                    enumName = "earreceiver";
                                    break;
                                  case "volumebuttons":
                                    enumName = "volumekey";
                                    break;
                                  case "flashlight":
                                    enumName = "flashlight";
                                    break;
                                }

                                TestType? matchedType;
                                for (var type in TestType.values) {
                                  if (type.name.toLowerCase() == enumName) {
                                    matchedType = type;
                                    break;
                                  }
                                }

                                if (matchedType == null) continue;

                                final matchedItem = currentResult.items
                                    .firstWhere((e) => e.type == matchedType);

                                diagnostics.add({
                                  "test_code": q.questionName,
                                  "test_name": q.questionText,
                                  "result": statusToApi(
                                    matchedItem.status.name,
                                  ),
                                });
                              }

                              debugPrint("===== DIAGNOSTICS =====");
                              debugPrint(diagnostics.toString());

                              final variant = context
                                  .read<DeviceVariantProvider>()
                                  .selectedVariant;

                              if (variant == null) {
                                debugPrint("No variant selected");
                                return;
                              }

                              final prefs =
                                  await SharedPreferences.getInstance();
                              final imei = prefs.getString("imei1") ?? "";

                              debugPrint("IMEI => $imei");

                              final BuybackAssessmentResponse? apiResult =
                                  await submitBuybackAssessment(
                                    itemCode: variant.itemCode,
                                    itemName: variant.itemName,
                                    brand: variant.brand,
                                    customer: gofixCustomerId ?? '',
                                    customerName: gofixName ?? "",
                                    mobileNo: buybackMobile ?? '',
                                    email: gofixEmail ?? '',
                                    imeiSerial: imei,
                                    diagnostics: diagnostics,
                                    ch_customer_id: buybackCustomerId ?? '',
                                  );

                              if (apiResult == null) {
                                debugPrint("API RESULT NULL");
                                return;
                              }
                              // ✅ Store assessmentName here
                              setState(() {
                                assessmentName = apiResult.assessmentName;
                              });

                              if (!mounted) return;

                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  return Dialog(
                                    backgroundColor: const Color(0xFF1A1719),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(24),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.currency_rupee,
                                            color: Colors.green,
                                            size: 50,
                                          ),
                                          const SizedBox(height: 16),

                                          const Text(
                                            "Estimated Price",
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 18,
                                            ),
                                          ),

                                          const SizedBox(height: 12),

                                          Text(
                                            "₹ ${apiResult.calculatedPrice.toStringAsFixed(0)}",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 34,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),

                                          const SizedBox(height: 10),

                                          const Text(
                                            'This price is not final it is an approximate value you can get maximum for this device. The final price will be quoted at the end of this section',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white54,
                                              fontSize: 14,
                                            ),
                                          ),

                                          const SizedBox(height: 24),

                                          Row(
                                            children: [
                                              Expanded(
                                                child: SizedBox(
                                                  height: 48,
                                                  child: OutlinedButton(
                                                    style: OutlinedButton.styleFrom(
                                                      side: const BorderSide(
                                                        color: Colors.white24,
                                                      ),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              14,
                                                            ),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text(
                                                      "Cancel",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              const SizedBox(width: 12),

                                              Expanded(
                                                child: SizedBox(
                                                  height: 48,
                                                  child: ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                          const Color(
                                                            0xffFF4FD8,
                                                          ),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              14,
                                                            ),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.pop(
                                                        context,
                                                      ); // ✅ close popup first
                                                      sellNowApi(); // ✅ then call sellNowApi
                                                    },
                                                    child: const Text(
                                                      "Continue",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            } catch (e) {
                              debugPrint("ERROR => $e");
                            } finally {
                              if (mounted) setState(() => isFinishing = false);
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF007F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Sell Your Device',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
