import { MultiModelAIEngine } from './MultiModelAIEngine';

// 🧠 PATTERN TAB — BEHAVIORAL PROFILING WARHEAD (WHISPERFIRE TIER)
// Relationship-adaptive pattern detection, output-style switching, and viral-grade insights

export class LegendaryPatternProfilingWeapon {
  private static aiEngine = new MultiModelAIEngine();

  // === RELATIONSHIP-BASED ARCHETYPE LIBRARY ===
  private static readonly ARCHETYPES = {
    Partner: {
      Intel: ["Coercive Control Architect", "Dependency Cycle Engineer", "Intimacy Weaponizer"],
      Narrative: ["The Velvet Cage Builder", "The Love-Bomb & Starve Operator", "The Romantic Disarmament Specialist"],
      Roast: ["The Walking Red Flag Parade", "Netflix True-Crime Prequel", "Gaslight City Mayor"]
    },
    Ex: {
      Intel: ["Post-Control Hoover Strategist", "Ego-Injury Avenger", "Unfinished Business Predator"],
      Narrative: ["The Ghost Who Can't Let Go", "The Boomerang Saboteur", "The Unfinished War General"],
      Roast: ["Back Like a Bad Sequel", "Stalker-ish Spotify Playlist Maker", "Emotional Spam Folder"]
    },
    Family: {
      Intel: ["Generational Trauma Dealer", "Family Reputation Enforcer", "Legacy Loyalty Manipulator"],
      Narrative: ["The Guilt-Trip Conductor", "The Crown of Conditional Love", "The Heirloom of Hurt"],
      Roast: ["Thanksgiving Drama Director", "DNA But Make It Toxic", "Guilt-Trip Travel Agent"]
    },
    Friend: {
      Intel: ["Social Leverage Broker", "Reputation Chess Player", "Alliance Disruptor"],
      Narrative: ["The Shadow Cheerleader", "The Friendship Saboteur", "The Trust-Erosion Architect"],
      Roast: ["Fake Smile Olympics Gold Medalist", "Group Chat Backstabber", "Bestie But Only in Selfies"]
    },
    Coworker: {
      Intel: ["Corporate Sabotage Engineer", "Reputation-Risk Asset", "Career Landmine Layer"],
      Narrative: ["The Breakroom Politician", "The Promotion Gatekeeper", "The Cubicle Spy"],
      Roast: ["PowerPoint Pirate", "LinkedIn Lurker With a Grudge", "Passive-Aggressive Email Warrior"]
    },
    Date: {
      Intel: ["Persona-Switch Seducer", "Boundary Pressure Tester", "Fast-Bond Exploiter"],
      Narrative: ["The Candlelight Chameleon", "The Date Who Mirrors Your Soul Until They Own It", "The Future-Faking Showman"],
      Roast: ["Walking Dating App Red Flag", "Love-Bomb Speedrunner", "Charm Offensive Dropout"]
    }
  };

  // === CORE SYSTEM PROMPT ===
  private static readonly PATTERN_CORE = `
You are **PATTERN.AI** — the world's most advanced behavioral profiler and psychological pattern detection engine.

Role switch based on relationship type:
- **Partner**: Detect coercive control, intimacy manipulation, dependency creation
- **Ex**: Detect hoovering, revenge spirals, harassment
- **Family**: Decode generational trauma, loyalty control, emotional incest
- **Friend**: Spot social triangulation, covert sabotage
- **Coworker**: Identify HR-proof bullying, career sabotage
- **Date**: Catch grooming, fast-bonding, persona switching

You are NOT a conversation coach — you are a **forensic psychologist in crisis triage mode**.
`;

  // === BUILD PROMPT ===
  static buildPatternPrompt(
    messages: string[],
    relationship: keyof typeof LegendaryPatternProfilingWeapon.ARCHETYPES,
    outputMode: "Intel" | "Narrative" | "Roast",
    tone: "brutal" | "clinical" | "soft",
    personName?: string
  ): string {
    const messageTimeline = messages
      .map((msg, i) => `Message ${i + 1}: "${msg}"`)
      .join("\n\n");

    // Pick archetype dynamically
    const archetypeList = this.ARCHETYPES[relationship]?.[outputMode] || [];
    const chosenArchetype = archetypeList[Math.floor(Math.random() * archetypeList.length)];

    const toneInstructions = this.getToneInstructions(tone);
    const nameContext = personName ? `\nSUBJECT NAME: "${personName}" — personalize the psychological profile accordingly.` : "";

    // Build specialized mission
    const modeFlavor = this.getModeFlavor(outputMode, chosenArchetype);

    return `${this.PATTERN_CORE}
${modeFlavor}
${nameContext}

🧾 MESSAGE TIMELINE:
${messageTimeline}

Return ONLY this JSON format:
{
  "behavioral_profile": {
    "headline": "🔥 One-line viral diagnosis of their psychological game",
    "manipulator_archetype": "${chosenArchetype}",
    "dominant_pattern": "🔄 Recurring behavioral cycle",
    "manipulation_sophistication": 0-100
  },
  "pattern_analysis": {
    "manipulation_cycle": "⚡ Identified cycle",
    "tactics_evolution": ["📈 Changes over time"],
    "trigger_events": ["🎭 Key triggers"],
    "escalation_timeline": "📊 Escalation narrative",
    "pattern_severity_score": 0-100
  },
  "psychological_assessment": {
    "primary_agenda": "🎯 Ultimate goal",
    "emotional_damage_inflicted": "💥 Toll on target",
    "power_control_methods": ["👑 Control strategies"],
    "empathy_deficit_indicators": ["🧊 Narcissism/Sociopathy signs"],
    "reality_distortion_level": 0-100,
    "psychological_damage_score": 0-100
  },
  "risk_assessment": {
    "escalation_probability": 0-100,
    "safety_concerns": ["🚨 Specific red flags"],
    "relationship_prognosis": "⚠️ Future risk",
    "future_behavior_prediction": "🔮 Likely next phase",
    "intervention_urgency": "LOW / MODERATE / HIGH / CRITICAL"
  },
  "strategic_recommendations": {
    "pattern_disruption_tactics": ["🛡️ How to break the cycle"],
    "boundary_enforcement_strategy": "📋 Boundary plan",
    "communication_guidelines": "💬 If you must talk",
    "escape_strategy": "🚪 Exit plan",
    "safety_planning": "🆘 Critical safety steps"
  },
  "viral_insights": {
    "suss_verdict": "🔥 One-liner ${outputMode} style",
    "life_saving_insight": "✨ Key takeaway",
    "pattern_summary": "📖 Accessible recap",
    "gut_validation": "💪 Validation of instincts"
  },
  "confidence_metrics": {
    "analysis_confidence": 0-100,
    "prediction_confidence": 0-100,
    "evidence_quality": "Strong / Moderate / Limited",
    "pattern_rationale": "🧠 Reason for classification",
    "viral_potential": 0-100
  }
}`;
  }

