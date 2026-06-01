import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Providers/DeviceVariantProvider.dart';
import '../../../shared/Color/app_colors.dart';
import '../DiagnoseResultPage.dart';
import '../diagnose_screen.dart';
import '../models/getStorage.dart';
import '../models/getdevicename.dart';
import '../services/DeviceVariantService.dart';

class InitiateDiagostics extends StatefulWidget {
  const InitiateDiagostics({super.key});

  @override
  State<InitiateDiagostics> createState() => _InitiateDiagosticsState();
}

class _InitiateDiagosticsState extends State<InitiateDiagostics> {
  String deviceName = "Loading...";
  String storage = "Loading...";
  String ram = "Loading...";
  String deviceBrand = "Loading...";
  String deviceModel = ""; // Separate variable
  String imageUrl = "";

  @override
  void initState() {
    super.initState();
    loadDevice();
  }

  Future<void> loadDeviceData() async {
    final service = DeviceVariantService();

    debugPrint("CALL API DEVICE => $deviceName");

    await service.getDeviceVariants(deviceName: deviceName);
  }

  Future<void> loadDevice() async {
    final details = await getDeviceDetails();
    final storageData = await getStorage();
    final ramData = await DeviceHelper.getRam();

    // CREATE DEVICE NAME FIRST
    final fullDeviceName =
        "${details['brand']} ${details['model']} ${ramData}GB ${storageData}GB";

    setState(() {
      deviceBrand = details['brand'] ?? "";
      deviceModel = details['model'] ?? "";
      imageUrl = details['imageUrl'] ?? "";
      storage = storageData;
      ram = ramData;

      deviceName = fullDeviceName;
    });

    debugPrint("FINAL DEVICE NAME => $fullDeviceName");

    // CALL API USING FINAL VALUE
    await loadDeviceDataUsingName(fullDeviceName);
  }

