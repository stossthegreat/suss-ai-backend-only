import { Router, Request, Response } from 'express';
import { SussAIEngine } from '../services/aiEngine';
import { validateAnalysisRequest } from '../middleware/validation';
import { AnalysisRequest, APIResponse } from '../types/analysis';
import { logger } from '../utils/logger';
import { v4 as uuidv4 } from 'uuid';

const router = Router();
const aiEngine = new SussAIEngine();

// 🎯 MAIN ANALYSIS ENDPOINT
router.post('/analyze', validateAnalysisRequest, async (req: Request, res: Response) => {
  const analysisId = uuidv4();
  
  try {
    logger.info(`Starting analysis ${analysisId}`, { 
      goal: req.body.analysis_goal,
      tone: req.body.tone,
      contentType: req.body.content_type 
    });

    const result = await aiEngine.analyzeContent(req.body as AnalysisRequest);

    const response: APIResponse = {
      success: true,
      data: result.response,
      processing_time: result.processingTime,
      model_used: result.modelUsed,
      analysis_id: analysisId,
    };

    logger.info(`Analysis ${analysisId} completed successfully`);
    res.json(response);

  } catch (error) {
    logger.error(`Analysis ${analysisId} failed:`, error);
    
    const errorResponse: APIResponse = {
      success: false,
      error: error instanceof Error ? error.message : 'Analysis failed',
      analysis_id: analysisId,
    };

    res.status(500).json(errorResponse);
  }
});

// 🧪 HEALTH CHECK ENDPOINT
router.get('/health', (req: Request, res: Response) => {
  res.json({
    success: true,
    status: 'operational',
    timestamp: new Date().toISOString(),
    version: '1.0.0'
  });
});

export { router as analysisRouter }; 