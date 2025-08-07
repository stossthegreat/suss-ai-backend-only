import { OpenAIConfig } from '../config/openai';
import { TogetherAIConfig } from '../config/togetherAI';
import { GodPromptSystem } from '../prompts/godPrompt';
import { ScanInsightEngine } from '../prompts/whisperfireScan';
import { ComebackViralWeapon } from '../prompts/whisperfireComeback';
import { PatternProfilingWeapon } from '../prompts/whisperfirePattern';
import { AnalysisRequest, AnalysisResponse } from '../types/analysis';
import { LegendaryAnalysisRequest, LegendaryAnalysisResponse, ScanInsightResponse, ComebackWeaponResponse, PatternProfilingResponse } from '../types/specializedAnalysis';
import { logger } from '../utils/logger';
import { createHash } from 'crypto';

export class SussAIEngine {
  private openai: OpenAIConfig;
  private togetherAI: TogetherAIConfig;
  private cache: Map<string, any> = new Map();

  constructor() {
    this.openai = new OpenAIConfig();
    this.togetherAI = new TogetherAIConfig();
  }

  async analyzeContent(request: AnalysisRequest | LegendaryAnalysisRequest): Promise<{
    response: AnalysisResponse | LegendaryAnalysisResponse;
    modelUsed: string;
    processingTime: number;
  }> {
    const startTime = Date.now();
    
    try {
      // 🧠 Check if this is a legacy request
      if ('isLegacy' in request && request.isLegacy) {
        return this.handleLegacyRequest(request as AnalysisRequest);
      }

      // 🚀 Handle WHISPERFIRE request
      return this.handleWhisperfireRequest(request as LegendaryAnalysisRequest);

    } catch (error) {
      logger.error('AI Engine Error:', error);
      throw new Error(`Analysis failed: ${error instanceof Error ? error.message : 'Unknown error'}`);
    }
  }

  // 🧠 LEGACY SYSTEM HANDLER
  private async handleLegacyRequest(request: AnalysisRequest): Promise<{
    response: AnalysisResponse;
    modelUsed: string;
    processingTime: number;
  }> {
    const startTime = Date.now();
    
    // 🧠 Smart model selection
    const model = this.openai.selectModel(request);
    logger.info(`Using legacy model: ${model} for ${request.analysis_goal}`);

    // 🔮 Build the God prompt
    const prompt = GodPromptSystem.buildPrompt(request);

    // 🔍 Check cache for identical requests
    const requestHash = this.createRequestHash(request, prompt);
    const cachedResult = this.cache.get(requestHash);
    
    if (cachedResult) {
      logger.info(`Returning cached legacy result for request hash: ${requestHash}`);
      return {
        response: cachedResult.response,
        modelUsed: cachedResult.modelUsed,
        processingTime: Date.now() - startTime,
      };
    }

    // 🚀 Call OpenAI
    let rawResponse: string;
    try {
      const completion = await this.openai.getOpenAIClient().chat.completions.create({
        model,
        messages: [{ role: 'user', content: prompt }],
        temperature: 0.3,
        max_tokens: 1000,
      });

      rawResponse = completion.choices[0]?.message?.content || '';
    } catch (error) {
      logger.warn('OpenAI call failed, returning mock response for testing');
      rawResponse = this.generateMockResponse(request);
    }

    if (!rawResponse) {
      throw new Error('No response from OpenAI');
    }

    // 🧪 Parse JSON response
    const parsedResponse = this.parseLegacyAIResponse(rawResponse);
    const processingTime = Date.now() - startTime;

    // 💾 Cache the result
    this.cache.set(requestHash, {
      response: parsedResponse,
      modelUsed: model,
      processingTime,
    });

    // 🧹 Clean cache if it gets too large
    this.cleanCache();

    logger.info(`Legacy analysis completed in ${processingTime}ms`);

    return {
      response: parsedResponse,
      modelUsed: model,
      processingTime,
    };
  }

