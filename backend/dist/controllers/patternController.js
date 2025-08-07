"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.PatternController = void 0;
const LegendaryPatternProfilingWeapon_1 = require("../services/LegendaryPatternProfilingWeapon");
class PatternController {
    static async analyzePattern(req, res) {
        try {
            const { input_text, analysis_goal = 'pattern_profiling', tone = 'clinical', relationship = 'Partner', person_name } = req.body;
            console.log('🚀 Pattern Analysis Request:', {
                analysis_goal,
                relationship,
                tone,
                messageCount: Array.isArray(input_text) ? input_text.length : 1
            });
            if (!input_text) {
                return res.status(400).json({
                    error: 'Missing required field: input_text'
                });
            }
            let messages;
            if (Array.isArray(input_text)) {
                messages = input_text.filter((msg) => msg && msg.trim().length > 0);
            }
            else {
                messages = input_text.split('\n').filter((msg) => msg && msg.trim().length > 0);
            }
            if (messages.length === 0) {
                return res.status(400).json({
                    error: 'No valid messages provided for pattern analysis'
                });
            }
            console.log('📊 Processing pattern analysis for', messages.length, 'messages');
            const patternIntelligence = await LegendaryPatternProfilingWeapon_1.LegendaryPatternProfilingWeapon.analyzePatternIntelligence(messages, relationship, tone, person_name);
            console.log('✅ Pattern analysis completed successfully');
            return res.status(200).json({
                success: true,
                data: patternIntelligence,
                message: 'Pattern intelligence analysis completed'
            });
        }
        catch (error) {
            console.error('❌ Pattern analysis failed:', error);
            return res.status(500).json({
                error: 'Pattern analysis failed',
                details: error instanceof Error ? error.message : 'Unknown error'
            });
        }
    }
    static async healthCheck(_req, res) {
        return res.status(200).json({
            status: 'healthy',
            service: 'Pattern Intelligence System',
            version: '1.0.0',
            timestamp: new Date().toISOString()
        });
    }
}
exports.PatternController = PatternController;
//# sourceMappingURL=patternController.js.map