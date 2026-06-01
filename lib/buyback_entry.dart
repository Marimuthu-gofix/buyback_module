import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/buyback/Pages/home.dart';
import 'features/buyback/Providers/DeviceVariantProvider.dart';
import 'features/buyback/Providers/diagnose_result_provider.dart';
import 'features/buyback/Providers/evaluation_provider.dart';
import 'features/buyback/Providers/selection_provider.dart';

class BuybackConfig {
  final String appName;
  final String mobileNumber;

  const BuybackConfig({
    required this.appName,
    required this.mobileNumber,
  });
}

class BuybackModule extends StatefulWidget {
  final BuybackConfig config;

  const BuybackModule({
    super.key,
    required this.config,
  });

  @override
  State<BuybackModule> createState() => _BuybackModuleState();
}

class _BuybackModuleState extends State<BuybackModule> {
  @override
  void initState() {
    super.initState();
    _saveMobileNumber();
  }

  Future<void> _saveMobileNumber() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      'mobile_number',
      widget.config.mobileNumber,
    );

    debugPrint(
      "Saved Mobile Number: ${widget.config.mobileNumber}",
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => EvaluationProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => SelectionProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => DiagnoseResultProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => DeviceVariantProvider(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return Navigator(
            onGenerateRoute: (settings) {
              return MaterialPageRoute(
                builder: (_) => home(),
              );
            },
          );
        },
      ),
    );
  }
}