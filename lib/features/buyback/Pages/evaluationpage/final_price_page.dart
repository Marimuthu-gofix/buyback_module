import 'package:buyback_module/features/buyback/Pages/evaluationpage/widgets/evaluation_header_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Providers/evaluation_provider.dart';
import '../../features/auth/model/CustomerResponseModel.dart';
import '../../features/auth/model/selected_mobile_model.dart';
import '../../features/auth/services/customer_response_service.dart';
import '../../shared/widgets/FaqSection.dart';
import '../selectionPages/component/RatingAndTrustCard.dart';
import '../selectionPages/utils/booking_page.dart';
import 'Service/buyback_sell_now_service.dart';
import 'Service/buyback_submit_service.dart';
import 'model/buyback_assessment_model.dart';

class FinalPricePage extends StatefulWidget {
  final SelectedMobileModel? mobileData;
  const FinalPricePage({
    super.key,
    this.mobileData,
  });

  @override
  State<FinalPricePage> createState() => _FinalPricePageState();
}

class _FinalPricePageState extends State<FinalPricePage> {
  Map<String, dynamic>? result;
  CustomerResponseModel? customerData; // 👈 add this
  bool isLoading = false;
  String assessmentName = "";
  final TextEditingController phoneController = TextEditingController();
  String? gofixCustomerId;
  String? gofixName;
  String? gofixEmail;
  String? buybackCustomerId;
  String? buybackMobile;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      try {
        setState(() => isLoading = true);

        await getMobile();

          final response = await CustomerService.validateCustomer(
            phoneController.text.trim(),
          );

        customerData = response;

        gofixCustomerId =
            response?.gofixResponse?.customerId?.toString();

        gofixName =
            response?.gofixResponse?.name;

        gofixEmail =
            response?.gofixResponse?.emailAddress;

        buybackCustomerId =
            response?.buybackResponse?.customerId?.toString();

        buybackMobile =
            response?.buybackResponse?.mobileNo;

        await submitEvaluation();

      } catch (e) {
        debugPrint("Error: $e");
      } finally {
        if (mounted) {
          setState(() => isLoading = false);
        }
      }
    });
  }

  Future<void> getMobile() async {
    final prefs = await SharedPreferences.getInstance();
    final mobile = prefs.getString('mobile_number') ?? '';
    if (mounted) {
      phoneController.text = mobile;
    }
    debugPrint("Mobile Number: $mobile");
  }
  /// =========================
  /// SUBMIT ASSESSMENT API
  /// =========================
  Future<void> submitEvaluation() async {
    final provider = context.read<EvaluationProvider>();

    setState(() {
      isLoading = true;
    });

    List<ResponseModel> responses = [];

    provider.sections.forEach((section, questionList) {
      for (var item in questionList) {
        responses.add(
          ResponseModel(
            questionId: item["question_id"] ?? "",
            answerValue: item["answer_value"] ?? "",
          ),
        );
      }
    });

    print("RESPONSES:");
    print(responses.map((e) => e.toJson()).toList());

    final apiResult = await BuybackPostService.submitEvaluation(
      itemCode: widget.mobileData?.itemCode ?? '',
      itemName: widget.mobileData?.itemname ?? '',
      brand: widget.mobileData?.brand ?? '',
      imeiSerial: widget.mobileData?.imeiSerial ?? '',
      company: widget.mobileData?.company ?? '',
      itemGroup: widget.mobileData?.itemGroup ?? '',
      responses: responses,
      customer: gofixCustomerId ?? '',
      customerName: gofixName ?? "",
      mobileNo: buybackMobile ?? '',
      email: gofixEmail ?? '',
        chCustomerId:buybackCustomerId ??''
    );

    print("ASSESSMENT API RESULT:");
    print(apiResult);

    /// SHOW SIMPLE MESSAGE ONLY
    if (apiResult != null && apiResult["error"] != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Unable to fetch price")));
    }

    setState(() {
      result = apiResult;

      assessmentName = apiResult != null
          ? (apiResult["assessment_name"] ?? "").toString()
          : "";

      isLoading = false;
    });
  }

  /// =========================
  /// SELL NOW API
  /// =========================
  Future<void> sellNowApi() async {
    if (assessmentName.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Assessment Name Missing")));

      return;
    }
    final appointmentDate = DateFormat(
      'dd MMM yyyy',
    ).format(
      DateTime.now().add(
        const Duration(days: 2),
      ),
    );
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
                      customerName:  gofixName ?? "",
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1E1E1E),

      /// =========================
      /// APP BAR
      /// =========================
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
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

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              /// =========================
              /// PRICE CARD
              /// =========================
              EvaluationHeaderCard(
                itemname: widget.mobileData?.itemname ?? '',
                imageUrl: widget.mobileData?.imageUrl ?? '',

                variant: "",

                selectedAnswers: {},

                price: "₹ ${result?["calculated_price"] ?? 0}",

                onSellNow: sellNowApi,
                progress: 0,
              ),

              const SizedBox(height: 10),

              RatingAndTrustCard(),

              FaqSection(),
            ],
          ),
        ),
      ),

      /// =========================
      /// BOTTOM BAR
      /// =========================
      bottomNavigationBar: result == null
          ? null
          : SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: Colors.black,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "₹ ${result?["calculated_price"] ?? 0}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 2),

                    const Text(
                      "View Breakup",
                      style: TextStyle(
                        color: Color(0xffFF4FD8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 44,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffFF4FD8),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: sellNowApi,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      "Sell now",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
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
}
 