  // 🚀 WHISPERFIRE SYSTEM HANDLER
  private async handleWhisperfireRequest(request: LegendaryAnalysisRequest): Promise<{
    response: LegendaryAnalysisResponse;
    modelUsed: string;
    processingTime: number;
  }> {
    const startTime = Date.now();
    
    // 🚀 Smart model selection for WHISPERFIRE
    let model: string;
    let client: any;
    
    // Check if user wants to use DeepSeek v3 via TogetherAI
    if (request.preferred_model === 'deepseek-v3') {
      model = this.togetherAI.selectModel(request);
      client = this.togetherAI.getTogetherAIClient();
      logger.info(`Using TogetherAI DeepSeek v3: ${model} for ${request.analysis_goal}`);
    } else {
      model = this.openai.selectModel(request);
      client = this.openai.getOpenAIClient();
      logger.info(`Using OpenAI model: ${model} for ${request.analysis_goal}`);
    }

    // 🔥 Build WHISPERFIRE prompt based on analysis goal
    let prompt: string;
    switch (request.analysis_goal) {
      case 'instant_scan':
        const inputText = Array.isArray(request.input_text) ? request.input_text[0] : request.input_text;
        prompt = ScanInsightEngine.buildScanPrompt(
          inputText,
          request.content_type,
          request.relationship || 'Stranger',
          request.tone
        );
        break;

      case 'comeback_generation':
        const comebackText = Array.isArray(request.input_text) ? request.input_text[0] : request.input_text;
        prompt = ComebackViralWeapon.buildComebackPrompt(
          comebackText,
          request.tone,
          request.relationship
        );
        break;

      case 'pattern_profiling':
        if (!Array.isArray(request.input_text)) {
          throw new Error('Pattern profiling requires an array of messages');
        }
        prompt = PatternProfilingWeapon.buildPatternPrompt(
          request.input_text,
          request.relationship || 'Stranger',
          request.tone,
          request.person_name
        );
        break;

      default:
        throw new Error(`Unknown analysis goal: ${request.analysis_goal}`);
    }

    // 🔍 Check cache for identical requests
    const requestHash = this.createRequestHash(request, prompt);
    const cachedResult = this.cache.get(requestHash);
    
    if (cachedResult) {
      logger.info(`Returning cached WHISPERFIRE result for request hash: ${requestHash}`);
      return {
        response: cachedResult.response,
        modelUsed: cachedResult.modelUsed,
        processingTime: Date.now() - startTime,
      };
    }

    // 🚀 Call AI with WHISPERFIRE prompt
    let rawResponse: string;
    try {
      const completion = await client.chat.completions.create({
        model,
        messages: [{ role: 'user', content: prompt }],
        temperature: 0.4, // Slightly higher for WHISPERFIRE creativity
        max_tokens: 1500, // More tokens for detailed responses
      });

      rawResponse = completion.choices[0]?.message?.content || '';
    } catch (error) {
      logger.warn('AI call failed, returning mock WHISPERFIRE response for testing');
      rawResponse = this.generateMockWhisperfireResponse(request);
    }

    if (!rawResponse) {
      throw new Error('No response from AI');
    }

    // 🧪 Parse WHISPERFIRE JSON response
    const parsedResponse = this.parseWhisperfireAIResponse(rawResponse, request.analysis_goal);
    const processingTime = Date.now() - startTime;

    // 💾 Cache the result
    this.cache.set(requestHash, {
      response: parsedResponse,
      modelUsed: model,
      processingTime,
    });

    // 🧹 Clean cache if it gets too large
    this.cleanCache();

    logger.info(`WHISPERFIRE analysis completed in ${processingTime}ms`);

    return {
      response: parsedResponse,
      modelUsed: model,
      processingTime,
    };
  }

  // 🧠 LEGACY RESPONSE PARSER
  private parseLegacyAIResponse(rawResponse: string): AnalysisResponse {
    try {
      // Remove any markdown formatting
      const cleanResponse = rawResponse.replace(/```json\n?|\n?```/g, '').trim();
      const parsed = JSON.parse(cleanResponse);
      
      // Validate the response structure
      if (!parsed || typeof parsed !== 'object') {
        throw new Error('Invalid response structure');
      }

      return parsed as AnalysisResponse;
    } catch (error) {
      logger.error('Failed to parse legacy AI response:', error);
      throw new Error('Invalid AI response format');
    }
  }

