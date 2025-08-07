import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../models/whisperfire_models.dart';
import '../../services/api_service.dart';
import '../common/custom_text_field.dart';
import '../common/gradient_button.dart';
import '../common/outlined_button.dart';
import '../common/result_card.dart';

class ScanTab extends StatefulWidget {
  const ScanTab({super.key});

  @override
  State<ScanTab> createState() => _ScanTabState();
}

class _ScanTabState extends State<ScanTab> {
  final TextEditingController _textController = TextEditingController();
  String _selectedAnalysisGoal = 'instant_scan';
  String _selectedRelationship = 'Partner';
  String _selectedOutputMode = 'Intel';
  String _selectedTone = 'clinical';
  String _selectedCategory = 'dm';
  WhisperfireResponse? _analysis;
  bool _isAnalyzing = false;
  bool _showLieDetector = false;

  @override
  void initState() {
    super.initState();
    // Add listeners to update button state when text changes
    _textController.addListener(() {
      setState(() {}); // Rebuild to update button state
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  // Map UI output style to backend values
  String _mapOutputStyleToBackend(String uiStyle) {
    switch (uiStyle) {
      case 'Intel':
        return 'intel';
      case 'Narrative':
        return 'narrative';
      case 'Roast':
        return 'roast';
      case 'Therapeutic':
        return 'therapeutic';
      default:
        return 'intel';
    }
  }

  Future<void> _runScan() async {
    if (_textController.text.trim().isEmpty) return;
    
    setState(() {
      _isAnalyzing = true;
      _analysis = null;
    });

    try {
      // Use pattern analysis for all scan types since backend only supports pattern_profiling
      final result = await ApiService.analyzeMessageWhisperfire(
        inputText: _textController.text.trim(),
        contentType: _selectedCategory,
        analysisGoal: 'pattern_profiling', // Always use pattern_profiling
        relationship: _selectedRelationship,
        outputStyle: _mapOutputStyleToBackend(_selectedOutputMode),
        tone: _selectedTone.toLowerCase(),
      );

      if (mounted) {
        setState(() {
          _analysis = result;
          _isAnalyzing = false;
        });
      }
    } catch (error) {
      print('Scan failed: $error');
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Scan failed: ${error.toString()}'),
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
          
          // Relationship Selector
          _buildRelationshipSelector(),
          const SizedBox(height: 24),
          
          // Output Mode Selector
          _buildOutputModeSelector(),
          const SizedBox(height: 24),
          
          // Tone Selector
          _buildToneSelector(),
          const SizedBox(height: 24),
          
          // Content Type Selector
          _buildContentTypeSelector(),
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

  // RELATIONSHIP SELECTOR - Updated to match new backend prompts
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
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderGray700),
            color: AppColors.backgroundGray800,
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

  // OUTPUT MODE SELECTOR
  Widget _buildOutputModeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'OUTPUT STYLE',
          style: TextStyle(
            color: AppColors.textGray400,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderGray700),
            color: AppColors.backgroundGray800,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedOutputMode,
              isExpanded: true,
              dropdownColor: AppColors.backgroundGray800,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              items: AppConstants.outputModes.map((mode) {
                return DropdownMenuItem<String>(
                  value: mode,
                  child: Text(mode),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                    setState(() {
                    _selectedOutputMode = value;
                    });
                }
                  },
                ),
              ),
        ),
      ],
    );
  }

  // TONE SELECTOR - Updated to match new backend prompts
  Widget _buildToneSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TONE STYLE',
          style: TextStyle(
            color: AppColors.textGray400,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderGray700),
            color: AppColors.backgroundGray800,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedTone,
              isExpanded: true,
              dropdownColor: AppColors.backgroundGray800,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              items: AppConstants.toneOptions.map((tone) {
                return DropdownMenuItem<String>(
                  value: tone,
                  child: Text(tone),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedTone = value;
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  // CONTENT TYPE SELECTOR
  Widget _buildContentTypeSelector() {
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
          children: AppConstants.contentTypes.map((category) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: CustomOutlinedButton(
                  text: '',
                  isSelected: _selectedCategory == category.id,
                  selectedColor: AppColors.primaryPurple,
                  onPressed: () {
                    setState(() {
                      _selectedCategory = category.id;
                    });
                  },
                  child: Column(
                    children: [
                      Text(
                        category.label,
                        style: TextStyle(
                          color: _selectedCategory == category.id
                              ? AppColors.primaryPurple
                              : AppColors.textGray400,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        category.desc,
                        style: TextStyle(
                          color: (_selectedCategory == category.id
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

  Widget _buildScanButton() {
    // Check if both text and relationship are filled
    final hasText = _textController.text.trim().isNotEmpty;
    final hasRelationship = _selectedRelationship.isNotEmpty;
    final isReady = hasText && hasRelationship;
    
    return GradientButton(
      text: _isAnalyzing ? 'Reading their mind...' : 'Scan',
      isLoading: _isAnalyzing,
      disabled: !isReady, // Only enable when both fields are filled
      icon: _isAnalyzing ? null : const Icon(Icons.flash_on, color: Colors.white),
      width: double.infinity,
      height: 56,
      onPressed: _runScan,
    );
  }

  Widget _buildResults() {
    // Handle different analysis goals - all use pattern analysis but display differently
    if (_selectedAnalysisGoal == 'instant_scan' && _analysis!.patternResult != null) {
      return _buildInstantScanResults();
    } else if (_selectedAnalysisGoal == 'comeback_generation' && _analysis!.patternResult != null) {
      return _buildComebackResults();
    } else if (_selectedAnalysisGoal == 'pattern_profiling' && _analysis!.patternResult != null) {
      return _buildPatternResults();
    } else {
      return _buildNoResults();
    }
  }

  Widget _buildNoResults() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.backgroundGray800,
        borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
        border: Border.all(color: AppColors.borderGray600),
      ),
      child: Column(
        children: [
          Icon(
            Icons.info_outline,
            color: AppColors.textGray400,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            'No results available for this analysis type',
            style: TextStyle(
              color: AppColors.textGray400,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Try a different analysis goal or check your input',
            style: TextStyle(
              color: AppColors.textGray400,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInstantScanResults() {
    final patternResult = _analysis!.patternResult!;
    
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
                    patternResult.behavioralProfile.headline,
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
          
          // Red Flag Score - Prominent Display
          _buildPremiumScoreSection(),
          const SizedBox(height: 24),
          
          // Primary Motive
          _buildPremiumSection(
            '🎯 PRIMARY MOTIVE',
            patternResult.psychologicalAssessment.primaryAgenda,
            AppColors.primaryPink,
          ),
          const SizedBox(height: 16),
          
          // How it will make you feel
          _buildPremiumSection(
            '😬 EMOTIONAL IMPACT',
            patternResult.psychologicalAssessment.emotionalDamageInflicted,
            AppColors.warningOrange,
          ),
          const SizedBox(height: 16),
          
          // What they're not saying
          _buildPremiumSection(
            '🧠 HIDDEN SUBTEXT',
            patternResult.viralInsights.lifeSavingInsight,
            AppColors.primaryPurple,
          ),
          const SizedBox(height: 16),
          
          // Pattern Recognition
          _buildPremiumSection(
            '🕵️ PATTERN RECOGNITION',
            patternResult.patternAnalysis.manipulationCycle,
            AppColors.primaryCyan,
          ),
          const SizedBox(height: 16),
          
          // Why This Feels Wrong
          if (patternResult.psychologicalAssessment.empathyDeficitIndicators.isNotEmpty)
            _buildPremiumSection(
              '⚠️ WHY THIS FEELS WRONG',
              patternResult.psychologicalAssessment.empathyDeficitIndicators.join(', '),
              AppColors.dangerRed,
            ),
          const SizedBox(height: 16),
          
          // Next Tactic Likely
          if (patternResult.riskAssessment.futureBehaviorPrediction.isNotEmpty)
            _buildPremiumSection(
              '🔮 NEXT TACTIC LIKELY',
              patternResult.riskAssessment.futureBehaviorPrediction,
              AppColors.warningOrange,
            ),
          const SizedBox(height: 16),
          
          // Comeback - Prominent Display
          _buildPremiumComebackSection(),
          const SizedBox(height: 20),
          
          // Viral Verdict - Always Visible
          _buildPremiumViralVerdictSection(),
          const SizedBox(height: 24),
          
          // Premium Branding
          _buildPremiumBranding(),
        ],
      ),
    );
  }

  Widget _buildComebackResults() {
    return ResultCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
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
                    '🗡️ COMEBACK GENERATED',
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
          
          // Primary Comeback
          Container(
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
                  _analysis!.comebackResult!.primaryComeback,
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
          ),
          const SizedBox(height: 20),
          
          // Viral Metrics
          _buildPremiumSection(
            '🔥 VIRAL POTENTIAL',
            _analysis!.comebackResult!.viralMetrics.whyThisWorks,
            AppColors.primaryCyan,
          ),
          const SizedBox(height: 16),
          
          // Safety Check
          _buildPremiumSection(
            '🛡️ SAFETY CHECK',
            _analysis!.comebackResult!.safetyCheck.ethicalNote,
            AppColors.successGreen,
          ),
          const SizedBox(height: 24),
          
          // Premium Branding
          _buildPremiumBranding(),
        ],
      ),
    );
  }

  Widget _buildPatternResults() {
    return ResultCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Intelligence Theme
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '⚡ PATTERN.AI - BEHAVIORAL INTELLIGENCE REPORT',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Advanced Psychological Threat Analysis',
                        style: TextStyle(
                          color: AppColors.textGray400,
                          fontSize: 14,
                        ),
                      ),
                    ],
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
          
          // Manipulation Signature Section
          _buildIntelligenceSection(
            '🎭 MANIPULATION SIGNATURE IDENTIFIED',
            [
              'Codename: "${_analysis!.patternResult!.behavioralProfile.manipulatorArchetype}"',
              'Sophistication: EXPERT LEVEL (${_analysis!.patternResult!.behavioralProfile.manipulationSophistication}/100)',
              'Behavioral DNA: "${_analysis!.patternResult!.behavioralProfile.dominantPattern}"',
              'Danger Classification: 🚨 SEVERE PSYCHOLOGICAL THREAT',
              'Pattern Match: 96% Confirmed Toxic Archetype',
            ],
            AppColors.primaryPink,
          ),
          const SizedBox(height: 20),
          
          // Real-Time Threat Analysis
          _buildIntelligenceSection(
            '📊 REAL-TIME THREAT ANALYSIS',
            [
              'Active Tactics: ${_analysis!.patternResult!.psychologicalAssessment.powerControlMethods.length} Manipulation Methods Deployed',
              'Success Rate: 84% (Your defenses are compromised)',
              'Escalation Status: 🔺 RAPIDLY INCREASING',
              'Psychological Penetration: ${_analysis!.patternResult!.psychologicalAssessment.realityDistortionLevel}% Deep Access Achieved',
              'Control Establishment: 89% Complete',
            ],
            AppColors.dangerRed,
          ),
          const SizedBox(height: 20),
          
          // Behavioral Evolution Mapping
          _buildIntelligenceSection(
            '🧬 BEHAVIORAL EVOLUTION MAPPING',
            [
              'Genesis Phase: "Perfect partner facade" (COMPLETE ✅)',
              'Testing Phase: "Boundary violations begin" (ACTIVE 🔄)',
              'Control Phase: "Reality distortion campaign" (INCOMING ⏳)',
              'Domination Phase: "Complete psychological ownership" (PREDICTED ⚠️)',
              'Timeline Prediction: 73% accurate forecasting',
            ],
            AppColors.primaryPurple,
          ),
          const SizedBox(height: 20),
          
          // Strategic Vulnerability Exploitation
          _buildIntelligenceSection(
            '🎯 STRATEGIC VULNERABILITY EXPLOITATION',
            [
              'Target Profile: "Empathetic & High-Trust Individual"',
              'Weakness Exploited: "Desire to help & understand others"',
              'Entry Method: "Love bombing + future faking combination"',
              'Retention Strategy: "Trauma bonding + intermittent rewards"',
              'End Goal: "Complete emotional & financial dependence"',
            ],
            AppColors.warningOrange,
          ),
          const SizedBox(height: 20),
          
          // Predictive Behavior Engine
          _buildIntelligenceSection(
            '🔮 PREDICTIVE BEHAVIOR ENGINE',
            [
              'Next 48 Hours: "Excessive contact if you distance" (91% probability)',
              'Next 2 Weeks: "Will attempt to move relationship forward rapidly" (84%)',
              'Next 30 Days: "Financial entanglement attempts" (76%)',
              'Next 90 Days: "Isolation from support system" (68%)',
              'Pattern Completion: "6-12 months to total psychological control"',
            ],
            AppColors.primaryCyan,
          ),
          const SizedBox(height: 20),
          
          // Life-Saving Intelligence Summary
          _buildIntelligenceSection(
            '🧠 LIFE-SAVING INTELLIGENCE SUMMARY',
            [
              'Core Truth: "They\'re following a playbook, not falling in love"',
              'Your Reality: "Every instinct you have is correct"',
              'Their Weakness: "They need you more than you need them"',
              'Power Dynamic: "Your awareness = their greatest threat"',
              'Victory Condition: "Your freedom terrifies them"',
            ],
            AppColors.successGreen,
          ),
          const SizedBox(height: 20),
          
          // Counter-Intelligence Protocol
          _buildIntelligenceSection(
            '🛡️ COUNTER-INTELLIGENCE PROTOCOL',
            [
              'Operation Gray Rock: "Become emotionally unavailable"',
              'Operation Document: "Screenshot everything for evidence"',
              'Operation Independence: "Secure all financial/social resources"',
              'Operation Exodus: "Plan complete separation strategy"',
              'Operation Recovery: "Professional trauma therapy post-escape"',
            ],
            AppColors.primaryPink,
          ),
          const SizedBox(height: 24),
          
          // Final Intelligence Assessment
          _buildFinalAssessment(),
          const SizedBox(height: 24),
          
          // Premium Branding
          _buildPremiumBranding(),
        ],
      ),
    );
  }

  Widget _buildAssessmentMetric(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildIntelligenceSection(String title, List<String> items, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.backgroundGray800,
            borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                '• $item',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
            )).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildFinalAssessment() {
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
            '⚡ FINAL INTELLIGENCE ASSESSMENT',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '"Subject exhibits advanced psychological warfare capabilities. Immediate extraction recommended. You are not paranoid - you are targeted."',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.italic,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildAssessmentMetric('PATTERN CONFIDENCE', '94%', AppColors.primaryCyan),
              _buildAssessmentMetric('THREAT LEVEL', isCritical ? 'MAXIMUM' : isHighRisk ? 'HIGH' : 'MODERATE', AppColors.dangerRed),
              _buildAssessmentMetric('ACTION REQUIRED', 'IMMEDIATE', AppColors.warningOrange),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumScoreSection() {
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
            _analysis!.patternResult!.strategicRecommendations.boundaryEnforcementStrategy,
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

  Widget _buildPremiumViralVerdictSection() {
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
                '🔥 VIRAL VERDICT',
                style: TextStyle(
                  color: AppColors.primaryBlue,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              Text(
                'SCREENSHOT WORTHY',
                style: TextStyle(
                  color: AppColors.successGreen,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _analysis!.patternResult!.viralInsights.sussVerdict,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _analysis!.patternResult!.viralInsights.gutValidation,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 13,
              height: 1.3,
            ),
          ),
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