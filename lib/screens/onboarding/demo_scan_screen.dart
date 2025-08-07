import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../utils/glassmorphism.dart';
import '../../widgets/common/gradient_button.dart';
import '../../widgets/common/result_card.dart';
import '../../widgets/common/score_display.dart';

class DemoScanScreen extends StatefulWidget {
  const DemoScanScreen({super.key});

  @override
  State<DemoScanScreen> createState() => _DemoScanScreenState();
}

class _DemoScanScreenState extends State<DemoScanScreen>
    with TickerProviderStateMixin {
  late AnimationController _scanController;
  late AnimationController _resultController;
  late Animation<double> _scanAnimation;
  late Animation<double> _resultAnimation;
  
  bool _isScanning = true;
  bool _showResults = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startScan();
  }

  void _setupAnimations() {
    _scanController = AnimationController(
      duration: AppConstants.analysisAnimation,
      vsync: this,
    );
    
    _resultController = AnimationController(
      duration: AppConstants.slowAnimation,
      vsync: this,
    );

    _scanAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scanController,
      curve: AppConstants.defaultCurve,
    ));

    _resultAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _resultController,
      curve: AppConstants.bounceCurve,
    ));
  }

  void _startScan() async {
    _scanController.forward();
    
    // Simulate scan time
    await Future.delayed(const Duration(seconds: 3));
    
    if (mounted) {
      setState(() => _isScanning = false);
      _resultController.forward();
      
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        setState(() => _showResults = true);
      }
    }
  }

  @override
  void dispose() {
    _scanController.dispose();
    _resultController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.largeSpacing),
            child: Column(
              children: [
                // Header
                _buildHeader(),
                
                const SizedBox(height: AppConstants.xlSpacing),
                
                // Content
                Expanded(
                  child: _isScanning ? _buildScanningView() : _buildResultsView(),
                ),
                
                // Action buttons
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: AppColors.textWhite),
        ),
        const Expanded(
          child: Text(
            'MySnitch AI Instant Scan',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textWhite,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(width: 48), // Balance the back button
      ],
    );
  }

  Widget _buildScanningView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Scanning animation
        AnimatedBuilder(
          animation: _scanAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: 0.8 + (0.2 * _scanAnimation.value),
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(60),
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
                  size: 60,
                  color: Colors.white,
                ),
              ),
            );
          },
        ),
        
        const SizedBox(height: AppConstants.xlSpacing),
        
        // Scanning text
        AnimatedBuilder(
          animation: _scanAnimation,
          builder: (context, child) {
            return Opacity(
              opacity: _scanAnimation.value,
              child: Column(
                children: [
                  const Text(
                    'Scanning message for hidden agenda...',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.textWhite,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: AppConstants.mediumSpacing),
                  
                  Text(
                    'Analyzing ${(87 * _scanAnimation.value).toInt()}% complete',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textGray400,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        
        const SizedBox(height: AppConstants.xlSpacing),
        
        // Progress indicator
        AnimatedBuilder(
          animation: _scanAnimation,
          builder: (context, child) {
            return SizedBox(
              width: 200,
              child: LinearProgressIndicator(
                value: _scanAnimation.value,
                backgroundColor: AppColors.backgroundGray700,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryPink),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildResultsView() {
    return AnimatedBuilder(
      animation: _resultAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _resultAnimation.value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - _resultAnimation.value)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Score section
                  _buildScoreSection(),
                  
                  const SizedBox(height: AppConstants.largeSpacing),
                  
                  // Analysis results
                  if (_showResults) _buildAnalysisResults(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildScoreSection() {
    return ResultCard(
      child: Column(
        children: [
          Row(
            children: [
              Text(
                AppColors.getScoreEmoji(87),
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(width: AppConstants.mediumSpacing),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'HIGH RISK DETECTED',
                      style: TextStyle(
                        color: AppColors.dangerRed,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      AppColors.getScoreTier(87),
                      style: TextStyle(
                        color: AppColors.textGray400,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              ScoreDisplay(score: 87, fontSize: 32),
            ],
          ),
          
          const SizedBox(height: AppConstants.mediumSpacing),
          
          Container(
            padding: const EdgeInsets.all(AppConstants.mediumSpacing),
            decoration: BoxDecoration(
              color: AppColors.dangerRed.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
              border: Border.all(
                color: AppColors.dangerRed.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: const Text(
              '🚨 This person is using classic manipulation tactics. Your gut feeling is correct - this is not healthy behavior.',
              style: TextStyle(
                color: AppColors.textWhite,
                fontSize: 14,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisResults() {
    return Column(
      children: [
        _buildAnalysisCard(
          '🎭 MANIPULATION TACTICS',
          [
            'Love bombing detected',
            'Gaslighting patterns identified',
            'Emotional blackmail present',
            'Boundary testing confirmed',
          ],
          AppColors.dangerRed,
        ),
        
        const SizedBox(height: AppConstants.mediumSpacing),
        
        _buildAnalysisCard(
          '🧠 PSYCHOLOGICAL IMPACT',
          [
            'Self-doubt: 78% probability',
            'Confusion: 85% likelihood',
            'Emotional dependency: 92% risk',
            'Reality distortion: 81% detected',
          ],
          AppColors.warningOrange,
        ),
        
        const SizedBox(height: AppConstants.mediumSpacing),
        
        _buildAnalysisCard(
          '🛡️ RECOMMENDED ACTIONS',
          [
            'Document all interactions',
            'Set firm boundaries immediately',
            'Seek support from trusted friends',
            'Consider professional counseling',
          ],
          AppColors.successGreen,
        ),
      ],
    );
  }

  Widget _buildAnalysisCard(String title, List<String> items, Color color) {
    return ResultCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: AppConstants.mediumSpacing),
          
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: AppConstants.smallSpacing),
            child: Row(
              children: [
                Icon(
                  Icons.fiber_manual_record,
                  color: color,
                  size: 8,
                ),
                const SizedBox(width: AppConstants.smallSpacing),
                Expanded(
                  child: Text(
                    item,
                    style: const TextStyle(
                      color: AppColors.textWhite,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        GradientButton(
          text: 'Scan Another Message',
          onPressed: () => Navigator.pushReplacementNamed(context, '/main'),
          width: double.infinity,
          height: 56,
          icon: const Icon(Icons.refresh, color: Colors.white, size: 20),
        ),
        
        const SizedBox(height: AppConstants.mediumSpacing),
        
        TextButton(
          onPressed: () => Navigator.pushReplacementNamed(context, '/main'),
          child: Text(
            'Go to Main App',
            style: TextStyle(
              color: AppColors.textGray400,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
} 