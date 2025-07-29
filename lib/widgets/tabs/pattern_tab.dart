import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../utils/mock_data.dart';
import '../../models/pattern_analysis.dart';
import '../common/custom_text_field.dart';
import '../common/gradient_button.dart';
import '../common/result_card.dart';
import '../common/watermark_stamp.dart';

class PatternTab extends StatefulWidget {
  const PatternTab({super.key});

  @override
  State<PatternTab> createState() => _PatternTabState();
}

class _PatternTabState extends State<PatternTab> {
  // ✅ REUSED from Phase 2 & 3: 
  // - TextEditingController for person name + messages
  // - MockData.getMockPatternAnalysis() for realistic pattern results
  // - AppConstants.patternAnalysisAnimation for 3200ms delay
  final TextEditingController _nameController = TextEditingController();
  final List<TextEditingController> _messageControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  bool _isAnalyzing = false;
  PatternAnalysis? _patternAnalysis;

  Future<void> _analyzePattern() async {
    final validMessages = _messageControllers
        .where((controller) => controller.text.trim().isNotEmpty)
        .length;
    
    if (validMessages < 2) return; // Need at least 2 messages like React

    setState(() {
      _isAnalyzing = true;
      _patternAnalysis = null;
    });

    // ✅ REUSED: AppConstants.patternAnalysisAnimation (3200ms - longer than scan)
    await Future.delayed(AppConstants.patternAnalysisAnimation);

    if (mounted) {
      setState(() {
        // ✅ REUSED: MockData.getMockPatternAnalysis() with exact React data
        _patternAnalysis = MockData.getMockPatternAnalysis();
        _isAnalyzing = false;
      });
    }
  }

  void _addMessage() {
    if (_messageControllers.length < 7) { // Max 7 messages like React
      setState(() {
        _messageControllers.add(TextEditingController());
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
          // Header Section - EXACTLY like React
          _buildHeader(),
          const SizedBox(height: 24),
          
          // Person Name Field - EXACTLY like React optional input
          _buildPersonNameField(),
          const SizedBox(height: 24),
          
          // Message Stack - EXACTLY like React dynamic list (up to 7)
          _buildMessageStack(),
          const SizedBox(height: 24),
          
          // Analyze Button - EXACTLY like React purple gradient
          _buildAnalyzeButton(),
          const SizedBox(height: 24),
          
          // Pattern Results - EXACTLY like React pattern analysis card
          if (_patternAnalysis != null) _buildPatternResults(),
          
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
          'MESSAGES ($_validMessageCount/7)',
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
        
        // ✅ EXACT React: Dashed "Add Message" button (only if < 7 messages)
        if (_messageControllers.length < 7)
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
      onPressed: _analyzePattern,
    );
  }

  // ✅ PATTERN RESULTS - Matches React: Complete pattern analysis card
  Widget _buildPatternResults() {
    final personName = _nameController.text.trim();
    
    // ✅ REUSED: ResultCard from Phase 3 with glassmorphism + share button
    return ResultCard(
      child: Column(
        children: [
          // ✅ EXACT React: Header with person name + score
          Column(
            children: [
              Text(
                personName.isNotEmpty 
                    ? '$personName\'s Pattern' 
                    : 'Communication Pattern',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              // ✅ EXACT React: Large score display
              Text(
                '${_patternAnalysis!.compositeRedFlagScore}/100',
                style: TextStyle(
                  color: AppColors.getScoreColor(_patternAnalysis!.compositeRedFlagScore),
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // ✅ EXACT React: Dominant Motive section
          _buildPatternSection(
            '🎯 DOMINANT MOTIVE:',
            _patternAnalysis!.dominantMotive,
            AppColors.primaryPurple,
          ),
          const SizedBox(height: 20),
          
          // ✅ EXACT React: Pattern Type section  
          _buildPatternSection(
            '🔁 PATTERN TYPE:',
            _patternAnalysis!.patternType,
            AppColors.primaryPink,
          ),
          const SizedBox(height: 20),
          
          // ✅ EXACT React: Emotional Summary section
          _buildPatternSection(
            '😔 EMOTIONAL SUMMARY:',
            _patternAnalysis!.emotionalSummary,
            AppColors.warningOrange,
          ),
          const SizedBox(height: 20),
          
          // ✅ EXACT React: Lie Detector for Pattern section
          _buildPatternLieDetector(),
          const SizedBox(height: 40),
          
          // ✅ EXACT React: Watermark with compare arrows icon
          const WatermarkStamp(
            text: 'SocialLieDetector.com',
            icon: Icons.compare_arrows, // Different icon for pattern tab
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

  // ✅ EXACT React: Lie Detector section for patterns (blue gradient)
  Widget _buildPatternLieDetector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // ✅ REUSED: AppColors.blueCyanGradient from Phase 1
        gradient: AppColors.blueCyanGradient,
        borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
        border: Border.all(
          color: AppColors.primaryBlue.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🧪 LIE DETECTOR ANALYSIS',
            style: TextStyle(
              color: AppColors.primaryBlue,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          
          // ✅ EXACT React: Verdict with checkmark/X
          Row(
            children: [
              Text(
                _patternAnalysis!.lieDetector.isHonest ? '✅' : '❌',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(width: 8),
              Text(
                _patternAnalysis!.lieDetector.verdict, // "Likely Dishonest Pattern"
                style: TextStyle(
                  color: _patternAnalysis!.lieDetector.isHonest 
                      ? AppColors.successGreen 
                      : AppColors.dangerRed,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // ✅ EXACT React: Suspicious Cues list (pattern-specific)
          ...(_patternAnalysis!.lieDetector.cues.map((cue) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '•',
                  style: TextStyle(
                    color: AppColors.warningOrange,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    cue, // Pattern-specific cues from MockData
                    style: TextStyle(
                      color: AppColors.textGray300,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ))),
          const SizedBox(height: 12),
          
          // ✅ EXACT React: Gut Check insight (quoted)
          Text(
            '"${_patternAnalysis!.lieDetector.gutCheck}"',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
} 