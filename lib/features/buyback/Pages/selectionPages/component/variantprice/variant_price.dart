import 'package:flutter/material.dart';
import '../../../../shared/Color/app_colors.dart';
import '../../../../shared/shimmer_effect/price_shimmer_card.dart';
import '../../../../shared/widgets/FaqSection.dart';
import '../../../evaluationpage/overall_condition_page.dart';
import '../../../evaluationpage/widgets/bottom_nav_button.dart';
import '../../../home.dart';
import 'model/variantprice_model.dart';
import 'services/variantprice_services.dart';

class VariantPriceScreen extends StatefulWidget {
  final int itemGroupId;
  final int brandId;
  final int modelId;

  final String ram;
  final String storage;
  final String displayVariant;

  final String colour;
  final String imageUrl;
  final String brandName;
  final String modelName;

  const VariantPriceScreen({
    super.key,
    required this.itemGroupId,
    required this.brandId,
    required this.modelId,
    required this.ram,
    required this.storage,
    required this.displayVariant,
    required this.colour,
    required this.imageUrl,
    required this.brandName,
    required this.modelName,
  });

  @override
  State<VariantPriceScreen> createState() => _VariantPriceScreenState();
}

class _VariantPriceScreenState extends State<VariantPriceScreen> {
  late Future<GetItemsModel> _futureItems;

  late Future<BuybackPriceModel> _priceFuture;

  @override
  void initState() {
    super.initState();

    _futureItems = GetItemsService.fetchItems(
      itemGroupId: widget.itemGroupId,
      brandId: widget.brandId,
      modelId: widget.modelId,
      ram: widget.ram,
      storage: widget.storage,
      colour: widget.colour.toLowerCase(),
    );

    _priceFuture = _futureItems.then((itemsModel) {
      if (itemsModel.data.isNotEmpty) {
        final itemCode = itemsModel.data.first.itemCode;

        return BuybackService.getPrice(itemCode);
      } else {
        throw Exception("No item found");
      }
    });
  }

  /// ✅ COMMON BUTTON FUNCTION
  Future<void> handleGetExactValue(ItemData item) async {
    try {
      final priceData = await _priceFuture;

      /// ✅ CHECK PRICE AVAILABLE
      if (priceData.data.isEmpty ||
          priceData.data.first.currentMarketPrice == null ||
          priceData.data.first.currentMarketPrice <= 0) {
        /// ✅ SHOW POPUP
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Price Not Available"),

              content: const Text(
                "Currently price is not available for this device.",
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);

                    /// ✅ REDIRECT TO HOME PAGE
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => home()),
                      (route) => false,
                    );
                  },

                  child: const Text("OK"),
                ),
              ],
            );
          },
        );

        return;
      }

      /// ✅ NORMAL FLOW
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OverallConditionPage(
            itemname: item.name,
            imageUrl: widget.imageUrl,
            progress: 0.25,
            itemCode: item.itemCode,
            brand: widget.brandId.toString(),
            itemGroup: widget.itemGroupId.toString(),
            imeiSerial: "string",
            company: "company",
            variant: widget.displayVariant,
          ),
        ),
      );
    } catch (e) {
      /// ✅ ERROR POPUP
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Price Not Available"),

            content: const Text(
              "Currently price is not available for this device.",
            ),

            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);

                  /// ✅ HOME PAGE
                  Navigator.popUntil(context, (route) => route.isFirst);
                },

                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  Widget variantCard(ItemData item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),

        gradient: const LinearGradient(
          colors: [Color(0xFF1E1E1E), Color(0xFF2A2A2A)],
        ),

        border: Border.all(color: const Color(0xFFFF64E6)),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),

                child: Image.network(
                  widget.imageUrl,
                  height: 120,
                  width: 80,
                  fit: BoxFit.cover,

                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      "Images/logo.png",
                      height: 80,
                      width: 80,
                    );
                  },
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      item.name,

                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    Text(
                      "(${widget.displayVariant})",

                      style: const TextStyle(color: Colors.white),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "Get Upto",

                      style: TextStyle(color: Colors.white),
                    ),

                    const SizedBox(height: 6),

                    FutureBuilder<BuybackPriceModel>(
                      future: _priceFuture,

                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                            height: 20,
                            width: 60,
                            color: Colors.grey.shade800,
                          );
                        }

                        if (snapshot.hasError) {
                          return const Text(
                            "No Price Available",

                            style: TextStyle(color: Colors.white),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
                          return const Text(
                            "No Price Available",

                            style: TextStyle(color: Colors.white),
                          );
                        }

                        final price =
                            snapshot.data!.data.first.currentMarketPrice;

                        if (price == null || price <= 0) {
                          return const Text(
                            "No Price Available",

                            style: TextStyle(color: Colors.white),
                          );
                        }

                        return Text(
                          "₹ $price",

                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          SizedBox(
            width: double.infinity,

            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffFF4FD8),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),

              /// ✅ BUTTON CLICK
              onPressed: () => handleGetExactValue(item),

              child: Text(
                "Get Exact Value →",

                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.textWhite,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

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
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: FutureBuilder<GetItemsModel>(
        future: _futureItems,

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: PriceShimmerCard(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",

                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
            return const Center(
              child: Text(
                "No Data Found",

                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final item = snapshot.data!.data.first;

          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: variantCard(item),
              ),

              const Padding(
                padding: EdgeInsets.only(top: 20.0),

                child: Center(
                  child: Text(
                    "This price is not final. It is an approximate value.\nFinal price will be quoted at the end.",

                    style: TextStyle(color: Colors.white54),

                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              const Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: FaqSection(),
              ),
            ],
          );
        },
      ),

      bottomNavigationBar: FutureBuilder<GetItemsModel>(
        future: _futureItems,

        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
            return const SizedBox();
          }

          final item = snapshot.data!.data.first;

          return BottomNavButton(
            text: "Get Exact Value →",

            onTap: () => handleGetExactValue(item),
          );
        },
      ),
    );
  }
}
