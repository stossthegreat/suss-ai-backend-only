// 🚀 WHISPERFIRE FLUTTER MODELS
// Models for the new WHISPERFIRE AI system responses

// 🔍 SCAN TAB - INSTANT INSIGHT ENGINE
class WhisperfireScanResult {
  final InstantRead instantRead;
  final PsychologicalScan psychologicalScan;
  final InstantInsights instantInsights;
  final RapidResponse rapidResponse;
  final ViralVerdict viralVerdict;
  final ConfidenceMetrics confidenceMetrics;

  const WhisperfireScanResult({
    required this.instantRead,
    required this.psychologicalScan,
    required this.instantInsights,
    required this.rapidResponse,
    required this.viralVerdict,
    required this.confidenceMetrics,
  });

  factory WhisperfireScanResult.fromMap(Map<String, dynamic> map) {
    return WhisperfireScanResult(
      instantRead: InstantRead.fromMap(map['instant_read'] ?? {}),
      psychologicalScan: PsychologicalScan.fromMap(map['psychological_scan'] ?? {}),
      instantInsights: InstantInsights.fromMap(map['instant_insights'] ?? {}),
      rapidResponse: RapidResponse.fromMap(map['rapid_response'] ?? {}),
      viralVerdict: ViralVerdict.fromMap(map['viral_verdict'] ?? {}),
      confidenceMetrics: ConfidenceMetrics.fromMap(map['confidence_metrics'] ?? {}),
    );
  }
}

class InstantRead {
  final String headline;
  final String salientFactor;
  final String manipulationDetected;
  final String hiddenAgenda;
  final String emotionalTarget;
  final String powerPlay;

  const InstantRead({
    required this.headline,
    required this.salientFactor,
    required this.manipulationDetected,
    required this.hiddenAgenda,
    required this.emotionalTarget,
    required this.powerPlay,
  });

  factory InstantRead.fromMap(Map<String, dynamic> map) {
    return InstantRead(
      headline: map['headline'] ?? '',
      salientFactor: map['salient_factor'] ?? '',
      manipulationDetected: map['manipulation_detected'] ?? '',
      hiddenAgenda: map['hidden_agenda'] ?? '',
      emotionalTarget: map['emotional_target'] ?? '',
      powerPlay: map['power_play'] ?? '',
    );
  }
}

class PsychologicalScan {
  final int redFlagIntensity;
  final int manipulationSophistication;
  final int manipulationCertainty;
  final int relationshipToxicity;

  const PsychologicalScan({
    required this.redFlagIntensity,
    required this.manipulationSophistication,
    required this.manipulationCertainty,
    required this.relationshipToxicity,
  });

  factory PsychologicalScan.fromMap(Map<String, dynamic> map) {
    return PsychologicalScan(
      redFlagIntensity: map['red_flag_intensity']?.toInt() ?? 0,
      manipulationSophistication: map['manipulation_sophistication']?.toInt() ?? 0,
      manipulationCertainty: map['manipulation_certainty']?.toInt() ?? 0,
      relationshipToxicity: map['relationship_toxicity']?.toInt() ?? 0,
    );
  }
}

class InstantInsights {
  final String whatTheyreNotSaying;
  final String whyThisFeelsWrong;
  final String? contradictionAlert;
  final String nextTacticLikely;
  final String patternPrediction;

  const InstantInsights({
    required this.whatTheyreNotSaying,
    required this.whyThisFeelsWrong,
    this.contradictionAlert,
    required this.nextTacticLikely,
    required this.patternPrediction,
  });

  factory InstantInsights.fromMap(Map<String, dynamic> map) {
    return InstantInsights(
      whatTheyreNotSaying: map['what_theyre_not_saying'] ?? '',
      whyThisFeelsWrong: map['why_this_feels_wrong'] ?? '',
      contradictionAlert: map['contradiction_alert'],
      nextTacticLikely: map['next_tactic_likely'] ?? '',
      patternPrediction: map['pattern_prediction'] ?? '',
    );
  }
}

class RapidResponse {
  final String boundaryNeeded;
  final String comebackSuggestion;
  final String energyProtection;

