import 'analysis_result.dart';

class PatternAnalysis {
  final int compositeRedFlagScore;
  final String dominantMotive;
  final String patternType;
  final String emotionalSummary;
  final LieDetectorResult lieDetector;

  const PatternAnalysis({
    required this.compositeRedFlagScore,
    required this.dominantMotive,
    required this.patternType,
    required this.emotionalSummary,
    required this.lieDetector,
  });

  factory PatternAnalysis.fromMap(Map<String, dynamic> map) {
    return PatternAnalysis(
      compositeRedFlagScore: map['composite_red_flag_score']?.toInt() ?? 0,
      dominantMotive: map['dominant_motive'] ?? '',
      patternType: map['pattern_type'] ?? '',
      emotionalSummary: map['emotional_summary'] ?? '',
      lieDetector: LieDetectorResult.fromMap(map['lieDetector'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'composite_red_flag_score': compositeRedFlagScore,
      'dominant_motive': dominantMotive,
      'pattern_type': patternType,
      'emotional_summary': emotionalSummary,
      'lieDetector': lieDetector.toMap(),
    };
  }
} 