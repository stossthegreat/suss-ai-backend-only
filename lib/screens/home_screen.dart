import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';

import '../widgets/navigation/bottom_tab_bar.dart';
import '../widgets/navigation/page_transition.dart';
import '../widgets/tabs/scan_tab.dart';
import '../widgets/tabs/comebacks_tab.dart';
import '../widgets/tabs/pattern_tab.dart';
import '../widgets/tabs/history_tab.dart';
import '../widgets/tabs/settings_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  int _previousIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _previousIndex = _currentIndex;
      _currentIndex = index;
    });
  }

  Widget _getCurrentPage() {
    switch (_currentIndex) {
      case 0:
        return const ScanTab(); // ✅ FULLY BUILT - Main analysis
      case 1:
        return const ComebacksTab(); // ✅ FULLY BUILT - Response generator
      case 2:
        return const PatternTab(); // ✅ FULLY BUILT - Multi-message analysis
      case 3:
        return const HistoryTab(); // ✅ FULLY BUILT - Scan history
      case 4:
        return const SettingsTab(); // ✅ NEWLY BUILT - App preferences
      default:
        return const ScanTab();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 430),
                child: Column(
                  children: [
                    Expanded(
                      child: PageTransition(
                        key: ValueKey(_currentIndex),
                        index: _currentIndex,
                        previousIndex: _previousIndex,
                        child: _getCurrentPage(),
                      ),
                    ),
                    BottomTabBar(
                      currentIndex: _currentIndex,
                      onTap: _onTabTapped,
                      tabs: AppConstants.tabs,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
} 