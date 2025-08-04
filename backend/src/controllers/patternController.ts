import { Request, Response } from 'express';
import { LegendaryPatternProfilingWeapon } from '../services/LegendaryPatternProfilingWeapon';

export class PatternController {
  
  // 🚀 PATTERN ANALYSIS ENDPOINT
  static async analyzePattern(req: Request, res: Response) {
    try {
      const {
        input_text,
        analysis_goal = 'pattern_profiling',
        tone = 'clinical',
        relationship = 'Partner',
        person_name,
        output_style = 'Intel' // Add output style parameter
      } = req.body;

      console.log('🚀 Pattern Analysis Request:', {
        analysis_goal,
        relationship,
        tone,
        output_style,
        messageCount: Array.isArray(input_text) ? input_text.length : 1
      });

      // Validate input
      if (!input_text) {
        return res.status(400).json({
          error: 'Missing required field: input_text'
        });
      }

      // Convert input_text to array of messages for pattern analysis
      let messages: string[];
      if (Array.isArray(input_text)) {
        messages = input_text.filter((msg: string) => msg && msg.trim().length > 0);
      } else {
        // Split single text into messages for pattern analysis
        messages = input_text.split('\n').filter((msg: string) => msg && msg.trim().length > 0);
      }

      if (messages.length === 0) {
        return res.status(400).json({
          error: 'No valid messages provided for pattern analysis'
        });
      }

      console.log('📊 Processing pattern analysis for', messages.length, 'messages');

      // Map output style to the expected format
      const outputMode = output_style === 'elite_intel' ? 'Intel' 
        : output_style === 'narrative' ? 'Narrative'
        : output_style === 'roast' ? 'Roast'
        : 'Intel';

      // Use the upgraded Legendary Pattern Profiling Weapon
      const patternIntelligence = await LegendaryPatternProfilingWeapon.analyzePatternIntelligence(
        messages,
        relationship as any,
        outputMode as any,
        tone as any,
        person_name
      );

      console.log('✅ Pattern analysis completed successfully');

      // Return the intelligence report
      return res.status(200).json({
        success: true,
        data: patternIntelligence,
        message: 'Pattern intelligence analysis completed'
      });

    } catch (error) {
      console.error('❌ Pattern analysis failed:', error);
      return res.status(500).json({
        error: 'Pattern analysis failed',
        details: error instanceof Error ? error.message : 'Unknown error'
      });
    }
  }

  // 🧠 HEALTH CHECK ENDPOINT
  static async healthCheck(_req: Request, res: Response) {
    return res.status(200).json({
      status: 'healthy',
      service: 'Pattern Intelligence System',
      version: '2.0.0',
      timestamp: new Date().toISOString()
    });
  }
} 