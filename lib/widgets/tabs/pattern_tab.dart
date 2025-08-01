import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../utils/mock_data.dart';
import '../common/custom_text_field.dart';
import '../common/gradient_button.dart';
import '../common/outlined_button.dart';
import '../common/result_card.dart';
import '../common/loading_spinner.dart';
import '../common/watermark_stamp.dart';
import '../../services/api_service.dart';
import '../../models/whisperfire_models.dart';
import 'package:flutter/services.dart';

class PatternTab extends StatefulWidget {
  const PatternTab({super.key});

  @override
  State<PatternTab> createState() => _PatternTabState();
}

class _PatternTabState extends State<PatternTab> {
  final List<TextEditingController> _messageControllers = [TextEditingController()];
  String _selectedRelationship = 'Partner';
  final TextEditingController _nameController = TextEditingController();
  bool _isAnalyzing = false;
  WhisperfireResponse? _analysis;

  @override
  void initState() {
    super.initState();
    // Add listener to first controller
    _messageControllers[0].addListener(() {
      setState(() {}); // Rebuild to update button state
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    for (final controller in _messageControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _runPatternAnalysis() async {
    // Get all valid messages
    final messages = _messageControllers
        .map((controller) => controller.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();

    if (messages.isEmpty) return;

    setState(() {
      _isAnalyzing = true;
      _analysis = null;
    });

    try {
      // Call the WHISPERFIRE API service for pattern analysis
      final result = await ApiService.analyzeMessageWhisperfire(
        inputText: messages.join('\n'),
        contentType: 'dm',
        analysisGoal: 'pattern_profiling',
        tone: 'clinical',
        relationship: _selectedRelationship,
      );

      if (mounted) {
        setState(() {
          _analysis = result;
          _isAnalyzing = false;
        });
      }
    } catch (error) {
      print('❌ Pattern analysis failed: $error');
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Pattern analysis failed: ${error.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _addMessage() {
    if (_messageControllers.length < 5) { // Max 5 messages as requested
      setState(() {
        final newController = TextEditingController();
        newController.addListener(() {
          setState(() {}); // Rebuild to update button state
        });
        _messageControllers.add(newController);
      });
    }
  }

  int get _validMessageCount {
    return _messageControllers
        .where((controller) => controller.text.trim().isNotEmpty)
        .length;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Header
          _buildHeader(),
          const SizedBox(height: 24),
          
          // Relationship Context Selector
          _buildRelationshipSelector(),
          const SizedBox(height: 24),
          
          // Message Stack
          _buildMessageStack(),
          const SizedBox(height: 24),
          
          // Analyze Button
          _buildAnalyzeButton(),
          const SizedBox(height: 24),
          
          // Pattern Results
          if (_analysis != null) _buildPatternResults(),
          
          const SizedBox(height: 100), // Bottom padding for tab bar
        ],
      ),
    );
  }

  // ✅ HEADER - Matches React: 🧩 + title + subtitle
  Widget _buildHeader() {
    return Column(
      children: [
        const SizedBox(height: 16),
        const Text(
          '🧩 Pattern Scan',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Analyze multiple messages for behavior patterns',
          style: TextStyle(
            color: AppColors.textGray400,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  // ✅ RELATIONSHIP SELECTOR - New WHISPERFIRE feature
  Widget _buildRelationshipSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'RELATIONSHIP CONTEXT',
          style: TextStyle(
            color: AppColors.textGray400,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.backgroundGray800,
            borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
            border: Border.all(color: AppColors.borderGray600),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedRelationship,
              isExpanded: true,
              dropdownColor: AppColors.backgroundGray800,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              items: AppConstants.relationshipContexts.map((context) {
                return DropdownMenuItem<String>(
                  value: context.id,
                  child: Row(
                    children: [
                      Text(context.label),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          context.desc,
                          style: TextStyle(
                            color: AppColors.textGray400,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedRelationship = value;
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  // ✅ PERSON NAME - Matches React: Optional name input
  Widget _buildPersonNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ✅ EXACT React styling: "NAME THIS PERSON (OPTIONAL)" label
        Text(
          'NAME THIS PERSON (OPTIONAL)',
          style: TextStyle(
            color: AppColors.textGray400,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        // ✅ REUSED: CustomTextField from Phase 3 with glassmorphism
        CustomTextField(
          controller: _nameController,
          placeholder: 'e.g., \'Toxic Ex\', \'Confusing Coworker\'',
          padding: const EdgeInsets.all(12),
        ),
      ],
    );
  }

  // ✅ MESSAGE STACK - Matches React: Dynamic list with numbered inputs (max 7)
  Widget _buildMessageStack() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ✅ EXACT React: Counter showing valid messages
        Text(
          'MESSAGES ($_validMessageCount/5)',
          style: TextStyle(
            color: AppColors.textGray400,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        
        // ✅ EXACT React: List of message inputs with numbers
        ..._messageControllers.asMap().entries.map((entry) {
          final index = entry.key;
          final controller = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Stack(
              children: [
                // ✅ REUSED: CustomTextField with glassmorphism
                CustomTextField(
                  controller: controller,
                  placeholder: 'Message ${index + 1}...',
                  maxLines: 5, // Smaller than scan input
                  padding: const EdgeInsets.all(12),
                ),
                // ✅ EXACT React: Number badge in top-right corner
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundGray800.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: AppColors.textGray500,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
        
        // ✅ EXACT React: Dashed "Add Message" button (only if < 5 messages)
        if (_messageControllers.length < 5)
          GestureDetector(
            onTap: _addMessage,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.borderGray600,
                  width: 2,
                  style: BorderStyle.solid, // Dashed effect simulated
                ),
                borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '+',
                    style: TextStyle(
                      color: AppColors.textGray400,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Add Message',
                    style: TextStyle(
                      color: AppColors.textGray400,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  // ✅ ANALYZE BUTTON - Matches React: Purple gradient, requires 2+ messages
  Widget _buildAnalyzeButton() {
    // Debug logging
    print('🔍 Pattern Tab Debug:');
    print('  - Valid message count: $_validMessageCount');
    print('  - Total controllers: ${_messageControllers.length}');
    print('  - Button disabled: ${_validMessageCount < 2}');
    print('  - Is analyzing: $_isAnalyzing');
    
    // ✅ REUSED: GradientButton from Phase 3 with custom purple gradient
    return GradientButton(
      text: _isAnalyzing ? 'Analyzing pattern...' : 'Analyze Communication Pattern',
      isLoading: _isAnalyzing,
      disabled: _validMessageCount < 2, // Must have 2+ messages like React
      icon: _isAnalyzing ? null : const Text('🔍', style: TextStyle(fontSize: 18)),
      width: double.infinity,
      height: 56,
      // ✅ Custom gradient: Purple to Pink (different from scan/comebacks)
      gradient: const LinearGradient(
        colors: [AppColors.primaryPurple, AppColors.primaryPink],
      ),
      onPressed: () {
        print('🔍 Pattern Tab: Button pressed!');
        print('🔍 Pattern Tab: Valid messages: $_validMessageCount');
        _runPatternAnalysis();
      },
    );
  }

  // ✅ PATTERN RESULTS - Premium Design
  Widget _buildPatternResults() {
    return ResultCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Premium Header with Share Button
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors.borderGray600,
                  width: 0.5,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Communication Pattern Analysis',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Share Button
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Share feature coming soon!'),
                        backgroundColor: AppColors.primaryPink,
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryPink.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.primaryPink,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.share,
                          color: AppColors.primaryPink,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Share',
                          style: TextStyle(
                            color: AppColors.primaryPink,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Pattern Risk Score - Prominent Display
          _buildPatternScoreSection(),
          const SizedBox(height: 24),
          
          // Viral Insights
          _buildPremiumPatternSection(
            '🔥 VIRAL INSIGHTS',
            _analysis!.patternResult!.viralInsights.sussVerdict,
            AppColors.primaryCyan,
          ),
          const SizedBox(height: 16),
          
          // Life Saving Insight
          _buildPremiumPatternSection(
            '💡 LIFE SAVING INSIGHT',
            _analysis!.patternResult!.viralInsights.lifeSavingInsight,
            AppColors.successGreen,
          ),
          const SizedBox(height: 20),
          
          // Premium Branding
          _buildPremiumBranding(),
        ],
      ),
    );
  }

  Widget _buildPatternScoreSection() {
    final score = _analysis!.patternResult!.patternAnalysis.patternSeverityScore;
    final isHighRisk = score >= 60;
    final isCritical = score >= 80;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: isCritical 
            ? LinearGradient(colors: [AppColors.dangerRed, AppColors.dangerRed.withOpacity(0.8)])
            : isHighRisk
                ? LinearGradient(colors: [AppColors.warningOrange, AppColors.warningOrange.withOpacity(0.8)])
                : LinearGradient(colors: [AppColors.successGreen, AppColors.successGreen.withOpacity(0.8)]),
        borderRadius: BorderRadius.circular(AppConstants.largeRadius),
        border: Border.all(
          color: isCritical 
              ? AppColors.dangerRed.withOpacity(0.3)
              : isHighRisk
                  ? AppColors.warningOrange.withOpacity(0.3)
                  : AppColors.successGreen.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Text(
            '🧩 PATTERN RISK SCORE',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$score/100',
            style: TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            isCritical ? 'CRITICAL PATTERN' : isHighRisk ? 'HIGH RISK' : 'SAFE PATTERN',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumPatternSection(String title, String content, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: color,
            fontSize: 13,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w500,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildPremiumBranding() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppColors.borderGray600,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.compare_arrows,
            color: AppColors.primaryPink,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            'MySnitch AI',
            style: TextStyle(
              color: AppColors.primaryPink,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Helper method for pattern result sections
  Widget _buildPatternSection(String title, String content, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            height: 1.5,
          ),
        ),
      ],
    );
  }
} 