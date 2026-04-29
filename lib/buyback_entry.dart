import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

// ✅ UPDATED IMPORTS (based on your new structure)
import 'features/buyback/Pages/home.dart';
import 'features/buyback/Providers/evaluation_provider.dart';
import 'features/buyback/Providers/selection_provider.dart';

class BuybackConfig {
  final String appName;

  const BuybackConfig({
    required this.appName,
  });
}

class BuybackModule extends StatelessWidget {
  final BuybackConfig config;

  const BuybackModule({super.key, required this.config});



  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EvaluationProvider()),
        ChangeNotifierProvider(create: (_) => SelectionProvider()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,

        builder: (context, child) {
          // ❗ REPLACED MaterialApp with Navigator
          return Navigator(
            onGenerateRoute: (settings) {
              return MaterialPageRoute(
                builder: (_) => home(), // your original home()
              );
            },
          );
        },
      ),
    );
  }
}