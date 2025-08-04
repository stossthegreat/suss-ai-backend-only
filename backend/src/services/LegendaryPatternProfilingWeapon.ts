// 🧠 PATTERN TAB — BEHAVIORAL PROFILING WARHEAD (WHISPERFIRE TIER)
// Relationship-adaptive pattern detection, output-style switching, and viral-grade insights

export class LegendaryPatternProfilingWeapon {

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
  static buildLegendaryPatternPrompt(
    messages: string[],
    relationship: keyof typeof LegendaryPatternProfilingWeapon.ARCHETYPES = 'Partner',
    outputMode: "Intel" | "Narrative" | "Roast" = "Intel",
    tone: "brutal" | "clinical" | "soft" = "clinical",
    personName?: string
  ): string {
    const messageTimeline = messages
      .map((msg, i) => `Message ${i + 1}: "${msg}"`)
      .join("\n\n");

    // Pick archetype dynamically
    const archetypeList = this.ARCHETYPES[relationship]?.[outputMode] || [];
    const chosenArchetype = archetypeList[Math.floor(Math.random() * archetypeList.length)];

    const toneInstructions = this.getToneInstructions(tone);
    const nameContext = personName
      ? `\nSUBJECT NAME: "${personName}" — personalize the psychological profile accordingly.`
      : "";

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
}
`;
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
      return `🎯 OUTPUT MODE: INTEL\n- Speak like a classified threat brief.\n- Focus on tactics, escalation, and control systems.\n- Archetype: "${archetype}"`;
    }
    if (mode === "Narrative") {
      return `🎯 OUTPUT MODE: NARRATIVE\n- Speak like a Netflix true-crime narrator.\n- Unfold the pattern like a story arc.\n- Archetype: "${archetype}"`;
    }
    if (mode === "Roast") {
      return `🎯 OUTPUT MODE: ROAST\n- Socially lethal but truthful.\n- Make it shareable & meme-worthy.\n- Archetype: "${archetype}"`;
    }
    return "";
  }

  // === ANALYZE PATTERN INTELLIGENCE ===
  static async analyzePatternIntelligence(
    messages: string[],
    relationship: keyof typeof LegendaryPatternProfilingWeapon.ARCHETYPES = 'Partner',
    outputMode: "Intel" | "Narrative" | "Roast" = "Intel",
    tone: "brutal" | "clinical" | "soft" = "clinical",
    personName?: string
  ): Promise<any> {
    try {
      // Build the prompt with relationship-adaptive archetypes
      const prompt = this.buildLegendaryPatternPrompt(messages, relationship, outputMode, tone, personName);
      
      console.log('🧠 LegendaryPatternProfilingWeapon: Building prompt for', {
        relationship,
        outputMode,
        tone,
        messageCount: messages.length,
        personName
      });

      // TODO: Integrate with actual AI service (OpenAI, Anthropic, etc.)
      // For now, return mock data that matches the new structure
      const mockResponse = this.generateMockResponse(relationship, outputMode, personName);
      
      console.log('✅ LegendaryPatternProfilingWeapon: Generated response for', outputMode, 'mode');
      return mockResponse;
      
    } catch (error) {
      console.error('❌ LegendaryPatternProfilingWeapon: Error analyzing pattern intelligence:', error);
      throw error;
    }
  }

  // === MOCK RESPONSE GENERATOR ===
  private static generateMockResponse(
    relationship: keyof typeof LegendaryPatternProfilingWeapon.ARCHETYPES,
    outputMode: "Intel" | "Narrative" | "Roast",
    personName?: string
  ): any {
    const archetypeList = this.ARCHETYPES[relationship]?.[outputMode] || [];
    const chosenArchetype = archetypeList[Math.floor(Math.random() * archetypeList.length)];

    const name = personName || "Subject";
    const relationshipContext = this.getRelationshipContext(relationship);

    return {
      "behavioral_profile": {
        "headline": `🔥 ${name} is running a ${relationshipContext} psychological operation`,
        "manipulator_archetype": chosenArchetype,
        "dominant_pattern": "🔄 Love bombing → intermittent reward → reality distortion → dependency creation",
        "manipulation_sophistication": 87
      },

      "pattern_analysis": {
        "manipulation_cycle": "⚡ Perfect partner facade → boundary testing → gaslighting → control establishment",
        "tactics_evolution": [
          "📈 Phase 1: Mirroring and love bombing (weeks 1-2)",
          "📈 Phase 2: Subtle boundary violations (weeks 3-4)",
          "📈 Phase 3: Reality distortion campaign (weeks 5-8)",
          "📈 Phase 4: Complete psychological ownership (months 2-6)"
        ],
        "trigger_events": [
          "🎭 When you show independence",
          "🎭 When you question their behavior",
          "🎭 When you set boundaries",
          "🎭 When you seek support from others"
        ],
        "escalation_timeline": "📊 Rapid escalation from charm to control within 6-8 weeks",
        "pattern_severity_score": 89
      },

      "psychological_assessment": {
        "primary_agenda": "🎯 Complete emotional and financial dependency",
        "emotional_damage_inflicted": "💥 Systematic erosion of self-trust and reality perception",
        "power_control_methods": [
          "👑 Intermittent reinforcement (hot/cold cycles)",
          "👑 Gaslighting and reality distortion",
          "👑 Isolation from support systems",
          "👑 Financial entanglement strategies"
        ],
        "empathy_deficit_indicators": [
          "🧊 Lack of genuine remorse",
          "🧊 Inability to validate your feelings",
          "🧊 Viewing relationships as transactions",
          "🧊 Exploiting your vulnerabilities"
        ],
        "reality_distortion_level": 78,
        "psychological_damage_score": 85
      },

      "risk_assessment": {
        "escalation_probability": 92,
        "safety_concerns": [
          "🚨 Increasing control over your decisions",
          "🚨 Attempts to isolate you from friends/family",
          "🚨 Financial dependency creation",
          "🚨 Emotional blackmail and threats"
        ],
        "relationship_prognosis": "⚠️ High risk of complete psychological control within 3-6 months",
        "future_behavior_prediction": "🔮 Will escalate to financial control and complete isolation",
        "intervention_urgency": "HIGH"
      },

      "strategic_recommendations": {
        "pattern_disruption_tactics": [
          "🛡️ Gray rock method - become emotionally unavailable",
          "🛡️ Document all interactions for evidence",
          "🛡️ Maintain financial independence",
          "🛡️ Strengthen support network connections"
        ],
        "boundary_enforcement_strategy": "📋 Clear, firm boundaries with immediate consequences for violations",
        "communication_guidelines": "💬 Minimal contact, factual responses only, no emotional engagement",
        "escape_strategy": "🚪 Gradual withdrawal while securing all resources and support systems",
        "safety_planning": "🆘 Document everything, maintain financial independence, build support network, consider professional counseling"
      },

      "viral_insights": {
        "suss_verdict": outputMode === "Intel" 
          ? "🚨 CLASSIFIED: Advanced psychological warfare detected"
          : outputMode === "Narrative"
          ? "💔 You didn't meet your soulmate, you met a tactician"
          : "🔥 Walking, talking red flag parade",
        "life_saving_insight": "✨ Your gut feeling is correct - this is not love, it's control",
        "pattern_summary": "📖 Classic narcissistic abuse cycle with sophisticated manipulation tactics",
        "gut_validation": "💪 Every instinct you have is valid - trust your intuition"
      },

      "confidence_metrics": {
        "analysis_confidence": 94,
        "prediction_confidence": 87,
        "evidence_quality": "Strong",
        "pattern_rationale": "🧠 Clear evidence of systematic manipulation, gaslighting, and control tactics",
        "viral_potential": 96
      }
    };
  }

  // === RELATIONSHIP CONTEXT HELPER ===
  private static getRelationshipContext(relationship: string): string {
    const contexts = {
      Partner: "romantic relationship",
      Ex: "post-breakup harassment",
      Family: "generational trauma",
      Friend: "social manipulation",
      Coworker: "professional sabotage",
      Date: "dating manipulation"
    };
    return contexts[relationship as keyof typeof contexts] || "psychological";
  }
} 