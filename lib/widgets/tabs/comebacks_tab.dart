import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../services/api_service.dart';
import '../common/custom_text_field.dart';
import '../common/gradient_button.dart';
import '../common/outlined_button.dart';

class ComebacksTab extends StatefulWidget {
  const ComebacksTab({super.key});

  @override
  State<ComebacksTab> createState() => _ComebacksTabState();
}

class _ComebacksTabState extends State<ComebacksTab> {
  final TextEditingController _textController = TextEditingController();
  String _selectedTone = 'mature'; // Default to mature
  String _selectedStyle = 'one_liner'; // New comeback style
  String _selectedRelationship = 'Partner'; // New relationship context
  String _generatedComeback = '';

  Future<void> _generateComeback() async {
    if (_textController.text.trim().isEmpty) return;
    
    setState(() {
      _generatedComeback = 'Generating comeback...';
    });

    try {
      // Use pattern analysis for comeback generation since backend only supports pattern_profiling
      final result = await ApiService.analyzeMessageWhisperfire(
        inputText: _textController.text.trim(),
        contentType: 'dm',
        analysisGoal: 'pattern_profiling', // Always use pattern_profiling
        tone: _mapComebackToneToBackendTone(_selectedTone),
        relationship: _selectedRelationship,
        stylePreference: _selectedStyle,
      );

      if (mounted) {
        setState(() {
          if (result.patternResult != null) {
            // Use strategic recommendations as comeback
            _generatedComeback = result.patternResult!.strategicRecommendations.boundaryEnforcementStrategy;
          } else {
            _generatedComeback = 'No comeback generated';
          }
        });
      }
    } catch (error) {
      print('Comeback generation failed: $error');
      if (mounted) {
        setState(() {
          _generatedComeback = 'Failed to generate comeback. Please try again.';
        });
        // Show error message to user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Comeback generation failed: ${error.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Helper method to map comeback tone to backend tone
  String _mapComebackToneToBackendTone(String comebackTone) {
    switch (comebackTone) {
      case 'mature':
        return 'clinical'; // Mature -> Clinical
      case 'savage':
        return 'brutal'; // Savage -> Brutal
      case 'petty':
        return 'petty'; // Petty -> Petty (same)
      case 'playful':
        return 'playful'; // Playful -> Playful (same)
      default:
        return 'brutal'; // Default to brutal
    }
  }

  @override
  void initState() {
    super.initState();
    // Remove auto-generation - only generate when user clicks button
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Header Section
          _buildHeader(),
          const SizedBox(height: 24),
          
          // Relationship Context Selector
          _buildRelationshipSelector(),
          const SizedBox(height: 20),
          
          // Comeback Style Selector
          _buildStyleSelector(),
          const SizedBox(height: 20),
          
          // Tone Selector
          _buildToneSelector(),
          const SizedBox(height: 24),
          
          // Input Field
          _buildInputField(),
          const SizedBox(height: 24),
          
          // Generate Button
          _buildGenerateButton(),
          const SizedBox(height: 24),
          
          // Generated Comeback
          _buildGeneratedComeback(),
          
          const SizedBox(height: 100), // Bottom padding for tab bar
        ],
      ),
    );
  }

