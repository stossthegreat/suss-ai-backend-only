"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.analysisRouter = void 0;
const express_1 = require("express");
const aiEngine_1 = require("../services/aiEngine");
const validation_1 = require("../middleware/validation");
const logger_1 = require("../utils/logger");
const uuid_1 = require("uuid");
const router = (0, express_1.Router)();
exports.analysisRouter = router;
const aiEngine = new aiEngine_1.SussAIEngine();
// 🎯 MAIN ANALYSIS ENDPOINT
router.post('/analyze', validation_1.validateAnalysisRequest, async (req, res) => {
    const analysisId = (0, uuid_1.v4)();
    try {
        logger_1.logger.info(`Starting analysis ${analysisId}`, {
            goal: req.body.analysis_goal,
            tone: req.body.tone,
            contentType: req.body.content_type
        });
        const result = await aiEngine.analyzeContent(req.body);
        const response = {
            success: true,
            data: result.response,
            processing_time: result.processingTime,
            model_used: result.modelUsed,
            analysis_id: analysisId,
        };
        logger_1.logger.info(`Analysis ${analysisId} completed successfully`);
        res.json(response);
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
        version: '1.0.0'
    });
});
//# sourceMappingURL=analysis.js.map