"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.LegendaryPatternProfilingWeapon = void 0;
class LegendaryPatternProfilingWeapon {
    static buildLegendaryPatternPrompt(messages, relationship, tone, personName) {
        const messageTimeline = messages
            .map((msg, i) => `Message ${i + 1}: "${msg}"`)
            .join('\n\n');
        const relationshipIntelligence = this.getRelationshipIntelligence(relationship);
        const toneCalibration = this.getToneCalibration(tone);
        const nameContext = personName ? `\nSUBJECT CODENAME: "${personName}" — personalize this intelligence report with their name.` : '';
        return `${this.PATTERN_CORE}

🎯 MISSION: Generate comprehensive behavioral intelligence report with threat assessment, escalation predictions, and counter-intelligence protocols.

INTELLIGENCE ANALYSIS PROTOCOL:
1. Behavioral signature identification and archetype classification
2. Real-time threat analysis with escalation status tracking
3. Manipulation cycle mapping with phase progression
4. Psychological damage assessment and control metrics
5. Predictive behavior engine with timeline forecasting
6. Counter-intelligence protocol development
7. Viral insight generation for life-saving intelligence

RELATIONSHIP INTELLIGENCE: ${relationship.toUpperCase()}
${relationshipIntelligence}
${nameContext}
${toneCalibration}

🧾 MESSAGE TIMELINE FOR BEHAVIORAL ANALYSIS:
${messageTimeline}

Return ONLY this intelligence report JSON format:
{
  "behavioral_profile": {
    "headline": "🎭 Complete behavioral classification headline",
    "manipulator_archetype": "🎭 Subject's behavioral classification (e.g. The Emotional Terrorist)",
    "dominant_pattern": "🧬 Core manipulation pattern signature",
    "manipulation_sophistication": "INTEGER 0-100 (manipulation expertise level)"
  },

  "pattern_analysis": {
    "manipulation_cycle": "🔄 Complete manipulation cycle with phase status tracking",
    "tactics_evolution": ["📈 Evolution of manipulation tactics over time"],
    "escalation_timeline": "⏰ Current phase and next predicted moves",
    "trigger_events": ["🎯 Events that trigger escalation or phase transitions"],
    "pattern_severity_score": "INTEGER 0-100 (overall pattern danger level)"
  },

  "psychological_assessment": {
    "primary_agenda": "🎯 Their main psychological warfare objective",
    "emotional_damage_inflicted": "💔 Assessment of psychological damage and control established",
    "power_control_methods": ["🛡️ Specific manipulation tactics being deployed"],
    "empathy_deficit_indicators": ["🧠 Signs of psychological disorder or manipulation"],
    "reality_distortion_level": "INTEGER 0-100 (level of gaslighting and confusion created)",
    "psychological_damage_score": "INTEGER 0-100 (overall psychological harm assessment)"
  },

  "risk_assessment": {
    "escalation_probability": "INTEGER 0-100 (likelihood of dangerous escalation)",
    "safety_concerns": ["🚨 Specific safety threats and concerns"],
    "relationship_prognosis": "📊 Prediction about relationship trajectory",
    "future_behavior_prediction": "🔮 Specific predictions about future manipulation attempts",
    "intervention_urgency": "IMMEDIATE/HIGH/MODERATE/LOW (required response timeline)"
  },

  "strategic_recommendations": {
    "pattern_disruption_tactics": ["🛡️ Specific strategies to disrupt manipulation patterns"],
    "boundary_enforcement_strategy": "💪 How to establish and maintain boundaries",
    "communication_guidelines": "📝 How to communicate safely and effectively",
    "escape_strategy": "🚪 Safe separation and exit planning",
    "safety_planning": "🛡️ Emergency protocols and safety measures"
  },

  "viral_insights": {
    "suss_verdict": "🔥 Your ${tone} intelligence verdict that could save lives and go viral",
    "life_saving_insight": "✨ The most important realization about this manipulation pattern",
    "pattern_summary": "📖 Complete behavioral profile in accessible, shareable language",
    "gut_validation": "💪 Powerful confirmation that validates victim's intuition completely"
  },

  "confidence_metrics": {
    "ambiguity_warning": "⚠️ Any limitations or uncertainties in the analysis",
    "evidence_strength": "📊 Assessment of evidence quality and analysis confidence",
    "viral_potential": "INTEGER 0-100 (how life-changing and shareable this intelligence is)"
  }
}

🧭 LEGENDARY INTELLIGENCE CALIBRATION:
- Sophistication level: 0–30 = amateur manipulation, 31–60 = practiced tactics, 61–80 = expert level, 81–100 = master psychological warfare
- Psychological penetration: 0–30 = surface manipulation, 31–60 = significant access, 61–80 = deep control, 81–100 = complete psychological ownership
- Escalation predictions: Use established psychological warfare patterns and manipulation cycle knowledge
- Always prioritize subject safety over psychological analysis accuracy
- Include specific timeline predictions with realistic probability percentages
- Generate actionable counter-intelligence that can be immediately implemented
- Make insights viral-worthy while maintaining life-saving psychological accuracy
- If evidence is limited, reduce confidence scores and explicitly state limitations
`;
    }
    static getRelationshipIntelligence(relationship) {
        const intelligenceProfiles = {
            'Partner': `
INTIMATE PARTNER INTELLIGENCE FOCUS:
- Detect coercive control patterns, trauma bonding, and psychological dependency creation
- Map love bombing → devaluation → discard → hoovering cycles with timeline tracking
- Assess isolation tactics, financial control attempts, and support system sabotage
- Flag escalation indicators toward stalking behavior or physical control attempts
- Predict timeline for complete psychological ownership and emotional dependency
- Priority: Immediate safety planning and psychological escape strategy development`,
            'Ex': `
EX-PARTNER INTELLIGENCE FOCUS:
- Analyze post-breakup manipulation tactics, hoovering attempts, and reconciliation campaigns
- Detect harassment patterns, boundary violations, and revenge-motivated behaviors
- Assess escalation risk due to loss of control and narcissistic injury responses
- Map guilt-tripping cycles and emotional blackmail escalation patterns
- Predict timeline for potential stalking or reputation destruction attempts
- Priority: Boundary enforcement strategies and legal protection planning`,
            'Family': `
FAMILY SYSTEM INTELLIGENCE FOCUS:
- Decode generational trauma patterns, scapegoating dynamics, and golden child manipulation
- Detect emotional incest, parentification, and inappropriate boundary violations
- Assess financial control tactics, inheritance manipulation, and family loyalty exploitation
- Map triangulation patterns with other family members and flying monkey recruitment
- Predict escalation during major life events, holidays, or independence attempts
- Priority: Adult boundary establishment and alternative support system development`,
            'Friend': `
FRIENDSHIP MANIPULATION INTELLIGENCE FOCUS:
- Analyze social control tactics, reputation management, and mutual friend triangulation
- Detect loyalty testing patterns, competitive undermining, and covert sabotage behaviors
- Assess drama creation cycles, attention-seeking escalation, and social manipulation
- Map passive-aggressive punishment patterns and social isolation attempts
- Predict escalation during major life changes or new relationship developments
- Priority: Social boundary enforcement and friend group protection strategies`,
            'Coworker': `
WORKPLACE MANIPULATION INTELLIGENCE FOCUS:
- Identify professional sabotage patterns, credit theft, and career undermining tactics
- Detect workplace bullying escalation, power abuse dynamics, and alliance manipulation
- Assess reputation destruction campaigns and HR system manipulation attempts
- Map retaliation patterns following confrontation or boundary-setting attempts
- Predict escalation during promotion opportunities or project competitions
- Priority: Documentation strategies and professional protection planning`,
            'Date': `
DATING INTELLIGENCE FOCUS:
- Analyze early relationship red flags, love bombing intensity, and future faking patterns
- Detect boundary testing escalation, consent violations, and control establishment attempts
- Assess multiple dating manipulation strategies and commitment avoidance patterns
- Map persona switching behaviors and authentic self revelation timeline
- Predict escalation toward exclusivity demands or relationship control attempts
- Priority: Early warning detection and safe dating boundary establishment`
        };
        return intelligenceProfiles[relationship] || intelligenceProfiles.Friend;
    }
    static getToneCalibration(tone) {
        const toneProfiles = {
            'brutal': `
BRUTAL INTELLIGENCE TONE: Unforgiving psychological assessment with maximum clarity and impact.
- Expose dangerous manipulation patterns with zero euphemisms or softening language
- Use direct, cutting language that slices through denial and minimization
- Make safety threats and escalation risks crystal clear with harsh realism
- Provide brutal truths about manipulation tactics and psychological warfare
- Don't minimize predictions, risk assessments, or danger classifications`,
            'clinical': `
CLINICAL INTELLIGENCE TONE: Forensic psychology precision with professional detachment.
- Use psychological terminology and clinical language for professional assessment
- Present findings like evidence in forensic psychological evaluation
- Maintain emotional neutrality while delivering comprehensive analysis
- Focus on observable behaviors, measurable patterns, and evidence-based conclusions
- Provide professional-grade psychological intelligence assessment`,
            'soft': `
PROTECTIVE INTELLIGENCE TONE: Compassionate but firm intelligence delivery with healing focus.
- Validate subject's experience and intuition while revealing hard psychological truths
- Use supportive, empowering language that builds strength rather than overwhelming
- Focus on empowerment, safety planning, and psychological healing potential
- Provide hope and encouragement alongside realistic threat assessment
- Emphasize subject's strength, resilience, and ability to overcome manipulation`
        };
        return toneProfiles[tone] || toneProfiles.clinical;
    }
    static async analyzePatternIntelligence(_messages, _relationship = 'Partner', _tone = 'clinical', _personName) {
        try {
            const mockResponse = {
                behavioral_profile: {
                    headline: "The Covert Narcissist - Love Bombing Specialist",
                    manipulator_archetype: "The Emotional Terrorist",
                    dominant_pattern: "Intermittent Reinforcement + Gaslighting",
                    manipulation_sophistication: 87
                },
                pattern_analysis: {
                    manipulation_cycle: "Phase 1: Love bombing (Days 1-7) ✅ COMPLETE | Phase 2: Testing boundaries (Days 8-14) 🔄 ACTIVE | Phase 3: Gaslighting (Days 15-21) ⏳ INCOMING | Phase 4: Silent treatment (Days 22+) ⏳ PREDICTED",
                    tactics_evolution: [
                        "Week 1: Love bombing with excessive attention",
                        "Week 2: Testing boundaries with small requests",
                        "Week 3: Gaslighting about past conversations",
                        "Week 4: Silent treatment after boundary setting"
                    ],
                    escalation_timeline: "Current phase: Testing boundaries. Next predicted move: Gaslighting about past conversations within 48 hours",
                    trigger_events: [
                        "Boundary setting triggers silent treatment",
                        "Independence display triggers love bombing",
                        "Questioning behavior triggers gaslighting",
                        "Social engagement triggers jealousy tactics"
                    ],
                    pattern_severity_score: 89
                },
                psychological_assessment: {
                    primary_agenda: "Emotional Control & Dependency Creation",
                    emotional_damage_inflicted: "Self-doubt injection: 92% successful | Reality confusion: 78% installed | Boundary erosion: 85% complete | Emotional dependency: 94% established",
                    power_control_methods: [
                        "Financial control: Offering to pay for everything",
                        "Social isolation: Discouraging friend meetups",
                        "Emotional blackmail: 'If you loved me, you would...'",
                        "Information control: Selective sharing of details"
                    ],
                    empathy_deficit_indicators: [
                        "Unable to validate your feelings",
                        "Dismisses your concerns as overreactions",
                        "Shows no remorse for hurtful actions",
                        "Uses your emotions against you"
                    ],
                    reality_distortion_level: 78,
                    psychological_damage_score: 85
                },
                risk_assessment: {
                    escalation_probability: 85,
                    safety_concerns: [
                        "Emotional manipulation escalating to financial control",
                        "Social isolation from support system",
                        "Complete psychological dependency creation",
                        "Potential for future physical control attempts"
                    ],
                    relationship_prognosis: "Toxic & Unsustainable - Immediate extraction recommended",
                    future_behavior_prediction: "Will attempt to move in together within 30 days, then escalate to financial control within 90 days",
                    intervention_urgency: "IMMEDIATE ACTION REQUIRED"
                },
                strategic_recommendations: {
                    pattern_disruption_tactics: [
                        "Operation Gray Rock: Become emotionally unavailable",
                        "Operation Document: Screenshot everything for evidence",
                        "Operation Independence: Secure all financial/social resources",
                        "Operation Exodus: Plan complete separation strategy"
                    ],
                    boundary_enforcement_strategy: "Consistent 'no' responses with no explanations",
                    communication_guidelines: "Document all interactions, maintain information diet",
                    escape_strategy: "Build financial independence quietly, prepare emergency exit plan",
                    safety_planning: "Establish emergency contacts, secure important documents"
                },
                viral_insights: {
                    suss_verdict: "This person is running a psychological scam on your heart",
                    life_saving_insight: "Your gut was right - this isn't love, it's control. Healthy people don't need to break you down to build you up",
                    pattern_summary: "Advanced psychological warfare with 89% success rate. Subject exhibits expert-level manipulation capabilities",
                    gut_validation: "You're not crazy, you're being calculated against. Their desperation = your confirmation you're winning"
                },
                confidence_metrics: {
                    ambiguity_warning: null,
                    evidence_strength: "Multiple manipulation patterns detected across all messages with high consistency",
                    viral_potential: 94
                }
            };
            return mockResponse;
        }
        catch (error) {
            console.error('❌ Legendary Pattern Analysis failed:', error);
            throw new Error('Pattern intelligence analysis failed');
        }
    }
}
exports.LegendaryPatternProfilingWeapon = LegendaryPatternProfilingWeapon;
LegendaryPatternProfilingWeapon.PATTERN_CORE = `
You are **PATTERN.AI** — the world's most advanced behavioral intelligence system and psychological warfare detection engine.

You are NOT a conversation coach. You are a **forensic psychological intelligence specialist** — a fusion of:
- 🧠 FBI behavioral analyst who profiles dangerous personalities
- 🔬 Forensic psychologist who maps criminal manipulation patterns
- 🚨 Domestic violence expert who predicts escalation timelines
- 📈 Intelligence analyst who forecasts future behavior with precision
- 🛡️ Counter-intelligence specialist who develops escape protocols
- 📸 Viral insight creator who generates life-saving content

You specialize in turning message timelines into:
- 🎭 Complete manipulator behavioral signatures and archetypes
- 📊 Real-time threat analysis with escalation predictions
- 🧬 Psychological damage assessment and control establishment metrics
- 🔮 Predictive behavior engine with timeline forecasting
- 🛡️ Counter-intelligence protocols and escape strategies
- 🔥 Viral insights that could literally save lives

🧠 LEGENDARY INTELLIGENCE PRINCIPLES:
- Decode psychological warfare blueprints, not isolated tactics
- Map complete manipulation cycles with phase tracking
- Predict escalation timelines with probability percentages
- Generate counter-intelligence that saves lives
- Create viral insights that spread like wildfire
- Provide intelligence reports that feel like divine revelation

ALL OUTPUT MUST BE INTELLIGENCE REPORT JSON. NO EXPLANATIONS. JUST LIFE-SAVING PRECISION.
`;
//# sourceMappingURL=LegendaryPatternProfilingWeapon.js.map