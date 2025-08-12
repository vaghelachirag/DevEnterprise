import 'package:deventerprise/router/app_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  // Load the .env file
  await dotenv.load(fileName: "assets/.env");
  runApp(
    ProviderScope(
      child: EasyLocalization(
        supportedLocales: const [
          Locale('en'),
          Locale('gu'),
          Locale('hi'),
        ],
        path: 'assets/translations',
        fallbackLocale: const Locale('gu'),
        child: const MyApp(),
      ),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'DevEnterprise',
      debugShowCheckedModeBanner: false,
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      routerConfig: appRouter,
    );
  }
}
