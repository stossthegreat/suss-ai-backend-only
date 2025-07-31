import { Request, Response, NextFunction } from 'express';
import { z } from 'zod';
import { AnalysisRequest } from '../types/analysis';

const analysisRequestSchema = z.object({
  input_text: z.union([z.string(), z.array(z.string())]),
  content_type: z.enum(['dm', 'bio', 'story', 'post']),
  analysis_goal: z.enum(['subtext_scan', 'lie_detection', 'pattern_analysis']),
  tone: z.enum(['brutal', 'soft', 'clinical', 'playful', 'petty']),
  comeback_enabled: z.boolean(),
  relationship: z.string().optional(),
});

export const validateAnalysisRequest = (req: Request, res: Response, next: NextFunction) => {
  try {
    const validatedData = analysisRequestSchema.parse(req.body);
    
    // Additional validation for pattern analysis
    if (validatedData.analysis_goal === 'pattern_analysis' && !Array.isArray(validatedData.input_text)) {
      return res.status(400).json({
        success: false,
        error: 'Pattern analysis requires an array of messages'
      });
    }

    req.body = validatedData as AnalysisRequest;
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