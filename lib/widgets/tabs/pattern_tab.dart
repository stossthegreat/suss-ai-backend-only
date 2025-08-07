import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../common/custom_text_field.dart';
import '../common/gradient_button.dart';
import '../common/result_card.dart';
import '../../services/api_service.dart';
import '../../models/whisperfire_models.dart';

class PatternTab extends StatefulWidget {
  const PatternTab({super.key});

  @override
  State<PatternTab> createState() => _PatternTabState();
}

class _PatternTabState extends State<PatternTab> {
  final List<TextEditingController> _messageControllers = [];
  final TextEditingController _nameController = TextEditingController();
  String _selectedRelationship = 'Partner';
  String _selectedOutputMode = 'Intel';
  String _selectedTone = 'clinical';
  String _selectedModel = 'gpt-4-turbo';
  WhisperfireResponse? _analysis;
  bool _isAnalyzing = false;

  @override
  void initState() {
    super.initState();
    // Initialize with first message controller
    _addMessage();
    // Add listener to first controller
    if (_messageControllers.isNotEmpty) {
      _messageControllers[0].addListener(() {
        setState(() {}); // Rebuild to update button state
      });
    }
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
    print('Pattern Tab: _runPatternAnalysis() called!');
    
    // Get all valid messages
    final messages = _messageControllers
        .map((controller) => controller.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();

    print('Pattern Tab: Valid messages found: ${messages.length}');
    print('Pattern Tab: Messages: $messages');

    if (messages.isEmpty) {
      print('Pattern Tab: No valid messages, returning early');
      return;
    }

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
        relationship: _selectedRelationship,
        outputStyle: _selectedOutputMode.toLowerCase(),
        tone: _selectedTone.toLowerCase(),
        preferredModel: _selectedModel,
      );

      print('Pattern Tab: API call successful!');
      print('Pattern Tab: Result type: ${result.runtimeType}');
      print('Pattern Tab: Result patternResult is null: ${result.patternResult == null}');
      if (result.patternResult != null) {
        print('Pattern Tab: Pattern result headline: ${result.patternResult!.behavioralProfile.headline}');
        print('Pattern Tab: Pattern result archetype: ${result.patternResult!.behavioralProfile.manipulatorArchetype}');
      }

      if (mounted) {
        setState(() {
          _analysis = result;
          _isAnalyzing = false;
        });
        print('Pattern Tab: Set _analysis to result');
      }
    } catch (error) {
      print('Pattern analysis failed: $error');
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
          
          // Output Style Selector
          _buildOutputStyleSelector(),
          const SizedBox(height: 24),
          
          // Output Mode Selector
          _buildOutputModeSelector(),
          const SizedBox(height: 24),
          
          // Tone Selector
          _buildToneSelector(),
          const SizedBox(height: 24),
          
          // Model Selector
          _buildModelSelector(),
          const SizedBox(height: 24),
          
          // Analyze Button
          _buildAnalyzeButton(),
          const SizedBox(height: 24),
          
          // Pattern Results
          if (_analysis != null && _analysis!.patternResult != null) _buildPatternResults(),
          
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.compare_arrows,
              color: AppColors.primaryPurple,
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

  Widget _buildOutputStyleSelector() {
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
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedOutputMode = 'Intel';
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _selectedOutputMode == 'Intel'
                        ? AppColors.primaryPink.withOpacity(0.2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _selectedOutputMode == 'Intel'
                          ? AppColors.primaryPink
                          : AppColors.borderGray600,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.security,
                            color: _selectedOutputMode == 'Intel'
                                ? AppColors.primaryPink
                                : AppColors.textGray400,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Intel',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _selectedOutputMode == 'Intel'
                                  ? AppColors.primaryPink
                                  : AppColors.textWhite,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tactical analysis',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textGray400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedOutputMode = 'Narrative';
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _selectedOutputMode == 'Narrative'
                        ? AppColors.primaryCyan.withOpacity(0.2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _selectedOutputMode == 'Narrative'
                          ? AppColors.primaryCyan
                          : AppColors.borderGray600,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.article,
                            color: _selectedOutputMode == 'Narrative'
                                ? AppColors.primaryCyan
                                : AppColors.textGray400,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Narrative',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _selectedOutputMode == 'Narrative'
                                  ? AppColors.primaryCyan
                                  : AppColors.textWhite,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Story-driven',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textGray400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedOutputMode = 'Roast';
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _selectedOutputMode == 'Roast'
                        ? AppColors.warningOrange.withOpacity(0.2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _selectedOutputMode == 'Roast'
                          ? AppColors.warningOrange
                          : AppColors.borderGray600,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.local_fire_department,
                            color: _selectedOutputMode == 'Roast'
                                ? AppColors.warningOrange
                                : AppColors.textGray400,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Roast',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _selectedOutputMode == 'Roast'
                                  ? AppColors.warningOrange
                                  : AppColors.textWhite,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Viral & savage',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textGray400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
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

  // MODEL SELECTOR
  Widget _buildModelSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'AI MODEL',
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
              value: _selectedModel,
              isExpanded: true,
              dropdownColor: AppColors.backgroundGray800,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
              ),
              items: AppConstants.models.map((model) {
                return DropdownMenuItem<String>(
                  value: model,
                  child: Text(model),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedModel = value;
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  // ANALYZE BUTTON
  Widget _buildAnalyzeButton() {
    return GradientButton(
      text: _isAnalyzing ? 'Analyzing...' : 'Analyze Communication Pattern',
      isLoading: _isAnalyzing,
      disabled: _validMessageCount < 2, // Must have 2+ messages like React
      icon: _isAnalyzing ? null : const Icon(Icons.search, size: 18),
      width: double.infinity,
      height: 56,
      // Custom gradient: Purple to Pink (different from scan/comebacks)
      gradient: const LinearGradient(
        colors: [AppColors.primaryPurple, AppColors.primaryPink],
      ),
      onPressed: () async {
        print('Pattern Tab: Button pressed!');
        print('Pattern Tab: Valid messages: $_validMessageCount');
        
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
          print('Pattern Tab: Direct API call...');
          final result = await ApiService.analyzeMessageWhisperfire(
            inputText: messages.join('\n'),
            contentType: 'dm',
            analysisGoal: 'pattern_profiling',
            relationship: _selectedRelationship,
            outputStyle: _selectedOutputMode.toLowerCase(),
            tone: _selectedTone.toLowerCase(),
            preferredModel: _selectedModel,
          );

          print('Pattern Tab: Direct API call successful!');
          print('Pattern Tab: Result type: ${result.runtimeType}');
          print('Pattern Tab: Result patternResult is null: ${result.patternResult == null}');
          if (result.patternResult != null) {
            print('Pattern Tab: Pattern result headline: ${result.patternResult!.behavioralProfile.headline}');
          }

          if (mounted) {
            setState(() {
              _analysis = result;
              _isAnalyzing = false;
            });
            print('Pattern Tab: Set _analysis to result');
          }
        } catch (error) {
          print('Pattern Tab: Direct API call failed: $error');
          if (mounted) {
            setState(() {
              _isAnalyzing = false;
            });
          }
        }
      },
    );
  }

  // 🧠 PATTERN RESULTS - Comprehensive Behavioral Intelligence Report
  Widget _buildPatternResults() {
    final patternResult = _analysis!.patternResult!;
    
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
          
          // Behavioral Profile Section
          _buildIntelligenceSection(
            '🎭 BEHAVIORAL PROFILE',
            [
              'Headline: "${patternResult.behavioralProfile.headline}"',
              'Archetype: "${patternResult.behavioralProfile.manipulatorArchetype}"',
              'Dominant Pattern: "${patternResult.behavioralProfile.dominantPattern}"',
              'Sophistication Level: ${patternResult.behavioralProfile.manipulationSophistication}/100',
            ],
            AppColors.primaryPink,
          ),
          const SizedBox(height: 20),
          
          // Pattern Analysis Section
          _buildIntelligenceSection(
            '🔄 PATTERN ANALYSIS',
            [
              'Manipulation Cycle: "${patternResult.patternAnalysis.manipulationCycle}"',
              'Pattern Severity: ${patternResult.patternAnalysis.patternSeverityScore}/100',
              'Escalation Timeline: "${patternResult.patternAnalysis.escalationTimeline}"',
              'Trigger Events: ${patternResult.patternAnalysis.triggerEvents.length} identified',
            ],
            AppColors.primaryPurple,
          ),
          const SizedBox(height: 20),
          
          // Psychological Assessment Section
          _buildIntelligenceSection(
            '🧠 PSYCHOLOGICAL ASSESSMENT',
            [
              'Primary Agenda: "${patternResult.psychologicalAssessment.primaryAgenda}"',
              'Emotional Damage: "${patternResult.psychologicalAssessment.emotionalDamageInflicted}"',
              'Reality Distortion: ${patternResult.psychologicalAssessment.realityDistortionLevel}%',
              'Psychological Damage Score: ${patternResult.psychologicalAssessment.psychologicalDamageScore}/100',
            ],
            AppColors.warningOrange,
          ),
          const SizedBox(height: 20),
          
          // Risk Assessment Section
          _buildIntelligenceSection(
            '🚨 RISK ASSESSMENT',
            [
              'Escalation Probability: ${patternResult.riskAssessment.escalationProbability}%',
              'Intervention Urgency: ${patternResult.riskAssessment.interventionUrgency}',
              'Relationship Prognosis: "${patternResult.riskAssessment.relationshipPrognosis}"',
              'Future Behavior: "${patternResult.riskAssessment.futureBehaviorPrediction}"',
            ],
            AppColors.dangerRed,
          ),
          const SizedBox(height: 20),
          
          // Strategic Recommendations Section
          _buildIntelligenceSection(
            '🛡️ STRATEGIC RECOMMENDATIONS',
            [
              'Boundary Strategy: "${patternResult.strategicRecommendations.boundaryEnforcementStrategy}"',
              'Communication Guidelines: "${patternResult.strategicRecommendations.communicationGuidelines}"',
              'Escape Strategy: "${patternResult.strategicRecommendations.escapeStrategy}"',
              'Safety Planning: "${patternResult.strategicRecommendations.safetyPlanning}"',
            ],
            AppColors.successGreen,
          ),
          const SizedBox(height: 20),
          
          // Viral Insights Section
          _buildIntelligenceSection(
            '🔥 VIRAL INSIGHTS',
            [
              'Suss Verdict: "${patternResult.viralInsights.sussVerdict}"',
              'Life-Saving Insight: "${patternResult.viralInsights.lifeSavingInsight}"',
              'Pattern Summary: "${patternResult.viralInsights.patternSummary}"',
              'Gut Validation: "${patternResult.viralInsights.gutValidation}"',
            ],
            AppColors.primaryCyan,
          ),
          const SizedBox(height: 20),
          
          // Confidence Metrics Section
          _buildIntelligenceSection(
            '📊 CONFIDENCE METRICS',
            [
              'Analysis Confidence: ${patternResult.confidenceMetrics.analysisConfidence}%',
              'Prediction Confidence: ${patternResult.confidenceMetrics.predictionConfidence}%',
              'Evidence Quality: ${patternResult.confidenceMetrics.evidenceQuality}',
              'Viral Potential: ${patternResult.confidenceMetrics.viralPotential}/100',
            ],
            AppColors.primaryPurple,
          ),
          const SizedBox(height: 24),
          
          // Final Assessment
          _buildFinalAssessment(patternResult),
          const SizedBox(height: 24),
          
          // Premium Branding
          _buildPremiumBranding(),
        ],
      ),
    );
  }

  // 🎯 INTELLIGENCE SECTION BUILDER
  Widget _buildIntelligenceSection(String title, List<String> items, Color accentColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.backgroundGray800.withOpacity(0.5),
        borderRadius: BorderRadius.circular(AppConstants.largeRadius),
        border: Border.all(
          color: accentColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  title,
                  style: TextStyle(
                    color: accentColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.only(top: 6, right: 12),
                  decoration: BoxDecoration(
                    color: accentColor,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Text(
                    item,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  // 🎯 FINAL ASSESSMENT
  Widget _buildFinalAssessment(WhisperfirePatternResult patternResult) {
    final severityScore = patternResult.patternAnalysis.patternSeverityScore;
    final isHighRisk = severityScore >= 60;
    final isCritical = severityScore >= 80;
    
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isCritical ? Icons.warning : isHighRisk ? Icons.info : Icons.check_circle,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                isCritical ? '🚨 CRITICAL THREAT DETECTED' : isHighRisk ? '⚠️ HIGH RISK PATTERN' : '✅ MODERATE RISK',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            isCritical 
                ? 'This pattern indicates severe psychological manipulation requiring immediate intervention.'
                : isHighRisk
                    ? 'This pattern shows concerning manipulation tactics that require attention.'
                    : 'This pattern shows some concerning elements but may be manageable.',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // 🎯 PREMIUM BRANDING
  Widget _buildPremiumBranding() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
      ),
      child: Row(
        children: [
          Icon(
            Icons.psychology,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            'Powered by PATTERN.AI - Advanced Behavioral Intelligence',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
} 