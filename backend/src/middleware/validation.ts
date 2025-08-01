import { Request, Response, NextFunction } from 'express';
import { z } from 'zod';
import { AnalysisRequest } from '../types/analysis';
import { LegendaryAnalysisRequest, AnalysisGoals, ContentTypes, RelationshipContexts } from '../types/specializedAnalysis';

// 🧠 LEGACY SCHEMA (for backward compatibility)
const legacyAnalysisRequestSchema = z.object({
  input_text: z.union([z.string(), z.array(z.string())]),
  content_type: z.enum(['dm', 'bio', 'story', 'post']),
  analysis_goal: z.enum(['subtext_scan', 'lie_detection', 'pattern_analysis']),
  tone: z.enum(['brutal', 'soft', 'clinical', 'playful', 'petty']),
  comeback_enabled: z.boolean(),
  relationship: z.string().optional(),
});

// 🚀 WHISPERFIRE SCHEMA (new system)
const whisperfireAnalysisRequestSchema = z.object({
  input_text: z.union([z.string(), z.array(z.string())]),
  content_type: z.enum(['dm', 'bio', 'story', 'post']),
  analysis_goal: z.enum(['instant_scan', 'comeback_generation', 'pattern_profiling']),
  tone: z.enum(['brutal', 'soft', 'clinical']),
  relationship: z.enum(['Partner', 'Ex', 'Date', 'Friend', 'Coworker', 'Family', 'Roommate', 'Stranger']).optional(),
  person_name: z.string().optional(),
  style_preference: z.enum(['clipped', 'one_liner', 'reverse_uno', 'screenshot_bait', 'monologue']).optional(),
});

export const validateAnalysisRequest = (req: Request, res: Response, next: NextFunction) => {
  try {
    // 🧠 Try legacy schema first (backward compatibility)
    try {
      const legacyData = legacyAnalysisRequestSchema.parse(req.body);
      
      // Additional validation for pattern analysis
      if (legacyData.analysis_goal === 'pattern_analysis' && !Array.isArray(legacyData.input_text)) {
        return res.status(400).json({
          success: false,
          error: 'Pattern analysis requires an array of messages'
        });
      }

      req.body = legacyData as AnalysisRequest;
      req.body.isLegacy = true; // Flag for legacy processing
      next();
      return;
    } catch (legacyError) {
      // Legacy validation failed, try WHISPERFIRE schema
    }

    // 🚀 Try WHISPERFIRE schema
    const whisperfireData = whisperfireAnalysisRequestSchema.parse(req.body);
    
    // Additional validation for pattern profiling
    if (whisperfireData.analysis_goal === 'pattern_profiling' && !Array.isArray(whisperfireData.input_text)) {
      return res.status(400).json({
        success: false,
        error: 'Pattern profiling requires an array of messages'
      });
    }

    req.body = whisperfireData as LegendaryAnalysisRequest;
    req.body.isLegacy = false; // Flag for WHISPERFIRE processing
    next();

  } catch (error) {
    if (error instanceof z.ZodError) {
      return res.status(400).json({
        success: false,
        error: 'Invalid request format',
        details: error.errors
      });
    }
    next(error);
  }
}; 