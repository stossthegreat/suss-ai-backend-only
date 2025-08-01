"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.validateAnalysisRequest = void 0;
const zod_1 = require("zod");
// 🧠 LEGACY SCHEMA (for backward compatibility)
const legacyAnalysisRequestSchema = zod_1.z.object({
    input_text: zod_1.z.union([zod_1.z.string(), zod_1.z.array(zod_1.z.string())]),
    content_type: zod_1.z.enum(['dm', 'bio', 'story', 'post']),
    analysis_goal: zod_1.z.enum(['subtext_scan', 'lie_detection', 'pattern_analysis']),
    tone: zod_1.z.enum(['brutal', 'soft', 'clinical', 'playful', 'petty']),
    comeback_enabled: zod_1.z.boolean(),
    relationship: zod_1.z.string().optional(),
});
// 🚀 WHISPERFIRE SCHEMA (new system)
const whisperfireAnalysisRequestSchema = zod_1.z.object({
    input_text: zod_1.z.union([zod_1.z.string(), zod_1.z.array(zod_1.z.string())]),
    content_type: zod_1.z.enum(['dm', 'bio', 'story', 'post']),
    analysis_goal: zod_1.z.enum(['instant_scan', 'comeback_generation', 'pattern_profiling']),
    tone: zod_1.z.enum(['brutal', 'soft', 'clinical']),
    relationship: zod_1.z.enum(['Partner', 'Ex', 'Date', 'Friend', 'Coworker', 'Family', 'Roommate', 'Stranger']).optional(),
    person_name: zod_1.z.string().optional(),
    style_preference: zod_1.z.enum(['clipped', 'one_liner', 'reverse_uno', 'screenshot_bait', 'monologue']).optional(),
});
const validateAnalysisRequest = (req, res, next) => {
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
            req.body = legacyData;
            req.body.isLegacy = true; // Flag for legacy processing
            next();
            return;
        }
        catch (legacyError) {
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
        req.body = whisperfireData;
        req.body.isLegacy = false; // Flag for WHISPERFIRE processing
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