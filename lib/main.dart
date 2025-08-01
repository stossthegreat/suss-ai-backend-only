import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const SocialLieDetectorApp(),
    ),
  );
}

class SocialLieDetectorApp extends StatelessWidget {
  const SocialLieDetectorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'MySnitch AI',
          debugShowCheckedModeBanner: false,
          theme: themeProvider.themeData,
          home: const HomeScreen(),
        );
      },
    );
  }
}