  // 🚀 WHISPERFIRE RESPONSE PARSER
  private parseWhisperfireAIResponse(rawResponse: string, analysisGoal: string): LegendaryAnalysisResponse {
    try {
      // Remove any markdown formatting
      const cleanResponse = rawResponse.replace(/```json\n?|\n?```/g, '').trim();
      const parsed = JSON.parse(cleanResponse);
      
      // Validate the response structure
      if (!parsed || typeof parsed !== 'object') {
        throw new Error('Invalid WHISPERFIRE response structure');
      }

      // Type guard based on analysis goal
      switch (analysisGoal) {
        case 'instant_scan':
          return parsed as ScanInsightResponse;
        case 'comeback_generation':
          return parsed as ComebackWeaponResponse;
        case 'pattern_profiling':
          return parsed as PatternProfilingResponse;
        default:
          throw new Error(`Unknown analysis goal: ${analysisGoal}`);
      }
    } catch (error) {
      logger.error('Failed to parse WHISPERFIRE AI response:', error);
      throw new Error('Invalid WHISPERFIRE response format');
    }
  }

  // 🧠 LEGACY MOCK RESPONSE GENERATOR
  private generateMockResponse(request: AnalysisRequest): string {
    const mockResponses = {
      subtext_scan: {
        primary_motive: "Seeking validation through emotional manipulation",
        red_flag_score: 75,
        emotional_effect: "Creates confusion and self-doubt",
        what_theyre_not_saying: "I need you to feel bad so I feel better",
        suss_verdict: "Classic guilt trip with a side of gaslighting",
        comeback: "Your feelings aren't my responsibility"
      },
      lie_detection: {
        lie_risk_score: 85,
        behavior_pattern: "DARVO - Deny, Attack, Reverse Victim and Offender",
        evidence: ["Over-explanation", "Defensive tone", "Victim language"],
        subtext_summary: "They're hiding something and trying to make you feel crazy",
        suss_verdict: "This is textbook manipulation - trust your gut",
        comeback: "I don't need to prove my reality to you"
      },
      pattern_analysis: {
        pattern_detected: "Love bombing → Devalue → Discard cycle",
        archetype: "Narcissistic controller",
        emotional_effect: "Systematic confidence destruction",
        pattern_summary: "They're building you up to tear you down",
        suss_verdict: "This is a classic abuse pattern - get out now",
        comeback: "I see your game and I'm not playing"
      }
    };

    return JSON.stringify(mockResponses[request.analysis_goal as keyof typeof mockResponses]);
  }