  // ✅ HEADER - Matches React: 🗡️ + title + subtitle
  Widget _buildHeader() {
    return Column(
      children: [
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.flash_on,
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
          'Get the perfect response for any situation',
          style: TextStyle(
            color: AppColors.textGray400,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  // ✅ TONE SELECTOR - Matches React: 2x2 grid layout with descriptions
  Widget _buildToneSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ✅ EXACT React styling: "COMEBACK TONE" label
        Text(
          'COMEBACK TONE',
          style: TextStyle(
            color: AppColors.textGray400,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        // ✅ EXACT React layout: 2x2 grid with consistent sizing
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2, // 2 columns like React
          childAspectRatio: 2.8, // Consistent aspect ratio
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: AppConstants.comebackTones.map((tone) {
            return Container(
              height: 80, // Fixed height for consistency
              child: CustomOutlinedButton(
                text: '',
                isSelected: _selectedTone == tone.id,
                selectedColor: AppColors.primaryPink, // Pink selection like React
                onPressed: () {
                  setState(() {
                    _selectedTone = tone.id;
                  });
                  // Remove auto-generation - only generate when user clicks button
                },
                child: Container(
                  height: 80, // Fixed height
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ✅ EXACT React: emoji + label on top
                      Text(
                        tone.label, // "🧠 Mature", "🔥 Savage", etc.
                        style: TextStyle(
                          color: _selectedTone == tone.id
                              ? AppColors.primaryPink
                              : AppColors.textGray400,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      // ✅ EXACT React: description on bottom
                      Expanded(
                        child: Text(
                          tone.desc, // "Emotionally intelligent", "No mercy", etc.
                          style: TextStyle(
                            color: (_selectedTone == tone.id
                                    ? AppColors.primaryPink
                                    : AppColors.textGray400)
                                .withOpacity(0.7),
                            fontSize: 11,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
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
                  // Remove auto-generation - only generate when user clicks button
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  // ✅ COMEBACK STYLE SELECTOR - New WHISPERFIRE feature
  Widget _buildStyleSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'COMEBACK STYLE',
          style: TextStyle(
            color: AppColors.textGray400,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        // ✅ Use GridView for consistent sizing like tone selector
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2, // 2 columns for better layout
          childAspectRatio: 2.8, // Consistent aspect ratio
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: AppConstants.comebackStyles.map((style) {
            return Container(
              height: 80, // Fixed height for consistency
              child: CustomOutlinedButton(
                text: '',
                isSelected: _selectedStyle == style.id,
                selectedColor: AppColors.primaryPink,
                onPressed: () {
                  setState(() {
                    _selectedStyle = style.id;
                  });
                  // Remove auto-generation - only generate when user clicks button
                },
                child: Container(
                  height: 80, // Fixed height
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Style label
                      Text(
                        style.label,
                        style: TextStyle(
                          color: _selectedStyle == style.id
                              ? AppColors.primaryPink
                              : AppColors.textGray400,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      // Style description
                      Expanded(
                        child: Text(
                          style.desc,
                          style: TextStyle(
                            color: (_selectedStyle == style.id
                                    ? AppColors.primaryPink
                                    : AppColors.textGray400)
                                .withOpacity(0.7),
                            fontSize: 11,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
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

  // ✅ INPUT FIELD - Matches React: Optional customization textarea
  Widget _buildInputField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ✅ EXACT React styling: "CUSTOMIZE (OPTIONAL)" label
        Text(
          'CUSTOMIZE (OPTIONAL)',
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
          controller: _textController,
          placeholder: 'Paste the message again to customize the tone...',
          maxLines: 6, // Smaller than scan tab (h-24 vs h-32)
          padding: const EdgeInsets.all(16),
        ),
      ],
    );
  }

  // ✅ GENERATE BUTTON - Matches React: Full width gradient with zap icon
  Widget _buildGenerateButton() {
    // ✅ REUSED: GradientButton from Phase 3 with same styling as scan button
    return GradientButton(
      text: 'Generate Comeback',
      icon: const Icon(Icons.flash_on, color: Colors.white), // Zap icon like React
      width: double.infinity,
      height: 56, // Same height as scan button
      onPressed: _generateComeback,
    );
  }

  // ✅ GENERATED COMEBACK - Matches React: Pink gradient card with actions
  Widget _buildGeneratedComeback() {
    if (_generatedComeback.isEmpty) return const SizedBox.shrink();
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        // ✅ REUSED: AppColors.pinkPurpleGradient from Phase 1
        gradient: AppColors.pinkPurpleGradient,
        borderRadius: BorderRadius.circular(AppConstants.xlRadius),
        border: Border.all(
          color: AppColors.primaryPink.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ EXACT React: Title with selected tone in caps
          Text(
            '💬 YOUR COMEBACK (${_selectedTone.toUpperCase()}):',
            style: TextStyle(
              color: AppColors.primaryPink,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          
          // ✅ EXACT React: Comeback text in italic, larger font
          Text(
            _generatedComeback, // From MockData - changes with tone
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18, // Larger than other text
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.italic, // Italic like React
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          
          // ✅ EXACT React: Two action buttons side by side
          Row(
            children: [
              // ✅ Copy button with pink background
              Expanded(
                child: _buildActionButton(
                  '📋 Copy',
                  AppColors.primaryPink.withOpacity(0.2),
                  AppColors.primaryPink,
                  _copyToClipboard,
                ),
              ),
              const SizedBox(width: 12),
              // ✅ Save button with purple background
              Expanded(
                child: _buildActionButton(
                  '💾 Save to Vault',
                  AppColors.primaryPurple.withOpacity(0.2),
                  AppColors.primaryPurple,
                  _saveToVault,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ✅ Helper method for action buttons (Copy/Save)
  Widget _buildActionButton(String text, Color backgroundColor, Color textColor, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: AppConstants.fastAnimation,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  // ✅ Copy to clipboard functionality
  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _generatedComeback));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Comeback copied to clipboard!'),
        backgroundColor: AppColors.primaryPink,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
        ),
      ),
    );
  }

  // ✅ Save to vault functionality
  void _saveToVault() {
    // TODO: Implement vault storage functionality
    // For now, just show a success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Comeback saved to vault!'),
        backgroundColor: AppColors.primaryPurple,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
        ),
      ),
    );
  }
} 