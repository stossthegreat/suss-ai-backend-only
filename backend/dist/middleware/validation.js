"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.validateAnalysisRequest = void 0;
const zod_1 = require("zod");
const analysisRequestSchema = zod_1.z.object({
    input_text: zod_1.z.union([zod_1.z.string(), zod_1.z.array(zod_1.z.string())]),
    content_type: zod_1.z.enum(['dm', 'bio', 'story', 'post']),
    analysis_goal: zod_1.z.enum(['subtext_scan', 'lie_detection', 'pattern_analysis']),
    tone: zod_1.z.enum(['brutal', 'soft', 'clinical', 'playful', 'petty']),
    comeback_enabled: zod_1.z.boolean(),
});
const validateAnalysisRequest = (req, res, next) => {
    try {
        const validatedData = analysisRequestSchema.parse(req.body);
        // Additional validation for pattern analysis
        if (validatedData.analysis_goal === 'pattern_analysis' && !Array.isArray(validatedData.input_text)) {
            return res.status(400).json({
                success: false,
                error: 'Pattern analysis requires an array of messages'
            });
        }
        req.body = validatedData;
        next();
    }
    catch (error) {
        if (error instanceof zod_1.z.ZodError) {
            return res.status(400).json({
                success: false,
                error: 'Invalid request format',
                details: error.errors
            });
        }
        next(error);
    }
};
exports.validateAnalysisRequest = validateAnalysisRequest;
//# sourceMappingURL=validation.js.map