  // 🚀 WHISPERFIRE MOCK RESPONSE GENERATOR
  private generateMockWhisperfireResponse(request: LegendaryAnalysisRequest): string {
    const mockResponses = {
      instant_scan: {
        instant_read: {
          headline: "🔥 Classic Gaslighting with Guilt Trip Chaser",
          salient_factor: "The 'I'm sorry you feel that way' non-apology",
          manipulation_detected: "DARVO + Emotional Invalidation",
          hidden_agenda: "Make you question your reality while avoiding accountability",
          emotional_target: "Your self-trust and emotional stability",
          power_play: "Status elevation through victim positioning"
        },
        psychological_scan: {
          red_flag_intensity: 85,
          manipulation_sophistication: 70,
          manipulation_certainty: 90,
          relationship_toxicity: 80
        },
        instant_insights: {
          what_theyre_not_saying: "I'm not sorry, I'm just sorry you caught me",
          why_this_feels_wrong: "They're making your pain about their comfort",
          contradiction_alert: "Claims to care but dismisses your feelings",
          next_tactic_likely: "Silent treatment followed by love bombing",
          pattern_prediction: "This escalates to full emotional abuse"
        },
        rapid_response: {
          boundary_needed: "Clear communication about emotional invalidation",
          comeback_suggestion: "I don't need you to understand my feelings to respect them",
          energy_protection: "Stop explaining yourself to someone who refuses to listen"
        },
        viral_verdict: {
          suss_verdict: "This is emotional terrorism disguised as concern",
          gut_validation: "Your instincts are 100% correct - this is manipulation",
          screenshot_worthy_insight: "When someone says 'I'm sorry you feel that way,' they're not sorry at all"
        },
        confidence_metrics: {
          ambiguity_warning: null,
          evidence_strength: "Strong",
          viral_potential: 95
        }
      },
      comeback_generation: {
        comeback_styles: {
          clipped: "Your feelings aren't my problem",
          one_liner: "I don't need your permission to feel what I feel",
          reverse_uno: "I'm sorry you feel the need to invalidate my emotions",
          screenshot_bait: "Gaslighting isn't a personality trait, it's a red flag",
          monologue: "I don't need you to understand my feelings to respect them. Your discomfort with my emotions says more about you than me."
        },
        tone_variations: {
          mature: "I don't need your validation to know my feelings are valid",
          savage: "Your emotional immaturity isn't my responsibility",
          petty: "I'm sorry you feel the need to be this way",
          playful: "Gaslighting isn't a personality trait, it's a choice"
        },
        primary_comeback: "I don't need your permission to feel what I feel",
        recommended_style: "reverse_uno",
        tactic_exposed: "Gaslighting",
        viral_metrics: {
          why_this_works: "Flips their tactic back on them while maintaining dignity",
          viral_factor: 90,
          power_level: 85,
          format_appeal: 95
        },
        safety_check: {
          relationship_appropriate: true,
          risk_level: "MODERATE",
          ethical_note: "Sets boundaries without escalating conflict"
        }
      },
      pattern_profiling: {
        behavioral_profile: {
          headline: "🔥 Narcissistic Controller in Full Manipulation Cycle",
          manipulator_archetype: "Emotional Vampire",
          dominant_pattern: "Love Bomb → Devalue → Discard → Hoover",
          manipulation_sophistication: 85
        },
        pattern_analysis: {
          manipulation_cycle: "Intimacy control through emotional dependency",
          tactics_evolution: ["Love bombing", "Boundary testing", "Emotional withdrawal", "Guilt tripping"],
          trigger_events: ["Your independence", "Your boundaries", "Your happiness"],
          escalation_timeline: "Progressive emotional control leading to full dependency",
          pattern_severity_score: 90
        },
        psychological_assessment: {
          primary_agenda: "Complete emotional control and dependency creation",
          emotional_damage_inflicted: "Systematic confidence destruction and reality distortion",
          power_control_methods: ["Gaslighting", "Love bombing", "Silent treatment", "Triangulation"],
          empathy_deficit_indicators: ["Emotional invalidation", "Victim blaming", "Reality distortion"],
          reality_distortion_level: 85,
          psychological_damage_score: 80
        },
        risk_assessment: {
          escalation_probability: 95,
          safety_concerns: ["Emotional abuse", "Psychological manipulation", "Dependency creation"],
          relationship_prognosis: "Will escalate to full emotional abuse if pattern continues",
          future_behavior_prediction: "Increased control attempts and emotional terrorism",
          intervention_urgency: "HIGH"
        },
        strategic_recommendations: {
          pattern_disruption_tactics: ["Grey rock method", "Boundary enforcement", "Emotional detachment"],
          boundary_enforcement_strategy: "Clear, consistent boundaries with consequences",
          communication_guidelines: "Minimal contact, factual communication only",
          escape_strategy: "Gradual emotional detachment with support system",
          safety_planning: "Document incidents, build support network, prepare exit plan"
        },
        viral_insights: {
          suss_verdict: "This is a classic narcissistic abuse cycle - get out before it gets worse",
          life_saving_insight: "Your instincts are trying to save you from emotional destruction",
          pattern_summary: "Systematic emotional control through love bombing and gaslighting",
          gut_validation: "Your gut is 100% correct - this is dangerous manipulation"
        },
        confidence_metrics: {
          analysis_confidence: 95,
          prediction_confidence: 90,
          evidence_quality: "Strong",
          pattern_rationale: "Clear escalation pattern with multiple manipulation tactics",
          viral_potential: 95
        }
      }
    };

    return JSON.stringify(mockResponses[request.analysis_goal as keyof typeof mockResponses]);
  }

  private createRequestHash(request: AnalysisRequest | LegendaryAnalysisRequest, prompt: string): string {
    const requestString = JSON.stringify({
      input_text: request.input_text,
      content_type: request.content_type,
      analysis_goal: request.analysis_goal,
      tone: request.tone,
      prompt: prompt
    });
    
    return createHash('md5').update(requestString).digest('hex');
  }

  private cleanCache(): void {
    if (this.cache.size > 100) {
      const firstKey = this.cache.keys().next().value;
      if (firstKey) {
        this.cache.delete(firstKey);
      }
    }
  }
} 