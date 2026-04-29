import 'package:buyback_module/features/buyback/Pages/evaluationpage/widgets/bottom_nav_button.dart';
import 'package:buyback_module/features/buyback/Pages/evaluationpage/widgets/evaluation_header_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Providers/evaluation_provider.dart';
import 'final_price_page.dart';

class WarrantyConditionPage extends StatefulWidget {
  final Map<int, dynamic> previousAnswers;
  final String itemname;
  final String imageUrl;
  final double progress;

  const WarrantyConditionPage({
    super.key,
    required this.previousAnswers,
    required this.itemname,
    required this.imageUrl,
    required this.progress,
  });

  @override
  State<WarrantyConditionPage> createState() => _WarrantyConditionPageState();
}

class _WarrantyConditionPageState extends State<WarrantyConditionPage> {
  String? selectedWarranty;

  final List<String> warrantyOptions = [
    "Purchase date below 3 months",
    "Purchase date between 3 to 6 months",
    "Purchase date between 6 to 11 months",
    "Above 11 months",
  ];

  @override
  Widget build(BuildContext context) {
    // final buyback = context.watch<BuybackSelectionProvider>();
    return WillPopScope(
      onWillPop: () async {
        context.read<EvaluationProvider>()
            .sections["Warranty"]
            ?.clear();

        context.read<EvaluationProvider>().notifyListeners();

        return true;
      },
      child: Scaffold(
        backgroundColor: const Color(0xff1E1E1E),

        /// APP BAR
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

        /// BODY
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HEADER
              EvaluationHeaderCard(
                itemname: widget.itemname,

                imageUrl: widget.imageUrl,
                progress: 0.90,
                variant: '',
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

              /// WARRANTY OPTIONS
              ...warrantyOptions.map(
                (option) => _WarrantyOptionTile(
                  title: option,
                  isSelected: selectedWarranty == option,
                  onTap: () {
                    setState(() => selectedWarranty = option);
                    /// ✅ SAVE TO PROVIDER
                    context.read<EvaluationProvider>().updateAnswer(
                      "Warranty",
                      "Warranty Condition",
                      option,
                    );
                  },
                ),
              ),

              const SizedBox(height: 90),
            ],
          ),
        ),

        /// FINISH BUTTON
        bottomNavigationBar: BottomNavButton(
          text: "Finish →",
          onTap: () {
            if (selectedWarranty == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Please select warranty condition")),
              );
              return;
            }

            /// Navigate to Final Price page
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (_) =>  FinalPricePage(),
            //   ),
            // );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FinalPricePage(
                  itemname: widget.itemname,
                  imageUrl: widget.imageUrl,
                  progress: 1.0, // ✅ final stage
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

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
            /// RADIO INDICATOR
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

            /// TEXT
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
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
