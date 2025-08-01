class LieDetectorResult {
  final String verdict;
  final bool isHonest;
  final List<String> cues;
  final String gutCheck;

  const LieDetectorResult({
    required this.verdict,
    required this.isHonest,
    required this.cues,
    required this.gutCheck,
  });

  factory LieDetectorResult.fromMap(Map<String, dynamic> map) {
    return LieDetectorResult(
      verdict: map['verdict'] ?? '',
      isHonest: map['isHonest'] ?? false,
      cues: List<String>.from(map['cues'] ?? []),
      gutCheck: map['gutCheck'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'verdict': verdict,
      'isHonest': isHonest,
      'cues': cues,
      'gutCheck': gutCheck,
    };
  }
}

class AnalysisResult {
  final String headline;
  final String motive;
  final int redFlag;
  final String redFlagTier;
  final String feeling;
  final String subtext;
  final String comeback;
  final String pattern;
  final LieDetectorResult lieDetector;

  const AnalysisResult({
    required this.headline,
    required this.motive,
    required this.redFlag,
    required this.redFlagTier,
    required this.feeling,
    required this.subtext,
    required this.comeback,
    required this.pattern,
    required this.lieDetector,
  });

  factory AnalysisResult.fromMap(Map<String, dynamic> map) {
    return AnalysisResult(
      headline: map['headline'] ?? '',
      motive: map['motive'] ?? '',
      redFlag: map['redFlag']?.toInt() ?? 0,
      redFlagTier: map['redFlagTier'] ?? '',
      feeling: map['feeling'] ?? '',
      subtext: map['subtext'] ?? '',
      comeback: map['comeback'] ?? '',
      pattern: map['pattern'] ?? '',
      lieDetector: LieDetectorResult.fromMap(map['lieDetector'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'headline': headline,
      'motive': motive,
      'redFlag': redFlag,
      'redFlagTier': redFlagTier,
      'feeling': feeling,
      'subtext': subtext,
      'comeback': comeback,
      'pattern': pattern,
      'lieDetector': lieDetector.toMap(),
    };
  }
} 