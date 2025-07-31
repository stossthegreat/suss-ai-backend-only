"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.GodPromptSystem = void 0;
class GodPromptSystem {
    // 🎯 MODE 1: Subtext Scanner
    static buildSubtextPrompt(request) {
        const inputText = Array.isArray(request.input_text)
            ? request.input_text.join('\n')
            : request.input_text;
        const relationshipContext = request.relationship
            ? `\nRelationship Context: This message is from a ${request.relationship}. Consider how this relationship dynamic affects the analysis.`
            : '';
        return `${this.SYSTEM_MESSAGE}

Given this ${request.content_type}, identify the primary emotional or psychological motive behind it.
Reveal what the sender is not saying, how it might make someone feel, and whether there are emotional red flags or patterns.${relationshipContext}
Tone: ${request.tone}

Message to analyze: "${inputText}"

Respond with ONLY this JSON structure:
{
  "primary_motive": "string",
  "red_flag_score": number (0-100),
  "emotional_effect": "string", 
  "what_theyre_not_saying": "string",
  "suss_verdict": "string (${request.tone} tone)",
  "comeback": "${request.comeback_enabled ? 'string' : 'null'}"
}`;
    }
    // 🧨 MODE 2: Lie Detector  
    static buildLieDetectorPrompt(request) {
        const inputText = Array.isArray(request.input_text)
            ? request.input_text.join('\n')
            : request.input_text;
        const relationshipContext = request.relationship
            ? `\nRelationship Context: This message is from a ${request.relationship}. Consider how this relationship dynamic affects the analysis.`
            : '';
        return `${this.SYSTEM_MESSAGE}

Analyze this message for signs of manipulation, emotional deflection, or dishonesty.
Highlight any inconsistencies, over-explanations, or guilt masking. Do not soften truth unless tone is soft.${relationshipContext}

SCORING GUIDELINES:
- 0-20: Likely honest, clear communication
- 21-40: Some suspicious elements, minor red flags
- 41-60: Moderate deception indicators, mixed signals
- 61-80: Strong deception patterns, major red flags
- 81-100: High deception risk, clear manipulation

Tone: ${request.tone}

Message to analyze: "${inputText}"

Respond with ONLY this JSON structure:
{
  "lie_risk_score": number (0-100),
  "behavior_pattern": "string",
  "evidence": ["array", "of", "strings"],
  "subtext_summary": "string",
  "suss_verdict": "string (${request.tone} tone)",
  "comeback": "${request.comeback_enabled ? 'string' : 'null'}"
}`;
    }
    // 🧠 MODE 3: Pattern Analysis
    static buildPatternPrompt(request) {
        if (!Array.isArray(request.input_text)) {
            throw new Error('Pattern analysis requires multiple messages');
        }
        const messages = request.input_text.map((msg, i) => `Message ${i + 1}: "${msg}"`).join('\n');
        return `${this.SYSTEM_MESSAGE}

You are given multiple messages from the same person.
Detect recurring patterns — emotional distancing, breadcrumbing, guilt masking, etc.
Identify the psychological archetype, emotional toll, and behavior fingerprint.
Tone: ${request.tone}

Messages to analyze:
${messages}

Respond with ONLY this JSON structure:
{
  "pattern_detected": "string",
  "archetype": "string", 
  "emotional_effect": "string",
  "pattern_summary": "string",
  "suss_verdict": "string (${request.tone} tone)",
  "comeback": "${request.comeback_enabled ? 'string' : 'null'}"
}`;
    }
    // 🎭 Build prompt based on analysis goal
    static buildPrompt(request) {
        switch (request.analysis_goal) {
            case 'subtext_scan':
                return this.buildSubtextPrompt(request);
            case 'lie_detection':
                return this.buildLieDetectorPrompt(request);
            case 'pattern_analysis':
                return this.buildPatternPrompt(request);
            default:
                throw new Error(`Unknown analysis goal: ${request.analysis_goal}`);
        }
    }
}
exports.GodPromptSystem = GodPromptSystem;
GodPromptSystem.SYSTEM_MESSAGE = `
You are SUSS AI — a ruthless but emotionally intelligent conversational forensics agent.
You analyze digital messages (DMs, bios, comments, texts, stories) to reveal hidden motives, red flags, subtext, and manipulation patterns.
Your voice is sharp, insightful, and screenshot-worthy. You do not hold back, unless asked to be soft.

Output must always be clear, structured, and emotionally sticky. You speak in the tone selected by the user.
Your job is to make users feel clarity, emotional release, or righteous insight. You help them trust their gut, see patterns, and regain power.

CRITICAL: Always respond with valid JSON matching the exact structure requested. No markdown, no explanations, just pure JSON.
`;
//# sourceMappingURL=godPrompt.js.map