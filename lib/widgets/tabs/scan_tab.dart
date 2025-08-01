import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../utils/mock_data.dart';
import '../../models/analysis_result.dart';
import '../../services/api_service.dart';
import '../common/custom_text_field.dart';
import '../common/gradient_button.dart';
import '../common/outlined_button.dart';
import '../common/result_card.dart';
import '../common/score_display.dart';
import '../common/expandable_section.dart';
import '../common/watermark_stamp.dart';

class ScanTab extends StatefulWidget {
  const ScanTab({super.key});

  @override
  State<ScanTab> createState() => _ScanTabState();
}

class _ScanTabState extends State<ScanTab> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _relationshipController = TextEditingController();
  String _selectedCategory = 'dm'; // Updated default to DM
  String _selectedTone = 'brutal';
  String _selectedRelationship = 'Partner'; // New relationship context
  String _selectedAnalysisGoal = 'instant_scan'; // New analysis goal
  bool _isAnalyzing = false;
  AnalysisResult? _analysis;
  bool _showLieDetector = false;

  @override
  void initState() {
    super.initState();
    // Add listeners to update button state when text changes
    _textController.addListener(() {
      setState(() {}); // Rebuild to update button state
    });
    _relationshipController.addListener(() {
      setState(() {}); // Rebuild to update button state
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _relationshipController.dispose();
    super.dispose();
  }

  Future<void> _runAnalysis() async {
    if (_textController.text.trim().isEmpty) return;
    
    // Check if relationship is selected
    if (_selectedRelationship.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a relationship type'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    
    setState(() {
      _isAnalyzing = true;
      _analysis = null;
      _showLieDetector = false;
    });

    try {
      // Call the WHISPERFIRE API service
      final result = await ApiService.analyzeMessageWhisperfire(
        inputText: _textController.text.trim(),
        contentType: _selectedCategory,
        analysisGoal: _selectedAnalysisGoal,
        tone: _selectedTone,
        relationship: _selectedRelationship,
      );

      if (mounted) {
        setState(() {
          _analysis = result;
          _isAnalyzing = false;
        });
      }
    } catch (error) {
      print('❌ Scan analysis failed: $error');
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
        });
        // Show error message to user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Analysis failed: ${error.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
          
          // Relationship Field
          _buildRelationshipField(),
          const SizedBox(height: 24),
          
          // Input Section
          _buildInputSection(),
          const SizedBox(height: 24),
          
          // Category Selector
          _buildCategorySelector(),
          const SizedBox(height: 20),
          
          // Analysis Goal Selector
          _buildAnalysisGoalSelector(),
          const SizedBox(height: 20),
          
          // Tone Style Selector
          _buildToneSelector(),
          const SizedBox(height: 24),
          
          // Scan Button
          _buildScanButton(),
          const SizedBox(height: 24),
          
          // Results
          if (_analysis != null) _buildResults(),
          
          const SizedBox(height: 100), // Bottom padding for tab bar
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.visibility,
              color: AppColors.primaryPink,
              size: 32,
            ),
            const SizedBox(width: 8),
            ShaderMask(
              shaderCallback: (bounds) => AppColors.primaryGradient.createShader(bounds),
              child: const Text(
                'MySnitch AI',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Expose what they\'re really saying',
          style: TextStyle(
            color: AppColors.textGray400,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildRelationshipField() {
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

  Widget _buildInputSection() {
    return CustomTextField(
      controller: _textController,
      placeholder: 'Paste their story, bio, or message here...',
      maxLines: 8,
      padding: const EdgeInsets.all(16),
    );
  }

  Widget _buildCategorySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CONTENT TYPE',
          style: TextStyle(
            color: AppColors.textGray400,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: AppConstants.categories.map((category) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: CustomOutlinedButton(
                  text: category.label,
                  isSelected: _selectedCategory == category.id,
                  selectedColor: AppColors.primaryPink,
                  onPressed: () {
                    setState(() {
                      _selectedCategory = category.id;
                    });
                  },
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAnalysisGoalSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ANALYSIS GOAL',
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
              value: _selectedAnalysisGoal,
              isExpanded: true,
              dropdownColor: AppColors.backgroundGray800,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              items: AppConstants.analysisGoals.map((goal) {
                return DropdownMenuItem<String>(
                  value: goal.id,
                  child: Row(
                    children: [
                      Text(goal.label),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          goal.desc,
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
                    _selectedAnalysisGoal = value;
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToneSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ANALYSIS STYLE',
          style: TextStyle(
            color: AppColors.textGray400,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: AppConstants.toneStyles.map((tone) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: CustomOutlinedButton(
                  text: '',
                  isSelected: _selectedTone == tone.id,
                  selectedColor: AppColors.primaryPurple,
                  onPressed: () {
                    setState(() {
                      _selectedTone = tone.id;
                    });
                  },
                  child: Column(
                    children: [
                      Text(
                        tone.label,
                        style: TextStyle(
                          color: _selectedTone == tone.id
                              ? AppColors.primaryPurple
                              : AppColors.textGray400,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        tone.desc,
                        style: TextStyle(
                          color: (_selectedTone == tone.id
                                  ? AppColors.primaryPurple
                                  : AppColors.textGray400)
                              .withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildScanButton() {
    // Check if both text and relationship are filled
    final hasText = _textController.text.trim().isNotEmpty;
    final hasRelationship = _relationshipController.text.trim().isNotEmpty;
    final isReady = hasText && hasRelationship;
    
    return GradientButton(
      text: _isAnalyzing ? 'Reading their mind...' : 'Scan',
      isLoading: _isAnalyzing,
      disabled: !isReady, // Only enable when both fields are filled
      icon: _isAnalyzing ? null : const Icon(Icons.flash_on, color: Colors.white),
      width: double.infinity,
      height: 56,
      onPressed: _runAnalysis,
    );
  }

  Widget _buildResults() {
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
                    _analysis!.headline,
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
                    // TODO: Implement share functionality
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
          
          // Red Flag Score - Prominent Display
          _buildPremiumScoreSection(),
          const SizedBox(height: 24),
          
          // Primary Motive
          _buildPremiumSection(
            '🎯 PRIMARY MOTIVE',
            _analysis!.motive,
            AppColors.primaryPink,
          ),
          const SizedBox(height: 16),
          
          // How it will make you feel
          _buildPremiumSection(
            '😬 EMOTIONAL IMPACT',
            _analysis!.feeling,
            AppColors.warningOrange,
          ),
          const SizedBox(height: 16),
          
          // What they're not saying
          _buildPremiumSection(
            '🧠 HIDDEN SUBTEXT',
            _analysis!.subtext,
            AppColors.primaryPurple,
          ),
          const SizedBox(height: 16),
          
          // Pattern Recognition
          _buildPremiumSection(
            '🕵️ PATTERN RECOGNITION',
            _analysis!.pattern,
            AppColors.primaryCyan,
          ),
          const SizedBox(height: 16),
          
          // Comeback - Prominent Display
          _buildPremiumComebackSection(),
          const SizedBox(height: 20),
          
          // Lie Detector - Always Visible
          _buildPremiumLieDetectorSection(),
          const SizedBox(height: 24),
          
          // Premium Branding
          _buildPremiumBranding(),
        ],
      ),
    );
  }

  Widget _buildPremiumScoreSection() {
    final score = _analysis!.redFlag;
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
            '🚩 RED FLAG SCORE',
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
            isCritical ? 'CRITICAL RISK' : isHighRisk ? 'HIGH RISK' : 'SAFE ZONE',
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

  Widget _buildPremiumSection(String title, String content, Color color) {
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

  Widget _buildPremiumComebackSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.pinkPurpleGradient,
        borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
        border: Border.all(
          color: AppColors.primaryPink.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '💬 YOUR COMEBACK (${_selectedTone.toUpperCase()} MODE)',
            style: TextStyle(
              color: AppColors.primaryPink,
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _analysis!.comeback,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.italic,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumLieDetectorSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.blueCyanGradient,
        borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
        border: Border.all(
          color: AppColors.primaryBlue.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '🧪 LIE DETECTOR',
                style: TextStyle(
                  color: AppColors.primaryBlue,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              Text(
                _analysis!.lieDetector.isHonest ? '✅ HONEST' : '❌ DISHONEST',
                style: TextStyle(
                  color: _analysis!.lieDetector.isHonest ? AppColors.successGreen : AppColors.dangerRed,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _analysis!.lieDetector.verdict,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
          ),
          if (_analysis!.lieDetector.cues.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              'Evidence:',
              style: TextStyle(
                color: AppColors.primaryBlue.withOpacity(0.8),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            ...(_analysis!.lieDetector.cues.map((cue) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '•',
                    style: TextStyle(
                      color: AppColors.primaryBlue,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      cue,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 13,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ))),
          ],
        ],
      ),
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
            Icons.visibility,
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
} 