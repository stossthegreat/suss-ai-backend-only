import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../utils/glassmorphism.dart';
import '../../widgets/common/gradient_button.dart';
import '../../widgets/common/result_card.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  late AnimationController _backgroundController;
  late AnimationController _textController;
  late Animation<double> _backgroundAnimation;
  late Animation<double> _textAnimation;
  
  int _currentPage = 0;
  bool _isLastPage = false;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      icon: '🔍',
      title: 'INSTANT SCAN',
      subtitle: 'Decode any message in seconds',
      description: 'MySnitch AI reads between the lines, exposing hidden tactics and manipulation patterns that others miss.',
      gradient: AppColors.primaryGradient,
      backgroundColor: AppColors.backgroundGray900,
    ),
    OnboardingPage(
      icon: '🚩',
      title: 'RED FLAG DETECTION',
      subtitle: 'Spot manipulation before it takes root',
      description: 'Advanced AI identifies toxic patterns, gaslighting, and emotional manipulation in real-time.',
      gradient: AppColors.pinkPurpleGradient,
      backgroundColor: AppColors.backgroundGray800,
    ),
    OnboardingPage(
      icon: '🎭',
      title: 'HIDDEN AGENDA REVEAL',
      subtitle: 'See what they really mean',
      description: 'Uncover the true intentions behind every word, gesture, and action in your relationships.',
      gradient: AppColors.blueCyanGradient,
      backgroundColor: AppColors.backgroundGray700,
    ),
    OnboardingPage(
      icon: '⚡',
      title: 'VIRAL INSIGHTS',
      subtitle: 'Screenshot-worthy truth bombs',
      description: 'Every scan delivers viral-worthy insights that will make your friends say "I need this app!"',
      gradient: AppColors.primaryGradient,
      backgroundColor: AppColors.backgroundGray900,
    ),
    OnboardingPage(
      icon: '🛡️',
      title: 'PROTECT YOURSELF',
      subtitle: 'Arm yourself with clarity',
      description: 'Join 50,000+ people who have taken back their power and built healthier relationships.',
      gradient: AppColors.primaryGradient,
      backgroundColor: AppColors.backgroundBlack,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startBackgroundAnimation();
  }

  void _setupAnimations() {
    _backgroundController = AnimationController(
      duration: AppConstants.slowAnimation,
      vsync: this,
    );
    
    _textController = AnimationController(
      duration: AppConstants.normalAnimation,
      vsync: this,
    );

    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: AppConstants.defaultCurve,
    ));

    _textAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: AppConstants.bounceCurve,
    ));

    _textController.forward();
  }

  void _startBackgroundAnimation() {
    _backgroundController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _backgroundController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
      _isLastPage = index == _pages.length - 1;
    });
    
    // Restart text animation for new page
    _textController.reset();
    _textController.forward();
  }

  void _nextPage() {
    if (_isLastPage) {
      _completeOnboarding();
    } else {
      _pageController.nextPage(
        duration: AppConstants.normalAnimation,
        curve: AppConstants.slideCurve,
      );
    }
  }

  void _completeOnboarding() {
    // Navigate to sign-in or main app
    Navigator.pushReplacementNamed(context, '/signin');
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
              // Skip button
              _buildSkipButton(),
              
              // Page content
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return _buildPage(_pages[index]);
                  },
                ),
              ),
              
              // Bottom section
              _buildBottomSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkipButton() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.mediumSpacing),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: _completeOnboarding,
            child: Text(
              'Skip',
              style: TextStyle(
                color: AppColors.textGray400,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.largeSpacing),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon with animated background
          _buildAnimatedIcon(page),
          
          const SizedBox(height: AppConstants.xlSpacing),
          
          // Title
          AnimatedBuilder(
            animation: _textAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, 20 * (1 - _textAnimation.value)),
                child: Opacity(
                  opacity: _textAnimation.value,
                  child: Text(
                    page.title,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textWhite,
                      letterSpacing: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
          ),
          
          const SizedBox(height: AppConstants.mediumSpacing),
          
          // Subtitle
          AnimatedBuilder(
            animation: _textAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, 15 * (1 - _textAnimation.value)),
                child: Opacity(
                  opacity: _textAnimation.value,
                  child: Text(
                    page.subtitle,
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.primaryPink,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
          ),
          
          const SizedBox(height: AppConstants.largeSpacing),
          
          // Description
          AnimatedBuilder(
            animation: _textAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, 10 * (1 - _textAnimation.value)),
                child: Opacity(
                  opacity: _textAnimation.value,
                  child: Text(
                    page.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textGray300,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedIcon(OnboardingPage page) {
    return AnimatedBuilder(
      animation: _backgroundAnimation,
      builder: (context, child) {
        return Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            gradient: page.gradient,
            borderRadius: BorderRadius.circular(60),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryPink.withOpacity(0.3 * _backgroundAnimation.value),
                blurRadius: 20,
                spreadRadius: 5 * _backgroundAnimation.value,
              ),
            ],
          ),
          child: Center(
            child: Text(
              page.icon,
              style: const TextStyle(fontSize: 48),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomSection() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.largeSpacing),
      child: Column(
        children: [
          // Page indicator
          SmoothPageIndicator(
            controller: _pageController,
            count: _pages.length,
            effect: WormEffect(
              activeDotColor: AppColors.primaryPink,
              dotColor: AppColors.textGray500,
              dotHeight: 8,
              dotWidth: 8,
              spacing: 8,
            ),
          ),
          
          const SizedBox(height: AppConstants.xlSpacing),
          
          // Action button
          GradientButton(
            text: _isLastPage ? 'Get Started' : 'Continue',
            onPressed: _nextPage,
            width: double.infinity,
            height: 56,
            icon: _isLastPage 
                ? const Icon(Icons.rocket_launch, color: Colors.white, size: 20)
                : const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
          ),
          
          if (!_isLastPage) ...[
            const SizedBox(height: AppConstants.mediumSpacing),
            TextButton(
              onPressed: _completeOnboarding,
              child: Text(
                'Skip to Sign In',
                style: TextStyle(
                  color: AppColors.textGray400,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class OnboardingPage {
  final String icon;
  final String title;
  final String subtitle;
  final String description;
  final LinearGradient gradient;
  final Color backgroundColor;

  OnboardingPage({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.gradient,
    required this.backgroundColor,
  });
} 