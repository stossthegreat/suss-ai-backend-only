import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'utils/colors.dart';
import 'utils/constants.dart';
import 'screens/onboarding/splash_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/onboarding/signin_screen.dart';
import 'screens/onboarding/paywall_screen.dart';
import 'screens/onboarding/demo_scan_screen.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(const WhisperfireApp());
}

class WhisperfireApp extends StatelessWidget {
  const WhisperfireApp({super.key});

  @override
  Widget build(BuildContext context) {
        return MaterialApp(
      title: 'MySnitch AI - Neural Pattern Scanner',
          debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: AppColors.primaryPink,
        scaffoldBackgroundColor: AppColors.backgroundBlack,
        fontFamily: 'Inter',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: AppColors.textWhite),
          bodyMedium: TextStyle(color: AppColors.textWhite),
          titleLarge: TextStyle(color: AppColors.textWhite),
          titleMedium: TextStyle(color: AppColors.textWhite),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.textWhite),
          titleTextStyle: TextStyle(
            color: AppColors.textWhite,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryPink,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.xlRadius),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.backgroundGray800,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
            borderSide: BorderSide(color: AppColors.borderGray600),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
            borderSide: BorderSide(color: AppColors.borderGray600),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
            borderSide: BorderSide(color: AppColors.primaryPink),
          ),
          hintStyle: TextStyle(color: AppColors.textGray500),
        ),
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/signin': (context) => const SignInScreen(),
        '/paywall': (context) => const PaywallScreen(),
        '/demo': (context) => const DemoScanScreen(),
        '/main': (context) => const MainScreen(),
      },
    );
  }
}
