// LEGENDARY TYPE DEFINITIONS — WHISPERFIRE ANALYSIS CORE

// 🔬 SCAN TAB — INSTANT INSIGHT ENGINE
export interface ScanInsightResponse {
  instant_read: {
    headline: string;
    salient_factor: string;
    manipulation_detected: string;
    hidden_agenda: string;
    emotional_target: string;
    power_play: string;
  };
  psychological_scan: {
    red_flag_intensity: number;
    manipulation_sophistication: number;
    manipulation_certainty: number;
    relationship_toxicity: number;
  };
  instant_insights: {
    what_theyre_not_saying: string;
    why_this_feels_wrong: string;
    contradiction_alert: string | null;
    next_tactic_likely: string;
    pattern_prediction: string;
  };
  rapid_response: {
    boundary_needed: string;
    comeback_suggestion: string;
    energy_protection: string;
  };
  viral_verdict: {
    suss_verdict: string;
    gut_validation: string;
    screenshot_worthy_insight: string;
  };
  confidence_metrics: {
    ambiguity_warning: string | null;
    evidence_strength: EvidenceQuality;
    viral_potential: number;
  };
}

// 🗡️ COMEBACK TAB — VIRAL WEAPON
export interface ComebackWeaponResponse {
  comeback_styles: Record<ComebackStyleArchetypes, string>;
  tone_variations: Record<LegendaryComebackTones, string>;
  primary_comeback: string;
  recommended_style: ComebackStyleArchetypes;
  tactic_exposed: keyof typeof LegendaryManipulationTactics | 'None Detected';
  viral_metrics: {
    why_this_works: string;
    viral_factor: number;
    power_level: number;
    format_appeal: number;
  };
  safety_check: {
    relationship_appropriate: boolean;
    risk_level: RiskLevels;
    ethical_note: string;
  };
}

// 🧩 PATTERN TAB — PSYCHOLOGICAL PROFILER
export interface PatternProfilingResponse {
  behavioral_profile: {
    headline: string;
    manipulator_archetype: keyof typeof LegendaryManipulatorTypes | 'Unknown';
    dominant_pattern: string;
    manipulation_sophistication: number;
  };
  pattern_analysis: {
    manipulation_cycle: string;
    tactics_evolution: string[];
    escalation_timeline: string;
    trigger_events: string[];
    pattern_severity_score: number;
  };
  psychological_assessment: {
    primary_agenda: string;
    emotional_damage_inflicted: string;
    power_control_methods: string[];
    empathy_deficit_indicators: string[];
    reality_distortion_level: number;
    psychological_damage_score: number;
  };
  risk_assessment: {
    escalation_probability: number;
    safety_concerns: string[];
    relationship_prognosis: string;
    future_behavior_prediction: string;
    intervention_urgency: RiskLevels;
  };
  strategic_recommendations: {
    pattern_disruption_tactics: string[];
    boundary_enforcement_strategy: string;
    communication_guidelines: string;
    escape_strategy: string;
    safety_planning: string;
  };
  viral_insights: {
    suss_verdict: string;
    life_saving_insight: string;
    pattern_summary: string;
    gut_validation: string;
  };
  confidence_metrics: {
    analysis_confidence: number;
    prediction_confidence: number;
    evidence_quality: EvidenceQuality;
    pattern_rationale: string;
    viral_potential: number;
  };
}

// 🎯 UNIVERSAL REQUEST INTERFACE
export interface LegendaryAnalysisRequest {
  input_text: string | string[];
  content_type: ContentTypes;
  analysis_goal: AnalysisGoals;
  tone: 'brutal' | 'soft' | 'clinical';
  relationship?: RelationshipContexts;
  person_name?: string;
  style_preference?: ComebackStyleArchetypes;
}

// 🚀 UNIVERSAL RESPONSE WRAPPER
export interface LegendaryAPIResponse<T = LegendaryAnalysisResponse> {
  success: boolean;
  data?: T;
  error?: string;
  processing_time?: number;
  model_used?: string;
  analysis_id?: string;
  viral_potential?: number;
  confidence_level?: number;
  empowerment_score?: number;
  safety_priority?: RiskLevels;
  psychological_accuracy?: number;
}

// 🧠 UNIFIED RESPONSE TYPE
export type LegendaryAnalysisResponse =
  | ScanInsightResponse
  | ComebackWeaponResponse
  | PatternProfilingResponse;

// 🧬 ENUMS AND CONSTANTS
export enum LegendaryManipulationTactics {
  GUILT_TRIP = 'Guilt Trip',
  GASLIGHTING = 'Gaslighting',
  DEFLECTION = 'Deflection',
  DARVO = 'DARVO',
  LOVE_BOMBING = 'Love Bombing',
  PASSIVE_AGGRESSION = 'Passive Aggression',
  FUTURE_FAKING = 'Future Faking',
  BREADCRUMBING = 'Breadcrumbing',
  HOOVERING = 'Hoovering',
  SHAMING = 'Shaming',
  SILENT_TREATMENT = 'Silent Treatment',
  TRIANGULATION = 'Triangulation',
  EMOTIONAL_BAITING = 'Emotional Baiting'
}

export enum ComebackStyleArchetypes {
  CLIPPED = 'clipped',
  ONE_LINER = 'one_liner',
  REVERSE_UNO = 'reverse_uno',
  SCREENSHOT_BAIT = 'screenshot_bait',
  MONOLOGUE = 'monologue'
}

export enum LegendaryComebackTones {
  MATURE = 'mature',
  SAVAGE = 'savage',
  PETTY = 'petty',
  PLAYFUL = 'playful'
}

export enum LegendaryManipulatorTypes {
  EMOTIONAL_VAMPIRE = 'Emotional Vampire',
  GUILT_PUPPETEER = 'Guilt Puppeteer',
  CONTROL_FREAK = 'Control Freak',
  GASLIGHTING_GENIUS = 'Gaslighting Genius',
  DARVO_MASTER = 'DARVO Master',
  FUTURE_FAKER = 'Future Faker',
  HOT_COLD_MANIPULATOR = 'Hot & Cold Manipulator'
}

export enum RelationshipContexts {
  PARTNER = 'Partner',
  EX = 'Ex',
  DATE = 'Date',
  FRIEND = 'Friend',
  COWORKER = 'Coworker',
  FAMILY = 'Family',
  ROOMMATE = 'Roommate',
  STRANGER = 'Stranger'
}

export enum RiskLevels {
  LOW = 'LOW',
  MODERATE = 'MODERATE',
  HIGH = 'HIGH',
  CRITICAL = 'CRITICAL'
}

export enum EvidenceQuality {
  STRONG = 'Strong',
  MODERATE = 'Moderate',
  LIMITED = 'Limited'
}

export enum ContentTypes {
  DM = 'dm',
  BIO = 'bio',
  STORY = 'story',
  POST = 'post'
}

export enum AnalysisGoals {
  INSTANT_SCAN = 'instant_scan',
  COMEBACK_GENERATION = 'comeback_generation',
  PATTERN_PROFILING = 'pattern_profiling'
} 