  const RapidResponse({
    required this.boundaryNeeded,
    required this.comebackSuggestion,
    required this.energyProtection,
  });

  factory RapidResponse.fromMap(Map<String, dynamic> map) {
    return RapidResponse(
      boundaryNeeded: map['boundary_needed'] ?? '',
      comebackSuggestion: map['comeback_suggestion'] ?? '',
      energyProtection: map['energy_protection'] ?? '',
    );
  }
}

class ViralVerdict {
  final String sussVerdict;
  final String gutValidation;
  final String screenshotWorthyInsight;

  const ViralVerdict({
    required this.sussVerdict,
    required this.gutValidation,
    required this.screenshotWorthyInsight,
  });

  factory ViralVerdict.fromMap(Map<String, dynamic> map) {
    return ViralVerdict(
      sussVerdict: map['suss_verdict'] ?? '',
      gutValidation: map['gut_validation'] ?? '',
      screenshotWorthyInsight: map['screenshot_worthy_insight'] ?? '',
    );
  }
}

class ConfidenceMetrics {
  final String? ambiguityWarning;
  final String evidenceStrength;
  final int viralPotential;
  final int analysisConfidence;

  const ConfidenceMetrics({
    this.ambiguityWarning,
    required this.evidenceStrength,
    required this.viralPotential,
    required this.analysisConfidence,
  });

  factory ConfidenceMetrics.fromMap(Map<String, dynamic> map) {
    return ConfidenceMetrics(
      ambiguityWarning: map['ambiguity_warning'],
      evidenceStrength: map['evidence_strength'] ?? '',
      viralPotential: map['viral_potential']?.toInt() ?? 0,
      analysisConfidence: map['analysis_confidence']?.toInt() ?? 80,
    );
  }
}

// 🗡️ COMEBACK TAB - VIRAL WEAPON
class WhisperfireComebackResult {
  final Map<String, String> comebackStyles;
  final Map<String, String> toneVariations;
  final String primaryComeback;
  final String recommendedStyle;
  final String tacticExposed;
  final ViralMetrics viralMetrics;
  final SafetyCheck safetyCheck;

  const WhisperfireComebackResult({
    required this.comebackStyles,
    required this.toneVariations,
    required this.primaryComeback,
    required this.recommendedStyle,
    required this.tacticExposed,
    required this.viralMetrics,
    required this.safetyCheck,
  });

  factory WhisperfireComebackResult.fromMap(Map<String, dynamic> map) {
    return WhisperfireComebackResult(
      comebackStyles: Map<String, String>.from(map['comeback_styles'] ?? {}),
      toneVariations: Map<String, String>.from(map['tone_variations'] ?? {}),
      primaryComeback: map['primary_comeback'] ?? '',
      recommendedStyle: map['recommended_style'] ?? '',
      tacticExposed: map['tactic_exposed'] ?? '',
      viralMetrics: ViralMetrics.fromMap(map['viral_metrics'] ?? {}),
      safetyCheck: SafetyCheck.fromMap(map['safety_check'] ?? {}),
    );
  }
}

class ViralMetrics {
  final String whyThisWorks;
  final int viralFactor;
  final int powerLevel;
  final int formatAppeal;

  const ViralMetrics({
    required this.whyThisWorks,
    required this.viralFactor,
    required this.powerLevel,
    required this.formatAppeal,
  });

  factory ViralMetrics.fromMap(Map<String, dynamic> map) {
    return ViralMetrics(
      whyThisWorks: map['why_this_works'] ?? '',
      viralFactor: map['viral_factor']?.toInt() ?? 0,
      powerLevel: map['power_level']?.toInt() ?? 0,
      formatAppeal: map['format_appeal']?.toInt() ?? 0,
    );
  }
}

class SafetyCheck {
  final bool relationshipAppropriate;
  final String riskLevel;
  final String ethicalNote;

  const SafetyCheck({
    required this.relationshipAppropriate,
    required this.riskLevel,
    required this.ethicalNote,
  });