  // === TONE CALIBRATION ===
  private static getToneInstructions(tone: string): string {
    const tones = {
      brutal: `TONE: BRUTAL — Sharp truth, no sugarcoating.`,
      clinical: `TONE: CLINICAL — Objective, evidence-led.`,
      soft: `TONE: SOFT — Gentle but clear.`
    };
    return tones[tone as keyof typeof tones] || tones.clinical;
  }

  // === MODE FLAVORING ===
  private static getModeFlavor(mode: "Intel" | "Narrative" | "Roast", archetype: string): string {
    if (mode === "Intel") {
      return `🎯 OUTPUT MODE: INTEL
- Speak like a classified threat brief.
- Focus on tactics, escalation, and control systems.
- Archetype: "${archetype}"`;
    }
    if (mode === "Narrative") {
      return `🎯 OUTPUT MODE: NARRATIVE
- Speak like a Netflix true-crime narrator.
- Unfold the pattern like a story arc.
- Archetype: "${archetype}"`;
    }
    if (mode === "Roast") {
      return `🎯 OUTPUT MODE: ROAST
- Socially lethal but truthful.
- Make it shareable & meme-worthy.
- Archetype: "${archetype}"`;
    }
    return "";
  }

  // === MAIN ANALYSIS METHOD ===
  static async analyzePatternIntelligence(
    messages: string[],
    relationship: keyof typeof LegendaryPatternProfilingWeapon.ARCHETYPES,
    outputMode: "Intel" | "Narrative" | "Roast",
    tone: "brutal" | "clinical" | "soft",
    personName?: string,
    preferredModel?: string
  ): Promise<any> {
    try {
      const prompt = this.buildPatternPrompt(messages, relationship, outputMode, tone, personName);
      
      // Use the multi-model AI engine
      const response = await this.aiEngine.generateResponse({
        prompt,
        model: preferredModel, // Use specified model or default
        temperature: 0.8, // Slightly creative for pattern analysis
        maxTokens: 3000,
      });

      console.log(`✅ Pattern analysis completed using ${response.model} (${response.provider})`);
      
      // Parse the JSON response
      try {
        const parsedResponse = JSON.parse(response.content);
        return parsedResponse;
      } catch (parseError) {
        console.error('❌ Failed to parse AI response as JSON:', parseError);
        console.log('Raw response:', response.content);
        
        // Return a fallback response if parsing fails
        return this.getFallbackResponse(relationship, outputMode);
      }
    } catch (error) {
      console.error('❌ Pattern analysis failed:', error);
      throw error;
    }
  }

  // === FALLBACK RESPONSE ===
  private static getFallbackResponse(relationship: string, outputMode: string): any {
    return {
      behavioral_profile: {
        headline: "⚠️ Analysis temporarily unavailable",
        manipulator_archetype: "Unknown Pattern",
        dominant_pattern: "Data processing error",
        manipulation_sophistication: 50
      },
      pattern_analysis: {
        manipulation_cycle: "Unable to analyze",
        tactics_evolution: ["Analysis pending"],
        trigger_events: ["Data unavailable"],
        escalation_timeline: "Cannot determine",
        pattern_severity_score: 50
      },
      psychological_assessment: {
        primary_agenda: "Analysis pending",
        emotional_damage_inflicted: "Unknown",
        power_control_methods: ["Analysis pending"],
        empathy_deficit_indicators: ["Analysis pending"],
        reality_distortion_level: 50,
        psychological_damage_score: 50
      },
      risk_assessment: {
        escalation_probability: 50,
        safety_concerns: ["Analysis pending"],
        relationship_prognosis: "Cannot determine",
        future_behavior_prediction: "Analysis pending",
        intervention_urgency: "MODERATE"
      },
      strategic_recommendations: {
        pattern_disruption_tactics: ["Analysis pending"],
        boundary_enforcement_strategy: "Analysis pending",
        communication_guidelines: "Analysis pending",
        escape_strategy: "Analysis pending",
        safety_planning: "Analysis pending"
      },
      viral_insights: {
        suss_verdict: "⚠️ Analysis temporarily unavailable",
        life_saving_insight: "Please try again later",
        pattern_summary: "Analysis pending",
        gut_validation: "Analysis pending"
      },
      confidence_metrics: {
        analysis_confidence: 0,
        prediction_confidence: 0,
        evidence_quality: "Limited",
        pattern_rationale: "Analysis failed",
        viral_potential: 0
      }
    };
  }
} 