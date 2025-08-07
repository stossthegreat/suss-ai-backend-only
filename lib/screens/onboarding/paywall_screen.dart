import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../utils/glassmorphism.dart';
import '../../widgets/common/gradient_button.dart';
import '../../widgets/common/result_card.dart';

class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _pulseController;
  
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;
  
  String? _selectedPlan;
  bool _isLoading = false;

  final List<PlanOption> _plans = [
    PlanOption(
      id: 'monthly',
      title: 'Monthly Plan',
      price: '\$7.99',
      originalPrice: null,
      description: 'Perfect for trying MySnitch AI',
      features: ['Unlimited scans', 'All analysis types', 'Priority support'],
      popular: false,
    ),
    PlanOption(
      id: 'annual',
      title: 'Annual Plan',
      price: '\$69.99',
      originalPrice: '\$95.88',
      description: 'Save 30% - Best value',
      features: ['Everything in monthly', 'Early access to features', 'Premium support'],
      popular: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimations();
  }

  void _setupAnimations() {
    _fadeController = AnimationController(
      duration: AppConstants.slowAnimation,
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: AppConstants.normalAnimation,
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: AppConstants.defaultCurve,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: AppConstants.slideCurve,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _fadeController.forward();
    _slideController.forward();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _handlePurchase() async {
    if (_selectedPlan == null) return;
    
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.pushReplacementNamed(context, '/main');
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
          child: AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Padding(
                    padding: const EdgeInsets.all(AppConstants.largeSpacing),
                    child: Column(
                      children: [
                        // Header
                        _buildHeader(),
                        
                        const SizedBox(height: AppConstants.xlSpacing),
                        
                        // Features
                        _buildFeatures(),
                        
                        const SizedBox(height: AppConstants.xlSpacing),
                        
                        // Plans
                        Expanded(child: _buildPlans()),
                        
                        // Purchase button
                        _buildPurchaseButton(),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryPink.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.workspace_premium,
                  size: 50,
                  color: Colors.white,
                ),
              ),
            );
          },
        ),
        
        const SizedBox(height: AppConstants.mediumSpacing),
        
        const Text(
          'Unlock MySnitch AI Premium',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textWhite,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: AppConstants.smallSpacing),
        
        Text(
          'Get unlimited scans and advanced insights',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textGray400,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFeatures() {
    return Column(
      children: [
        _buildFeatureItem('🔍', 'Unlimited Instant Scans'),
        _buildFeatureItem('🚩', 'Advanced Red Flag Detection'),
        _buildFeatureItem('🎭', 'Hidden Agenda Analysis'),
        _buildFeatureItem('⚡', 'Viral Insight Generation'),
        _buildFeatureItem('🛡️', 'Priority Support'),
      ],
    );
  }

  Widget _buildFeatureItem(String icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.smallSpacing),
      child: Row(
        children: [
          Text(
            icon,
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(width: AppConstants.mediumSpacing),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: AppColors.textWhite,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlans() {
    return ListView.builder(
      itemCount: _plans.length,
      itemBuilder: (context, index) {
        final plan = _plans[index];
        final isSelected = _selectedPlan == plan.id;
        
        return Padding(
          padding: const EdgeInsets.only(bottom: AppConstants.mediumSpacing),
          child: GestureDetector(
            onTap: () => setState(() => _selectedPlan = plan.id),
            child: AnimatedContainer(
              duration: AppConstants.fastAnimation,
              child: ResultCard(
                padding: const EdgeInsets.all(AppConstants.mediumSpacing),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (plan.popular)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppConstants.smallSpacing,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'MOST POPULAR',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        const Spacer(),
                        if (isSelected)
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                      ],
                    ),
                    
                    const SizedBox(height: AppConstants.smallSpacing),
                    
                    Text(
                      plan.title,
                      style: const TextStyle(
                        color: AppColors.textWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    const SizedBox(height: AppConstants.smallSpacing),
                    
                    Row(
                      children: [
                        Text(
                          plan.price,
                          style: const TextStyle(
                            color: AppColors.primaryPink,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (plan.originalPrice != null) ...[
                          const SizedBox(width: AppConstants.smallSpacing),
                          Text(
                            plan.originalPrice!,
                            style: TextStyle(
                              color: AppColors.textGray500,
                              fontSize: 16,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ],
                    ),
                    
                    const SizedBox(height: AppConstants.smallSpacing),
                    
                    Text(
                      plan.description,
                      style: TextStyle(
                        color: AppColors.textGray400,
                        fontSize: 14,
                      ),
                    ),
                    
                    const SizedBox(height: AppConstants.mediumSpacing),
                    
                    ...plan.features.map((feature) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: AppColors.successGreen,
                            size: 16,
                          ),
                          const SizedBox(width: AppConstants.smallSpacing),
                          Expanded(
                            child: Text(
                              feature,
                              style: TextStyle(
                                color: AppColors.textGray300,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPurchaseButton() {
    return Column(
      children: [
        GradientButton(
          text: _isLoading ? 'Processing...' : 'Unlock Premium',
          onPressed: _selectedPlan == null || _isLoading ? null : _handlePurchase,
          isLoading: _isLoading,
          width: double.infinity,
          height: 56,
          icon: const Icon(Icons.workspace_premium, color: Colors.white, size: 20),
        ),
        
        const SizedBox(height: AppConstants.mediumSpacing),
        
        Text(
          'Cancel anytime • 7-day free trial',
          style: TextStyle(
            color: AppColors.textGray500,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class PlanOption {
  final String id;
  final String title;
  final String price;
  final String? originalPrice;
  final String description;
  final List<String> features;
  final bool popular;

  PlanOption({
    required this.id,
    required this.title,
    required this.price,
    this.originalPrice,
    required this.description,
    required this.features,
    required this.popular,
  });
} 