  Future<void> loadDeviceDataUsingName(String name) async {
    final service = DeviceVariantService();

    debugPrint("CALL API DEVICE => $name");

    await service.getDeviceVariants(deviceName: name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "GoFix",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.black,
        actions: [
          ElevatedButton(
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
                  builder: (_) =>
                      const DiagnoseResultPage(), // no onRetest needed
                ),
              );
            },
            child: Text(
              "Diagnosis History",
              style: TextStyle(
                fontSize: 15,
                color: AppColors.textWhite,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // LEFT align
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Initiate Diagnostics",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),

            const SizedBox(height: 20),
            Text(
              "Tap on Run Diagnostics to start the Automatic & Assisted tests.Follow the instruction.",
              style: TextStyle(color: Colors.white60),
            ),
            // DEVICE CARD
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xffFF4FD8)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    height: 100,
                    color: Colors.grey[800],
                    child: imageUrl.isNotEmpty
                        ? Image.network(
                            imageUrl,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset("Images/logo.png", height: 80);
                            },
                          )
                        : Image.asset("Images/logo.png", height: 80, width: 80),
                  ),
                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          deviceBrand,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        // MODEL (e.g., Galaxy S24 Ultra)
                        Text(
                          deviceModel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          "$ram • $storage",
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 13,
                          ),
                        ),

                        const SizedBox(height: 10),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffFF4FD8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () async {
                            final provider = context
                                .read<DeviceVariantProvider>();
                            final prefs = await SharedPreferences.getInstance();

                            // 1️⃣ Load API
                            final service = DeviceVariantService();
                            final variants = await service.getDeviceVariants(
                              deviceName: deviceName,
                            );

                            provider.setVariants(variants);

                            // 2️⃣ SHOW POPUP
                            showDialog(
                              context: context,
                              builder: (dialogContext) {
                                return Dialog(
                                  backgroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 60,
                                          height: 4,
                                          decoration: BoxDecoration(
                                            color: const Color(0xffFF4FD8),
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        ),

                                        const SizedBox(height: 15),

                                        const Text(
                                          "Select Color Variant",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),

                                        const SizedBox(height: 15),

                                        Consumer<DeviceVariantProvider>(
                                          builder: (context, provider, _) {
                                            return Wrap(
                                              spacing: 12,
                                              runSpacing: 12,
                                              children: provider.variants.map((
                                                item,
                                              ) {
                                                final isSelected =
                                                    provider
                                                        .selectedVariant
                                                        ?.itemCode ==
                                                    item.itemCode;

                                                return GestureDetector(
                                                  onTap: () async {
                                                    // 3️⃣ STORE IN PROVIDER
                                                    provider.selectVariant(
                                                      item,
                                                    );

                                                    // 4️⃣ SAVE ONLY SELECTED
                                                    await prefs.setString(
                                                      "selected_variant",
                                                      jsonEncode(item.toJson()),
                                                    );

                                                    // 5️⃣ PRINT CHOOSEN DATA
                                                    debugPrint(
                                                      "CHOSEN VARIANT => ${jsonEncode(item.toJson())}",
                                                    );

                                                    Navigator.pop(
                                                      dialogContext,
                                                    );

                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (_) =>
                                                            GoFixDiagnoseScreen(),
                                                      ),
                                                    );
                                                  },
                                                  child: AnimatedContainer(
                                                    duration: const Duration(
                                                      milliseconds: 200,
                                                    ),
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 14,
                                                          vertical: 10,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: isSelected
                                                          ? const Color(
                                                              0xffFF4FD8,
                                                            )
                                                          : const Color(
                                                              0xff1A1A1A,
                                                            ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            14,
                                                          ),
                                                      border: Border.all(
                                                        color: isSelected
                                                            ? const Color(
                                                                0xffFF4FD8,
                                                              )
                                                            : Colors
                                                                  .grey
                                                                  .shade800,
                                                      ),
                                                    ),
                                                    child: Text(
                                                      item.color,
                                                      style: TextStyle(
                                                        color: isSelected
                                                            ? Colors.black
                                                            : Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                            );
                                          },
                                        ),

                                        const SizedBox(height: 20),
                                      ],
                                    ),
                                  ),
                                );
                              },
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
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            Text("Instruction", style: TextStyle(color: Colors.white)),
            const SizedBox(height: 10),

            // INSTRUCTIONS
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: const [
                  InstructionItem("Follow the steps on screen", index: 1),
                  InstructionItem("Automated tests will run", index: 2),
                  InstructionItem("Press 'Run Diagnostics'", index: 3),
                  InstructionItem("Re-run failed tests later", index: 4),
                ],
              ),
            ),

            const Spacer(),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xffFF4FD8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              final provider = context.read<DeviceVariantProvider>();
              final prefs = await SharedPreferences.getInstance();

              // 1️⃣ Load API
              final service = DeviceVariantService();
              final variants = await service.getDeviceVariants(
                deviceName: deviceName,
              );

              provider.setVariants(variants);

              // 2️⃣ SHOW POPUP
              showDialog(
                context: context,
                builder: (dialogContext) {
                  return Dialog(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 60,
                            height: 4,
                            decoration: BoxDecoration(
                              color: const Color(0xffFF4FD8),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),

                          const SizedBox(height: 15),

                          const Text(
                            "Select Color Variant",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 15),

                          Consumer<DeviceVariantProvider>(
                            builder: (context, provider, _) {
                              return Wrap(
                                spacing: 12,
                                runSpacing: 12,
                                children: provider.variants.map((item) {
                                  final isSelected =
                                      provider.selectedVariant?.itemCode ==
                                      item.itemCode;

                                  return GestureDetector(
                                    onTap: () async {
                                      // 3️⃣ STORE IN PROVIDER
                                      provider.selectVariant(item);

                                      // 4️⃣ SAVE ONLY SELECTED
                                      await prefs.setString(
                                        "selected_variant",
                                        jsonEncode(item.toJson()),
                                      );

                                      // 5️⃣ PRINT CHOOSEN DATA
                                      debugPrint(
                                        "CHOSEN VARIANT => ${jsonEncode(item.toJson())}",
                                      );

                                      Navigator.pop(dialogContext);

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => GoFixDiagnoseScreen(),
                                        ),
                                      );
                                    },
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? const Color(0xffFF4FD8)
                                            : const Color(0xff1A1A1A),
                                        borderRadius: BorderRadius.circular(14),
                                        border: Border.all(
                                          color: isSelected
                                              ? const Color(0xffFF4FD8)
                                              : Colors.grey.shade800,
                                        ),
                                      ),
                                      child: Text(
                                        item.color,
                                        style: TextStyle(
                                          color: isSelected
                                              ? Colors.black
                                              : Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              );
                            },
                          ),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            child: Text(
              "Run Diagnostics",
              style: TextStyle(
                fontSize: 18,
                color: AppColors.textWhite,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class InstructionItem extends StatelessWidget {
  final String text;
  final int index;

  const InstructionItem(this.text, {super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 10,
            backgroundColor: const Color(0xffFF4FD8),
            child: Text(
              "$index",
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
