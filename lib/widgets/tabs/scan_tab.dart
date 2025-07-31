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
  String _selectedCategory = 'story';
  String _selectedTone = 'brutal';
  bool _isAnalyzing = false;
  AnalysisResult? _analysis;
  bool _showLieDetector = false;

  Future<void> _runAnalysis() async {
    if (_textController.text.trim().isEmpty) return;
    
    // Check if relationship is selected
    if (_relationshipController.text.trim().isEmpty) {
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
      // Call the AI service with relationship context
      final result = await ApiService.analyzeMessage(
        inputText: _textController.text.trim(),
        contentType: _selectedCategory,
        analysisGoal: 'lie_detection',
        tone: _selectedTone,
        comebackEnabled: true,
        relationship: _relationshipController.text.trim(),
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
          'RELATIONSHIP',
          style: TextStyle(
            color: AppColors.textGray400,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: _relationshipController,
                placeholder: 'e.g., Partner, Friend, Coworker, Ex...',
                padding: const EdgeInsets.all(12),
              ),
            ),
            const SizedBox(width: 8),
            PopupMenuButton<String>(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.backgroundGray800,
                  borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
                  border: Border.all(color: AppColors.borderGray600),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Presets',
                      style: TextStyle(
                        color: AppColors.textGray400,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_drop_down,
                      color: AppColors.textGray400,
                      size: 20,
                    ),
                  ],
                ),
              ),
              itemBuilder: (context) => [
                'Partner',
                'Friend',
                'Coworker',
                'Family',
                'Ex',
                'Stranger',
                'Date',
                'Roommate',
              ].map((relationship) => PopupMenuItem(
                value: relationship,
                child: Text(relationship),
              )).toList(),
              onSelected: (value) {
                setState(() {
                  _relationshipController.text = value;
                });
              },
            ),
          ],
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
    return GradientButton(
      text: _isAnalyzing ? 'Reading their mind...' : 'Scan',
      isLoading: _isAnalyzing,
      disabled: _textController.text.trim().isEmpty,
      icon: _isAnalyzing ? null : const Icon(Icons.flash_on, color: Colors.white),
      width: double.infinity,
      height: 56,
      onPressed: _runAnalysis,
    );
  }

  Widget _buildResults() {
    return ResultCard(
      child: Column(
        children: [
          // Headline
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors.borderGray600,
                  width: 0.5,
                ),
              ),
            ),
            child: Text(
              _analysis!.headline,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          
          // Primary Motive
          _buildResultSection(
            '🎯 PRIMARY MOTIVE:',
            _analysis!.motive,
            AppColors.primaryPink,
          ),
          const SizedBox(height: 20),
          
          // Red Flag Score
          _buildScoreSection(),
          const SizedBox(height: 20),
          
          // How it will make you feel
          _buildResultSection(
            '😬 HOW IT WILL MAKE YOU FEEL:',
            _analysis!.feeling,
            AppColors.warningOrange,
          ),
          const SizedBox(height: 20),
          
          // What they're not saying
          _buildResultSection(
            '🧠 WHAT THEY\'RE NOT SAYING:',
            _analysis!.subtext,
            AppColors.primaryPurple,
          ),
          const SizedBox(height: 20),
          
          // Pattern Recognition
          _buildPatternSection(),
          const SizedBox(height: 20),
          
          // Comeback
          _buildComebackSection(),
          const SizedBox(height: 20),
          
          // Lie Detector
          _buildLieDetectorSection(),
          const SizedBox(height: 40),
          
          // Watermark
          const WatermarkStamp(
            text: 'SocialLieDetector.com',
            icon: Icons.visibility,
          ),
        ],
      ),
    );
  }

  Widget _buildResultSection(String title, String content, Color color) {
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

  Widget _buildScoreSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '🚩 RED FLAG SCORE:',
          style: TextStyle(
            color: AppColors.dangerRed,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ScoreDisplay(score: _analysis!.redFlag),
      ],
    );
  }

  Widget _buildPatternSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.blueCyanGradient,
        borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
        border: Border.all(
          color: AppColors.primaryCyan.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🕵️ PATTERN RECOGNITION:',
            style: TextStyle(
              color: AppColors.primaryCyan,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _analysis!.pattern,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComebackSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.pinkPurpleGradient,
        borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
        border: Border.all(
          color: AppColors.primaryPink.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '💬 WHAT YOU COULD SAY BACK (${_selectedTone.toUpperCase()} MODE):',
            style: TextStyle(
              color: AppColors.primaryPink,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _analysis!.comeback,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.italic,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLieDetectorSection() {
    return ExpandableSection(
      initiallyExpanded: _showLieDetector,
      header: GestureDetector(
        onTap: () {
          setState(() {
            _showLieDetector = !_showLieDetector;
          });
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: AppColors.blueCyanGradient,
            borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
            border: Border.all(
              color: AppColors.primaryBlue.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🔍', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              Text(
                'Show Lie Detector Analysis',
                style: TextStyle(
                  color: AppColors.primaryBlue,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(top: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
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
              '🧪 LIE DETECTOR',
              style: TextStyle(
                color: AppColors.primaryBlue,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Verdict
            Row(
              children: [
                Text(
                  _analysis!.lieDetector.isHonest ? '✅' : '❌',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(width: 8),
                Text(
                  _analysis!.lieDetector.verdict,
                  style: TextStyle(
                    color: _analysis!.lieDetector.isHonest 
                        ? AppColors.successGreen 
                        : AppColors.dangerRed,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Suspicious Cues
            Text(
              '🔍 SUSPICIOUS CUES:',
              style: TextStyle(
                color: AppColors.primaryCyan,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...(_analysis!.lieDetector.cues.map((cue) => Padding(
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
                      cue,
                      style: TextStyle(
                        color: AppColors.textGray300,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ))),
            const SizedBox(height: 16),
            
            // Gut Check
            Text(
              '💡 GUT CHECK INSIGHT:',
              style: TextStyle(
                color: AppColors.primaryPurple,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '"${_analysis!.lieDetector.gutCheck}"',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 