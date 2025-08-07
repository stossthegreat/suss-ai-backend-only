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
        outputStyle: _mapOutputStyleToBackend(_selectedOutputMode),
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

  // Map UI output style to backend values
  String _mapOutputStyleToBackend(String uiStyle) {
    switch (uiStyle) {
      case 'Intel':
        return 'intel';
      case 'Narrative':
        return 'narrative';
      case 'Roast':
        return 'roast';
      default:
        return 'intel';
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
          
          // Relationship Context Selector
          _buildRelationshipSelector(),
          const SizedBox(height: 24),
          
          // Message Stack
          _buildMessageStack(),
          const SizedBox(height: 24),
          
          // Output Style Selector
          _buildOutputStyleSelector(),
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

  // OUTPUT STYLE SELECTOR - Button-based selector (removed dropdown)
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
            outputStyle: _mapOutputStyleToBackend(_selectedOutputMode),
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

  // 🧠 PATTERN RESULTS - Different styles based on output mode
  Widget _buildPatternResults() {
    final patternResult = _analysis!.patternResult!;
    
    switch (_selectedOutputMode) {
      case 'Intel':
        return _buildIntelResults(patternResult);
      case 'Narrative':
        return _buildNarrativeResults(patternResult);
      case 'Roast':
        return _buildRoastResults(patternResult);
      default:
        return _buildIntelResults(patternResult);
    }
  }

  // 🎯 INTEL RESULTS - Tactical, factual analysis
  Widget _buildIntelResults(WhisperfirePatternResult patternResult) {
    return ResultCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Intel Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors.primaryPink,
                  width: 2,
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
                        '🎯 INTELLIGENCE REPORT',
                        style: TextStyle(
                          color: AppColors.primaryPink,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tactical Threat Analysis',
                        style: TextStyle(
                          color: AppColors.textGray400,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryPink.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.primaryPink,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    'CONFIDENCE: ${patternResult.confidenceMetrics.analysisConfidence}%',
                    style: TextStyle(
                      color: AppColors.primaryPink,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Threat Assessment
          _buildIntelSection(
            '🚨 THREAT ASSESSMENT',
            [
              'Headline: "${patternResult.behavioralProfile.headline}"',
              'Archetype: "${patternResult.behavioralProfile.manipulatorArchetype}"',
              'Pattern Severity: ${patternResult.patternAnalysis.patternSeverityScore}/100',
              'Risk Level: ${patternResult.riskAssessment.interventionUrgency}',
            ],
            AppColors.primaryPink,
          ),
          const SizedBox(height: 20),
          
          // Tactical Analysis
          _buildIntelSection(
            '⚡ TACTICAL ANALYSIS',
            [
              'Manipulation Cycle: "${patternResult.patternAnalysis.manipulationCycle}"',
              'Escalation Probability: ${patternResult.riskAssessment.escalationProbability}%',
              'Psychological Damage: ${patternResult.psychologicalAssessment.psychologicalDamageScore}/100',
              'Reality Distortion: ${patternResult.psychologicalAssessment.realityDistortionLevel}%',
            ],
            AppColors.primaryPurple,
          ),
          const SizedBox(height: 20),
          
          // Strategic Recommendations
          _buildIntelSection(
            '🛡️ STRATEGIC RECOMMENDATIONS',
            patternResult.strategicRecommendations.patternDisruptionTactics,
            AppColors.primaryCyan,
          ),
          const SizedBox(height: 20),
          
          // Final Assessment
          _buildFinalAssessment(patternResult),
        ],
      ),
    );
  }

  // 📖 NARRATIVE RESULTS - Story-driven analysis
  Widget _buildNarrativeResults(WhisperfirePatternResult patternResult) {
    return ResultCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Narrative Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors.primaryCyan,
                  width: 2,
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
                        '📖 PATTERN NARRATIVE',
                        style: TextStyle(
                          color: AppColors.primaryCyan,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Story-driven Behavioral Analysis',
                        style: TextStyle(
                          color: AppColors.textGray400,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Story Introduction
          _buildNarrativeSection(
            '🎭 THE CHARACTER',
            [
              'Meet "${patternResult.behavioralProfile.headline}"',
              'This person operates as a "${patternResult.behavioralProfile.manipulatorArchetype}"',
              'Their dominant pattern: "${patternResult.behavioralProfile.dominantPattern}"',
            ],
            AppColors.primaryCyan,
          ),
          const SizedBox(height: 20),
          
          // The Plot
          _buildNarrativeSection(
            '📖 THE PLOT',
            [
              'The manipulation cycle: "${patternResult.patternAnalysis.manipulationCycle}"',
              'Escalation timeline: "${patternResult.patternAnalysis.escalationTimeline}"',
              'Trigger events: ${patternResult.patternAnalysis.triggerEvents.join(", ")}',
            ],
            AppColors.primaryPurple,
          ),
          const SizedBox(height: 20),
          
          // The Impact
          _buildNarrativeSection(
            '💥 THE IMPACT',
            [
              'Primary agenda: "${patternResult.psychologicalAssessment.primaryAgenda}"',
              'Emotional damage: "${patternResult.psychologicalAssessment.emotionalDamageInflicted}"',
              'Power methods: ${patternResult.psychologicalAssessment.powerControlMethods.join(", ")}',
            ],
            AppColors.primaryPink,
          ),
          const SizedBox(height: 20),
          
          // The Resolution
          _buildNarrativeSection(
            '🎬 THE RESOLUTION',
            [
              'Boundary strategy: "${patternResult.strategicRecommendations.boundaryEnforcementStrategy}"',
              'Communication guidelines: "${patternResult.strategicRecommendations.communicationGuidelines}"',
              'Safety planning: "${patternResult.strategicRecommendations.safetyPlanning}"',
            ],
            AppColors.warningOrange,
          ),
        ],
      ),
    );
  }

  // 🔥 ROAST RESULTS - Savage but truthful
  Widget _buildRoastResults(WhisperfirePatternResult patternResult) {
    return ResultCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Roast Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors.warningOrange,
                  width: 2,
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
                        '🔥 VIRAL ROAST ANALYSIS',
                        style: TextStyle(
                          color: AppColors.warningOrange,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Savage but Truthful Breakdown',
                        style: TextStyle(
                          color: AppColors.textGray400,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // The Roast
          _buildRoastSection(
            '🔥 THE ROAST',
            [
              '${patternResult.viralInsights.sussVerdict}',
              '${patternResult.viralInsights.lifeSavingInsight}',
              '${patternResult.viralInsights.patternSummary}',
              '${patternResult.viralInsights.gutValidation}',
            ],
            AppColors.warningOrange,
          ),
          const SizedBox(height: 20),
          
          // The Breakdown
          _buildRoastSection(
            '💀 THE BREAKDOWN',
            [
              'This "${patternResult.behavioralProfile.headline}" is running a "${patternResult.patternAnalysis.manipulationCycle}"',
              'Sophistication level: ${patternResult.behavioralProfile.manipulationSophistication}/100 (pathetic)',
              'Reality distortion: ${patternResult.psychologicalAssessment.realityDistortionLevel}% (delusional)',
              'Psychological damage score: ${patternResult.psychologicalAssessment.psychologicalDamageScore}/100 (toxic)',
            ],
            AppColors.primaryPink,
          ),
          const SizedBox(height: 20),
          
          // The Comeback
          _buildRoastSection(
            '🗡️ THE COMEBACK',
            [
              'Boundary enforcement: "${patternResult.strategicRecommendations.boundaryEnforcementStrategy}"',
              'Escape strategy: "${patternResult.strategicRecommendations.escapeStrategy}"',
              'Pattern disruption: ${patternResult.strategicRecommendations.patternDisruptionTactics.join(", ")}',
            ],
            AppColors.primaryPurple,
          ),
        ],
      ),
    );
  }

  // Helper method for Intel sections
  Widget _buildIntelSection(String title, List<String> items, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
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
          const SizedBox(height: 12),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '• ',
                  style: TextStyle(color: color, fontSize: 16),
                ),
                Expanded(
                  child: Text(
                    item,
                    style: const TextStyle(
                      color: Colors.white,
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

  // Helper method for Narrative sections
  Widget _buildNarrativeSection(String title, List<String> items, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
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
          const SizedBox(height: 12),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              item,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          )),
        ],
      ),
    );
  }

  // Helper method for Roast sections
  Widget _buildRoastSection(String title, List<String> items, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
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
          const SizedBox(height: 12),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🔥 ',
                  style: TextStyle(color: color, fontSize: 16),
                ),
                Expanded(
                  child: Text(
                    item,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
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

  // Final assessment for Intel mode
  Widget _buildFinalAssessment(WhisperfirePatternResult patternResult) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryPink.withOpacity(0.2),
            AppColors.primaryPurple.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryPink.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🎯 FINAL ASSESSMENT',
            style: TextStyle(
              color: AppColors.primaryPink,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'This individual exhibits ${patternResult.behavioralProfile.manipulationSophistication >= 70 ? 'highly sophisticated' : patternResult.behavioralProfile.manipulationSophistication >= 40 ? 'moderately sophisticated' : 'basic'} manipulation patterns with a ${patternResult.riskAssessment.interventionUrgency.toLowerCase()} intervention urgency. ${patternResult.viralInsights.lifeSavingInsight}',
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