import { Request, Response } from 'express';
import { PatternProfilingWeapon } from '../prompts/whisperfirePattern';
import { MultiModelAIEngine } from '../services/MultiModelAIEngine';

export class PatternController {
  private static aiEngine = new MultiModelAIEngine();

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

      // Build the prompt using the existing PatternProfilingWeapon
      const prompt = PatternProfilingWeapon.buildPatternPrompt(
        messages,
        relationship,
        outputMode as any,
        tone,
        person_name
      );

      // Use the multi-model AI engine
      const response = await this.aiEngine.generateResponse({
        prompt,
        model: preferred_model,
        temperature: 0.8, // Slightly creative for pattern analysis
        maxTokens: 3000,
      });

      console.log(`✅ Pattern analysis completed using ${response.model} (${response.provider})`);
      
      // Parse the JSON response
      try {
        const parsedResponse = JSON.parse(response.content);
        return res.status(200).json({
          success: true,
          data: parsedResponse,
          message: 'Pattern intelligence analysis completed',
          model_used: preferred_model
        });
      } catch (parseError) {
        console.error('❌ Failed to parse AI response as JSON:', parseError);
        console.log('Raw response:', response.content);
        
        return res.status(500).json({
          success: false,
          error: 'Failed to parse AI response',
          details: 'The AI response was not in the expected JSON format'
        });
      }

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
      const availableModels = this.aiEngine.getAvailableModels().map(modelId => {
        const modelInfo = this.aiEngine.getModelInfo(modelId);
        return {
          id: modelId,
          name: modelInfo?.name || modelId,
          provider: modelInfo?.provider || 'Unknown',
          description: this.getModelDescription(modelId)
        };
      });

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

  private static getModelDescription(modelId: string): string {
    switch (modelId) {
      case 'gpt-4-turbo':
        return 'The latest and most powerful model from OpenAI, capable of handling complex tasks and providing detailed insights.';
      case 'claude-3-opus':
        return 'Most capable Claude model with advanced reasoning and analysis capabilities.';
      case 'claude-3-sonnet':
        return 'Balanced Claude model offering good performance for pattern analysis.';
      case 'deepseek-v3':
        return 'Advanced coding and reasoning model, excellent for complex pattern detection.';
      default:
        return 'A powerful AI model for pattern analysis.';
    }
  }
} 