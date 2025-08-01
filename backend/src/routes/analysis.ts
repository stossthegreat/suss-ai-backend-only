import { Router, Request, Response } from 'express';
import { SussAIEngine } from '../services/aiEngine';
import { validateAnalysisRequest } from '../middleware/validation';
import { AnalysisRequest, APIResponse } from '../types/analysis';
import { LegendaryAnalysisRequest, LegendaryAPIResponse, RiskLevels, LegendaryAnalysisResponse } from '../types/specializedAnalysis';
import { logger } from '../utils/logger';
import { v4 as uuidv4 } from 'uuid';

const router = Router();
const aiEngine = new SussAIEngine();

// 🚀 WHISPERFIRE METRICS CALCULATORS
const calculateViralPotential = (response: any): number => {
  // Calculate viral potential based on response structure
  if (response.viral_verdict || response.viral_metrics) {
    return response.viral_metrics?.viral_factor || response.confidence_metrics?.viral_potential || 75;
  }
  return 50; // Default viral potential
};

const calculateConfidenceLevel = (response: any): number => {
  // Calculate confidence based on response structure
  if (response.confidence_metrics) {
    return response.confidence_metrics.analysis_confidence || response.confidence_metrics.confidence_level || 80;
  }
  return 70; // Default confidence
};

const calculateEmpowermentScore = (response: any): number => {
  // Calculate empowerment score based on response structure
  if (response.rapid_response || response.strategic_recommendations) {
    return 85; // High empowerment for actionable responses
  }
  return 60; // Default empowerment
};

const calculateSafetyPriority = (response: any): RiskLevels => {
  // Calculate safety priority based on response structure
  if (response.risk_assessment) {
    return response.risk_assessment.intervention_urgency || RiskLevels.MODERATE;
  }
  if (response.safety_check) {
    return response.safety_check.risk_level || RiskLevels.MODERATE;
  }
  return RiskLevels.LOW; // Fixed: Use enum value instead of string
};

const calculatePsychologicalAccuracy = (response: any): number => {
  // Calculate psychological accuracy based on response structure
  if (response.confidence_metrics) {
    return response.confidence_metrics.analysis_confidence || 80;
  }
  return 75; // Default psychological accuracy
};

// 🎯 MAIN ANALYSIS ENDPOINT (Handles both Legacy and WHISPERFIRE)
router.post('/analyze', validateAnalysisRequest, async (req: Request, res: Response) => {
  const analysisId = uuidv4();
  
  try {
    const isLegacy = req.body.isLegacy === true;
    const systemType = isLegacy ? 'LEGACY' : 'WHISPERFIRE';
    
    logger.info(`Starting ${systemType} analysis ${analysisId}`, { 
      goal: req.body.analysis_goal,
      tone: req.body.tone,
      contentType: req.body.content_type 
    });

    const result = await aiEngine.analyzeContent(req.body as AnalysisRequest | LegendaryAnalysisRequest);

    // 🧠 Handle Legacy Response
    if (isLegacy) {
      const response: APIResponse = {
        success: true,
        data: result.response as any, // Fixed type casting
        processing_time: result.processingTime,
        model_used: result.modelUsed,
        analysis_id: analysisId,
      };

      logger.info(`Legacy analysis ${analysisId} completed successfully`);
      res.json(response);
      return;
    }

    // 🚀 Handle WHISPERFIRE Response
    const whisperfireResponse: LegendaryAPIResponse = {
      success: true,
      data: result.response as any, // Fixed type casting
      processing_time: result.processingTime,
      model_used: result.modelUsed,
      analysis_id: analysisId,
      viral_potential: calculateViralPotential(result.response),
      confidence_level: calculateConfidenceLevel(result.response),
      empowerment_score: calculateEmpowermentScore(result.response),
      safety_priority: calculateSafetyPriority(result.response),
      psychological_accuracy: calculatePsychologicalAccuracy(result.response),
    };

    logger.info(`WHISPERFIRE analysis ${analysisId} completed successfully`);
    res.json(whisperfireResponse);

  } catch (error) {
    logger.error(`Analysis ${analysisId} failed:`, error);
    
    const errorResponse = {
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
    version: '2.0.0',
    systems: {
      legacy: 'active',
      whisperfire: 'active'
    }
  });
});

export { router as analysisRouter }; 