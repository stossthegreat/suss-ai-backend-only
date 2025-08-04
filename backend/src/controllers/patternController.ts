import { Request, Response } from 'express';
import { LegendaryPatternProfilingWeapon } from '../services/LegendaryPatternProfilingWeapon';

export class PatternController {
  static async analyzePattern(req: Request, res: Response) {
    try {
      const {
        input_text,
        analysis_goal = 'pattern_profiling',
        tone = 'clinical',
        relationship = 'Partner',
        person_name,
        output_style = 'Intel',
        preferred_model = 'gpt-4-turbo' // Default to GPT-4 Turbo
      } = req.body;

      console.log('🔍 Pattern analysis request:', {
        analysis_goal,
        tone,
        relationship,
        output_style,
        preferred_model,
        messageCount: Array.isArray(input_text) ? input_text.length : 1
      });

      // Validate input
      if (!input_text) {
        return res.status(400).json({
          success: false,
          error: 'input_text is required'
        });
      }

      // Process messages
      let messages: string[];
      if (Array.isArray(input_text)) {
        messages = input_text.filter((msg: string) => msg && msg.trim().length > 0);
      } else {
        messages = [input_text];
      }

      if (messages.length === 0) {
        return res.status(400).json({
          success: false,
          error: 'At least one valid message is required'
        });
      }

      // Map output style to enum
      const outputMode = output_style === 'elite_intel' ? 'Intel' 
        : output_style === 'narrative' ? 'Narrative'
        : output_style === 'roast' ? 'Roast'
        : 'Intel';

      console.log(`🚀 Starting pattern analysis with ${preferred_model}...`);

      const patternIntelligence = await LegendaryPatternProfilingWeapon.analyzePatternIntelligence(
        messages,
        relationship as any,
        outputMode as any,
        tone as any,
        person_name,
        preferred_model
      );

      console.log('✅ Pattern analysis completed successfully');

      return res.status(200).json({
        success: true,
        data: patternIntelligence,
        message: 'Pattern intelligence analysis completed',
        model_used: preferred_model
      });

    } catch (error) {
      console.error('❌ Pattern analysis failed:', error);
      return res.status(500).json({
        success: false,
        error: 'Pattern analysis failed',
        details: error instanceof Error ? error.message : 'Unknown error'
      });
    }
  }

  static async healthCheck(req: Request, res: Response) {
    try {
      return res.status(200).json({
        success: true,
        message: 'SUSS AI Backend is healthy',
        version: '2.0.0',
        timestamp: new Date().toISOString(),
        features: [
          'Multi-model AI support',
          'Pattern profiling',
          'Relationship-adaptive analysis',
          'Output style switching'
        ]
      });
    } catch (error) {
      return res.status(500).json({
        success: false,
        error: 'Health check failed'
      });
    }
  }

  static async getAvailableModels(req: Request, res: Response) {
    try {
      // This would return available models from the MultiModelAIEngine
      const availableModels = [
        {
          id: 'gpt-4-turbo',
          name: 'GPT-4 Turbo',
          provider: 'OpenAI',
          description: 'Latest GPT-4 model with improved reasoning'
        },
        {
          id: 'claude-3-opus',
          name: 'Claude 3 Opus',
          provider: 'Anthropic',
          description: 'Most capable Claude model'
        },
        {
          id: 'claude-3-sonnet',
          name: 'Claude 3 Sonnet',
          provider: 'Anthropic',
          description: 'Balanced Claude model'
        },
        {
          id: 'deepseek-v3',
          name: 'DeepSeek V3',
          provider: 'Together AI',
          description: 'Advanced coding and reasoning model'
        }
      ];

      return res.status(200).json({
        success: true,
        models: availableModels
      });
    } catch (error) {
      return res.status(500).json({
        success: false,
        error: 'Failed to get available models'
      });
    }
  }
} 