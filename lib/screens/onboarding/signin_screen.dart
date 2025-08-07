import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../utils/glassmorphism.dart';
import '../../widgets/common/gradient_button.dart';
import '../../widgets/common/outlined_button.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

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
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    setState(() => _isLoading = true);
    
    // Simulate sign-in process
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.pushReplacementNamed(context, '/main');
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.pushReplacementNamed(context, '/main');
    }
  }

  Future<void> _handleAppleSignIn() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
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
                        
                        // Social sign-in buttons
                        _buildSocialButtons(),
                        
                        const SizedBox(height: AppConstants.largeSpacing),
                        
                        // Divider
                        _buildDivider(),
                        
                        const SizedBox(height: AppConstants.largeSpacing),
                        
                        // Email form
                        _buildEmailForm(),
                        
                        const Spacer(),
                        
                        // Sign in button
                        _buildSignInButton(),
                        
                        const SizedBox(height: AppConstants.mediumSpacing),
                        
                        // Terms
                        _buildTerms(),
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
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryPink.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: const Icon(
            Icons.radar,
            size: 40,
            color: Colors.white,
          ),
        ),
        
        const SizedBox(height: AppConstants.mediumSpacing),
        
        const Text(
          'Welcome to MySnitch AI',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textWhite,
          ),
        ),
        
        const SizedBox(height: AppConstants.smallSpacing),
        
        Text(
          'Sign in to start scanning',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textGray400,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButtons() {
    return Column(
      children: [
        CustomOutlinedButton(
          text: 'Continue with Google',
          onPressed: () {
            // TODO: Implement Google sign-in
            Navigator.pushNamed(context, '/main');
          },
        ),
        
        const SizedBox(height: AppConstants.mediumSpacing),
        
        CustomOutlinedButton(
          text: 'Continue with Apple',
          onPressed: () {
            // TODO: Implement Apple sign-in
            Navigator.pushNamed(context, '/main');
          },
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  AppColors.textGray500,
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.mediumSpacing),
          child: Text(
            'or',
            style: TextStyle(
              color: AppColors.textGray500,
              fontSize: 14,
            ),
          ),
        ),
        
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  AppColors.textGray500,
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailForm() {
    return Column(
      children: [
        GlassmorphismUtils.glassCard(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.mediumSpacing),
          backgroundColor: AppColors.backgroundGray800.withOpacity(0.5),
          borderColor: AppColors.borderGray600,
          child: TextField(
            controller: _emailController,
            style: const TextStyle(color: AppColors.textWhite),
            decoration: const InputDecoration(
              hintText: 'Email',
              hintStyle: TextStyle(color: AppColors.textGray500),
              border: InputBorder.none,
              icon: Icon(Icons.email, color: AppColors.textGray400),
            ),
          ),
        ),
        
        const SizedBox(height: AppConstants.mediumSpacing),
        
        GlassmorphismUtils.glassCard(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.mediumSpacing),
          backgroundColor: AppColors.backgroundGray800.withOpacity(0.5),
          borderColor: AppColors.borderGray600,
          child: TextField(
            controller: _passwordController,
            obscureText: true,
            style: const TextStyle(color: AppColors.textWhite),
            decoration: const InputDecoration(
              hintText: 'Password',
              hintStyle: TextStyle(color: AppColors.textGray500),
              border: InputBorder.none,
              icon: Icon(Icons.lock, color: AppColors.textGray400),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignInButton() {
    return GradientButton(
      text: 'Sign In',
      onPressed: _isLoading ? null : _handleSignIn,
      isLoading: _isLoading,
      width: double.infinity,
      height: 56,
      icon: const Icon(Icons.login, color: Colors.white, size: 20),
    );
  }

  Widget _buildTerms() {
    return Text(
      'By signing in, you agree to our Terms of Service and Privacy Policy',
      style: TextStyle(
        color: AppColors.textGray500,
        fontSize: 12,
      ),
      textAlign: TextAlign.center,
    );
  }
} 