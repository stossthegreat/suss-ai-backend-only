import 'package:flutter/material.dart';
import '../models/app_models.dart';

// RELATIONSHIP CONTEXTS - Updated to match new backend prompts
class RelationshipContext {
  final String id;
  final String label;
  final String desc;

  const RelationshipContext({
    required this.id,
    required this.label,
    required this.desc,
  });
}

// CONTENT TYPE
class ContentType {
  final String id;
  final String label;
  final String desc;

  const ContentType({
    required this.id,
    required this.label,
    required this.desc,
  });
}

class AppConstants {
  // Animation Durations
  static const Duration fastAnimation = Duration(milliseconds: 200);
  static const Duration normalAnimation = Duration(milliseconds: 300);
  static const Duration slowAnimation = Duration(milliseconds: 500);
  static const Duration analysisAnimation = Duration(milliseconds: 2800);
  static const Duration patternAnalysisAnimation = Duration(milliseconds: 3200);

  // Animation Curves
  static const Curve defaultCurve = Curves.easeInOut;
  static const Curve bounceCurve = Curves.elasticOut;
  static const Curve slideCurve = Curves.easeOutCubic;

  // Glassmorphism Settings
  static const double glassBlur = 20.0;
  static const double glassOpacity = 0.1;
  static const double cardBlur = 16.0;
  static const double cardOpacity = 0.8;

  // Border Radius
  static const double smallRadius = 8.0;
  static const double mediumRadius = 12.0;
  static const double largeRadius = 16.0;
  static const double xlRadius = 20.0;

  // Spacing
  static const double smallSpacing = 8.0;
  static const double mediumSpacing = 16.0;
  static const double largeSpacing = 24.0;
  static const double xlSpacing = 32.0;

  // 🚀 WHISPERFIRE CONTENT TYPES
  static const List<Category> categories = [
    Category(id: 'dm', label: '💬 DM', desc: 'Direct messages'),
    Category(id: 'bio', label: '📝 Bio', desc: 'Social media bios'),
    Category(id: 'story', label: '📖 Story', desc: 'Social media stories'),
    Category(id: 'post', label: '📱 Post', desc: 'Social media posts'),
  ];

  // RELATIONSHIP CONTEXTS - Updated to match new backend prompts
  static const List<RelationshipContext> relationshipContexts = [
    RelationshipContext(
      id: 'Partner',
      label: 'Partner',
      desc: 'Romantic relationship',
    ),
    RelationshipContext(
      id: 'Ex',
      label: 'Ex',
      desc: 'Former partner',
    ),
    RelationshipContext(
      id: 'Date',
      label: 'Date',
      desc: 'Dating situation',
    ),
    RelationshipContext(
      id: 'Friend',
      label: 'Friend',
      desc: 'Friendship',
    ),
    RelationshipContext(
      id: 'Coworker',
      label: 'Coworker',
      desc: 'Work relationship',
    ),
    RelationshipContext(
      id: 'Family',
      label: 'Family',
      desc: 'Family dynamic',
    ),
    RelationshipContext(
      id: 'Roommate',
      label: 'Roommate',
      desc: 'Living situation',
    ),
    RelationshipContext(
      id: 'Stranger',
      label: 'Stranger',
      desc: 'Unknown person',
    ),
    RelationshipContext(
      id: 'Boss',
      label: 'Boss / Authority',
      desc: 'Authority figure',
    ),
    RelationshipContext(
      id: 'Acquaintance',
      label: 'Acquaintance',
      desc: 'Casual contact',
    ),
  ];

  // 🚀 WHISPERFIRE ANALYSIS GOALS
  static const List<AnalysisGoal> analysisGoals = [
    AnalysisGoal(id: 'instant_scan', label: '⚡ Instant Scan', desc: 'Quick psychological radar'),
    AnalysisGoal(id: 'comeback_generation', label: '🗡️ Comeback Generation', desc: 'Viral weapon creation'),
    AnalysisGoal(id: 'pattern_profiling', label: '🧠 Pattern Profiling', desc: 'Deep behavioral analysis'),
  ];

  // OUTPUT MODES - Updated to match new backend prompts
  static const List<String> outputModes = [
    'Intel',      // Tactical, factual, high-clarity threat analysis
    'Narrative',  // Story-driven pattern breakdown
    'Roast',      // Savage but truthful, meme-worthy
    'Therapeutic', // Healing-focused, validating, softer (Scan tab only)
  ];

  // TONE OPTIONS - Updated to match backend expectations
  static const List<String> toneOptions = [
    'soft',          // Gentle, validating
    'clinical',      // Forensic, emotionally neutral
    'mature',        // Balanced, credible, culturally sharp
    'savage',        // Savage but truthful
  ];

  // 🚀 WHISPERFIRE COMEBACK TONES
  static const List<ComebackTone> comebackTones = [
    ComebackTone(id: 'mature', label: '🧠 Mature', desc: 'Emotionally intelligent'),
    ComebackTone(id: 'savage', label: '🔥 Savage', desc: 'No mercy'),
    ComebackTone(id: 'petty', label: '😈 Petty', desc: 'Calculated pettiness'),
    ComebackTone(id: 'playful', label: '🎭 Playful', desc: 'Witty & light'),
  ];

  // 🚀 WHISPERFIRE COMEBACK STYLE ARCHETYPES
  static const List<ComebackStyle> comebackStyles = [
    ComebackStyle(id: 'clipped', label: '✂️ Clipped', desc: 'Short, sharp responses'),
    ComebackStyle(id: 'one_liner', label: '💥 One Liner', desc: 'Single powerful line'),
    ComebackStyle(id: 'reverse_uno', label: '🔄 Reverse Uno', desc: 'Turn their tactic back'),
    ComebackStyle(id: 'screenshot_bait', label: '📸 Screenshot Bait', desc: 'Viral, shareable'),
    ComebackStyle(id: 'monologue', label: '🎭 Monologue', desc: 'Detailed explanations'),
  ];

  // Tabs
  static const List<TabItem> tabs = [
    TabItem(id: 'scan', label: 'Scan', iconData: 'eye'),
    TabItem(id: 'comebacks', label: 'Comebacks', iconData: 'zap'),
    TabItem(id: 'pattern', label: 'Pattern', iconData: 'git_compare'),
    TabItem(id: 'history', label: 'History', iconData: 'history'),
    TabItem(id: 'settings', label: 'Settings', iconData: 'settings'),
  ];

  // AI Models - Updated to only include gpt-4-turbo and deepseek-v3
  static const List<String> models = [
    'gpt-4-turbo',
    'deepseek-v3',
  ];

  // CONTENT TYPES
  static const List<ContentType> contentTypes = [
    ContentType(id: 'dm', label: 'DM', desc: 'Direct message'),
    ContentType(id: 'bio', label: 'Bio', desc: 'Profile bio'),
    ContentType(id: 'story', label: 'Story', desc: 'Social story'),
    ContentType(id: 'post', label: 'Post', desc: 'Social post'),
    ContentType(id: 'email', label: 'Email', desc: 'Email message'),
    ContentType(id: 'text', label: 'Text', desc: 'Text message'),
  ];
} 