"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.analysisRouter = void 0;
const express_1 = require("express");
const aiEngine_1 = require("../services/aiEngine");
const validation_1 = require("../middleware/validation");
const specializedAnalysis_1 = require("../types/specializedAnalysis");
const logger_1 = require("../utils/logger");
const uuid_1 = require("uuid");
const router = (0, express_1.Router)();
exports.analysisRouter = router;
const aiEngine = new aiEngine_1.SussAIEngine();
// 🚀 WHISPERFIRE METRICS CALCULATORS
const calculateViralPotential = (response) => {
    // Calculate viral potential based on response structure
    if (response.viral_verdict || response.viral_metrics) {
        return response.viral_metrics?.viral_factor || response.confidence_metrics?.viral_potential || 75;
    }
    return 50; // Default viral potential
};
const calculateConfidenceLevel = (response) => {
    // Calculate confidence based on response structure
    if (response.confidence_metrics) {
        return response.confidence_metrics.analysis_confidence || response.confidence_metrics.confidence_level || 80;
    }
    return 70; // Default confidence
};
const calculateEmpowermentScore = (response) => {
    // Calculate empowerment score based on response structure
    if (response.rapid_response || response.strategic_recommendations) {
        return 85; // High empowerment for actionable responses
    }
    return 60; // Default empowerment
};
const calculateSafetyPriority = (response) => {
    // Calculate safety priority based on response structure
    if (response.risk_assessment) {
        return response.risk_assessment.intervention_urgency || specializedAnalysis_1.RiskLevels.MODERATE;
    }
    if (response.safety_check) {
        return response.safety_check.risk_level || specializedAnalysis_1.RiskLevels.MODERATE;
    }
    return specializedAnalysis_1.RiskLevels.LOW; // Fixed: Use enum value instead of string
};
const calculatePsychologicalAccuracy = (response) => {
    // Calculate psychological accuracy based on response structure
    if (response.confidence_metrics) {
        return response.confidence_metrics.analysis_confidence || 80;
    }
    return 75; // Default psychological accuracy
};
// 🎯 MAIN ANALYSIS ENDPOINT (Handles both Legacy and WHISPERFIRE)
router.post('/analyze', validation_1.validateAnalysisRequest, async (req, res) => {
    const analysisId = (0, uuid_1.v4)();
    try {
        const isLegacy = req.body.isLegacy === true;
        const systemType = isLegacy ? 'LEGACY' : 'WHISPERFIRE';
        logger_1.logger.info(`Starting ${systemType} analysis ${analysisId}`, {
            goal: req.body.analysis_goal,
            tone: req.body.tone,
            contentType: req.body.content_type
        });
        const result = await aiEngine.analyzeContent(req.body);
        // 🧠 Handle Legacy Response
        if (isLegacy) {
            const response = {
                success: true,
                data: result.response, // Fixed type casting
                processing_time: result.processingTime,
                model_used: result.modelUsed,
                analysis_id: analysisId,
            };
            logger_1.logger.info(`Legacy analysis ${analysisId} completed successfully`);
            res.json(response);
            return;
        }
        // 🚀 Handle WHISPERFIRE Response
        const whisperfireResponse = {
            success: true,
            data: result.response, // Fixed type casting
            processing_time: result.processingTime,
            model_used: result.modelUsed,
            analysis_id: analysisId,
            viral_potential: calculateViralPotential(result.response),
            confidence_level: calculateConfidenceLevel(result.response),
            empowerment_score: calculateEmpowermentScore(result.response),
            safety_priority: calculateSafetyPriority(result.response),
            psychological_accuracy: calculatePsychologicalAccuracy(result.response),
        };
        logger_1.logger.info(`WHISPERFIRE analysis ${analysisId} completed successfully`);
        res.json(whisperfireResponse);
    }
    catch (error) {
        logger_1.logger.error(`Analysis ${analysisId} failed:`, error);
        const errorResponse = {
            success: false,
            error: error instanceof Error ? error.message : 'Analysis failed',
            analysis_id: analysisId,
        };
        res.status(500).json(errorResponse);
    }
});
// 🧪 HEALTH CHECK ENDPOINT
router.get('/health', (req, res) => {
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
//# sourceMappingURL=analysis.js.map