  factory SafetyCheck.fromMap(Map<String, dynamic> map) {
    return SafetyCheck(
      relationshipAppropriate: map['relationship_appropriate'] ?? false,
      riskLevel: map['risk_level'] ?? '',
      ethicalNote: map['ethical_note'] ?? '',
    );
  }
}

// 🧠 PATTERN TAB - BEHAVIORAL PROFILER
class WhisperfirePatternResult {
  final BehavioralProfile behavioralProfile;
  final PatternAnalysis patternAnalysis;
  final PsychologicalAssessment psychologicalAssessment;
  final RiskAssessment riskAssessment;
  final StrategicRecommendations strategicRecommendations;
  final ViralInsights viralInsights;
  final ConfidenceMetrics confidenceMetrics;

  const WhisperfirePatternResult({
    required this.behavioralProfile,
    required this.patternAnalysis,
    required this.psychologicalAssessment,
    required this.riskAssessment,
    required this.strategicRecommendations,
    required this.viralInsights,
    required this.confidenceMetrics,
  });

  factory WhisperfirePatternResult.fromMap(Map<String, dynamic> map) {
    return WhisperfirePatternResult(
      behavioralProfile: BehavioralProfile.fromMap(map['behavioral_profile'] ?? {}),
      patternAnalysis: PatternAnalysis.fromMap(map['pattern_analysis'] ?? {}),
      psychologicalAssessment: PsychologicalAssessment.fromMap(map['psychological_assessment'] ?? {}),
      riskAssessment: RiskAssessment.fromMap(map['risk_assessment'] ?? {}),
      strategicRecommendations: StrategicRecommendations.fromMap(map['strategic_recommendations'] ?? {}),
      viralInsights: ViralInsights.fromMap(map['viral_insights'] ?? {}),
      confidenceMetrics: ConfidenceMetrics.fromMap(map['confidence_metrics'] ?? {}),
    );
  }
}

class BehavioralProfile {
  final String headline;
  final String manipulatorArchetype;
  final String dominantPattern;
  final int manipulationSophistication;

  const BehavioralProfile({
    required this.headline,
    required this.manipulatorArchetype,
    required this.dominantPattern,
    required this.manipulationSophistication,
  });

  factory BehavioralProfile.fromMap(Map<String, dynamic> map) {
    return BehavioralProfile(
      headline: map['headline'] ?? '',
      manipulatorArchetype: map['manipulator_archetype'] ?? '',
      dominantPattern: map['dominant_pattern'] ?? '',
      manipulationSophistication: map['manipulation_sophistication']?.toInt() ?? 0,
    );
  }
}

class PatternAnalysis {
  final String manipulationCycle;
  final List<String> tacticsEvolution;
  final String escalationTimeline;
  final List<String> triggerEvents;
  final int patternSeverityScore;

  const PatternAnalysis({
    required this.manipulationCycle,
    required this.tacticsEvolution,
    required this.escalationTimeline,
    required this.triggerEvents,
    required this.patternSeverityScore,
  });

  factory PatternAnalysis.fromMap(Map<String, dynamic> map) {
    return PatternAnalysis(
      manipulationCycle: map['manipulation_cycle'] ?? '',
      tacticsEvolution: List<String>.from(map['tactics_evolution'] ?? []),
      escalationTimeline: map['escalation_timeline'] ?? '',
      triggerEvents: List<String>.from(map['trigger_events'] ?? []),
      patternSeverityScore: map['pattern_severity_score']?.toInt() ?? 0,
    );
  }
}

class PsychologicalAssessment {
  final String primaryAgenda;
  final String emotionalDamageInflicted;
  final List<String> powerControlMethods;
  final List<String> empathyDeficitIndicators;
  final int realityDistortionLevel;
  final int psychologicalDamageScore;

  const PsychologicalAssessment({
    required this.primaryAgenda,
    required this.emotionalDamageInflicted,
    required this.powerControlMethods,
    required this.empathyDeficitIndicators,
    required this.realityDistortionLevel,
    required this.psychologicalDamageScore,
  });

