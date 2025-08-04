import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../widgets/navigation/bottom_tab_bar.dart';
import '../widgets/navigation/page_transition.dart';
import '../widgets/tabs/scan_tab.dart';
import '../widgets/tabs/comebacks_tab.dart';
import '../widgets/tabs/pattern_tab.dart';
import '../widgets/tabs/history_tab.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  late PageController _pageController;
  late List<AnimationController> _tabAnimationControllers;
  int _currentIndex = 0;
  int _previousIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _setupTabAnimations();
  }

  void _setupTabAnimations() {
    _tabAnimationControllers = List.generate(
      4, // Number of tabs
      (index) => AnimationController(
        duration: AppConstants.normalAnimation,
        vsync: this,
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (var controller in _tabAnimationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onTabTapped(int index) {
    if (index != _currentIndex) {
      setState(() {
        _previousIndex = _currentIndex;
        _currentIndex = index;
      });
      
      _pageController.animateToPage(
        index,
        duration: AppConstants.normalAnimation,
        curve: AppConstants.slideCurve,
      );
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
          child: Column(
            children: [
              // Header
              _buildHeader(),
              
              // Page content
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _previousIndex = _currentIndex;
                      _currentIndex = index;
                    });
                  },
                  children: [
                    PageTransition(
                      index: 0,
                      previousIndex: _previousIndex,
                      child: const ScanTab(),
                    ),
                    PageTransition(
                      index: 1,
                      previousIndex: _previousIndex,
                      child: const ComebacksTab(),
                    ),
                    PageTransition(
                      index: 2,
                      previousIndex: _previousIndex,
                      child: const PatternTab(),
                    ),
                    PageTransition(
                      index: 3,
                      previousIndex: _previousIndex,
                      child: const HistoryTab(),
                    ),
                  ],
                ),
              ),
              
              // Bottom navigation
              BottomTabBar(
                currentIndex: _currentIndex,
                onTap: _onTabTapped,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.largeSpacing),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.radar,
              color: Colors.white,
              size: 20,
            ),
          ),
          
          const SizedBox(width: AppConstants.mediumSpacing),
          
          const Expanded(
            child: Text(
              'UNAV',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textWhite,
                letterSpacing: 1.2,
              ),
            ),
          ),
          
          IconButton(
            onPressed: () {
              // Show settings or profile
            },
            icon: const Icon(
              Icons.person,
              color: AppColors.textWhite,
            ),
          ),
        ],
      ),
    );
  }
} 