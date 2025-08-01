export interface AnalysisRequest {
    input_text: string | string[];
    content_type: 'dm' | 'bio' | 'story' | 'post';
    analysis_goal: 'subtext_scan' | 'lie_detection' | 'pattern_analysis';
    tone: 'brutal' | 'soft' | 'clinical' | 'playful' | 'petty';
    comeback_enabled: boolean;
    relationship?: string;
}
export interface SubtextScanResponse {
    primary_motive: string;
    red_flag_score: number;
    emotional_effect: string;
    what_theyre_not_saying: string;
    suss_verdict: string;
    comeback?: string;
}
export interface LieDetectorResponse {
    lie_risk_score: number;
    behavior_pattern: string;
    evidence: string[];
    subtext_summary: string;
    suss_verdict: string;
    comeback?: string;
}
export interface PatternAnalysisResponse {
    pattern_detected: string;
    archetype: string;
    emotional_effect: string;
    pattern_summary: string;
    suss_verdict: string;
    comeback?: string;
}
export type AnalysisResponse = SubtextScanResponse | LieDetectorResponse | PatternAnalysisResponse;
export interface APIResponse<T = AnalysisResponse> {
    success: boolean;
    data?: T;
    error?: string;
    processing_time?: number;
    model_used?: string;
    analysis_id?: string;
}
//# sourceMappingURL=analysis.d.ts.map