  factory PsychologicalAssessment.fromMap(Map<String, dynamic> map) {
    return PsychologicalAssessment(
      primaryAgenda: map['primary_agenda'] ?? '',
      emotionalDamageInflicted: map['emotional_damage_inflicted'] ?? '',
      powerControlMethods: List<String>.from(map['power_control_methods'] ?? []),
      empathyDeficitIndicators: List<String>.from(map['empathy_deficit_indicators'] ?? []),
      realityDistortionLevel: map['reality_distortion_level']?.toInt() ?? 0,
      psychologicalDamageScore: map['psychological_damage_score']?.toInt() ?? 0,
    );
  }
}

class RiskAssessment {
  final int escalationProbability;
  final List<String> safetyConcerns;
  final String relationshipPrognosis;
  final String futureBehaviorPrediction;
  final String interventionUrgency;

  const RiskAssessment({
    required this.escalationProbability,
    required this.safetyConcerns,
    required this.relationshipPrognosis,
    required this.futureBehaviorPrediction,
    required this.interventionUrgency,
  });

  factory RiskAssessment.fromMap(Map<String, dynamic> map) {
    return RiskAssessment(
      escalationProbability: map['escalation_probability']?.toInt() ?? 0,
      safetyConcerns: List<String>.from(map['safety_concerns'] ?? []),
      relationshipPrognosis: map['relationship_prognosis'] ?? '',
      futureBehaviorPrediction: map['future_behavior_prediction'] ?? '',
      interventionUrgency: map['intervention_urgency'] ?? '',
    );
  }
}

class StrategicRecommendations {
  final List<String> patternDisruptionTactics;
  final String boundaryEnforcementStrategy;
  final String communicationGuidelines;
  final String escapeStrategy;
  final String safetyPlanning;

  const StrategicRecommendations({
    required this.patternDisruptionTactics,
    required this.boundaryEnforcementStrategy,
    required this.communicationGuidelines,
    required this.escapeStrategy,
    required this.safetyPlanning,
  });

  factory StrategicRecommendations.fromMap(Map<String, dynamic> map) {
    return StrategicRecommendations(
      patternDisruptionTactics: List<String>.from(map['pattern_disruption_tactics'] ?? []),
      boundaryEnforcementStrategy: map['boundary_enforcement_strategy'] ?? '',
      communicationGuidelines: map['communication_guidelines'] ?? '',
      escapeStrategy: map['escape_strategy'] ?? '',
      safetyPlanning: map['safety_planning'] ?? '',
    );
  }
}

class ViralInsights {
  final String sussVerdict;
  final String lifeSavingInsight;
  final String patternSummary;
  final String gutValidation;

  const ViralInsights({
    required this.sussVerdict,
    required this.lifeSavingInsight,
    required this.patternSummary,
    required this.gutValidation,
  });

  factory ViralInsights.fromMap(Map<String, dynamic> map) {
    return ViralInsights(
      sussVerdict: map['suss_verdict'] ?? '',
      lifeSavingInsight: map['life_saving_insight'] ?? '',
      patternSummary: map['pattern_summary'] ?? '',
      gutValidation: map['gut_validation'] ?? '',
    );
  }
}

// 🎯 UNIFIED WHISPERFIRE RESPONSE
class WhisperfireResponse {
  final String? scanResult;
  final String? comebackResult;
  final String? patternResult;
  final int? viralPotential;
  final int? confidenceLevel;
  final int? empowermentScore;
  final String? safetyPriority;
  final int? psychologicalAccuracy;

  const WhisperfireResponse({
    this.scanResult,
    this.comebackResult,
    this.patternResult,
    this.viralPotential,
    this.confidenceLevel,
    this.empowermentScore,
    this.safetyPriority,
    this.psychologicalAccuracy,
  });

  factory WhisperfireResponse.fromMap(Map<String, dynamic> map) {
    return WhisperfireResponse(
      scanResult: map['scan_result'],
      comebackResult: map['comeback_result'],
      patternResult: map['pattern_result'],
      viralPotential: map['viral_potential']?.toInt(),
      confidenceLevel: map['confidence_level']?.toInt(),
      empowermentScore: map['empowerment_score']?.toInt(),
      safetyPriority: map['safety_priority'],
      psychologicalAccuracy: map['psychological_accuracy']?.toInt(),
    );
  }
} 