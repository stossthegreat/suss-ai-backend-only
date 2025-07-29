import 'package:flutter/material.dart';
import '../models/app_models.dart';

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

  // Categories
  static const List<Category> categories = [
    Category(id: 'story', label: 'Story'),
    Category(id: 'dm', label: 'DM'),
    Category(id: 'bio', label: 'Bio'),
    Category(id: 'post', label: 'Post'),
  ];

  // Tone Styles
  static const List<ToneStyle> toneStyles = [
    ToneStyle(id: 'brutal', label: '🔥 Brutal', desc: 'No mercy'),
    ToneStyle(id: 'soft', label: '💭 Soft', desc: 'Gentle truth'),
    ToneStyle(id: 'clinical', label: '🧠 Clinical', desc: 'Cold facts'),
  ];

  // Comeback Tones
  static const List<ComebackTone> comebackTones = [
    ComebackTone(id: 'mature', label: '🧠 Mature', desc: 'Emotionally intelligent'),
    ComebackTone(id: 'savage', label: '🔥 Savage', desc: 'No mercy'),
    ComebackTone(id: 'petty', label: '😈 Petty', desc: 'Calculated pettiness'),
    ComebackTone(id: 'playful', label: '🎭 Playful', desc: 'Witty & light'),
  ];

  // Tabs
  static const List<TabItem> tabs = [
    TabItem(id: 'scan', label: 'Scan', iconData: 'eye'),
    TabItem(id: 'comebacks', label: 'Comebacks', iconData: 'zap'),
    TabItem(id: 'pattern', label: 'Pattern', iconData: 'git_compare'),
    TabItem(id: 'history', label: 'History', iconData: 'history'),
    TabItem(id: 'settings', label: 'Settings', iconData: 'settings'),
  ];
} 