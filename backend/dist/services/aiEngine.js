"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.SussAIEngine = void 0;
const openai_1 = require("../config/openai");
const godPrompt_1 = require("../prompts/godPrompt");
const logger_1 = require("../utils/logger");
class SussAIEngine {
    constructor() {
        this.openai = new openai_1.OpenAIConfig();
    }
    async analyzeContent(request) {
        const startTime = Date.now();
        try {
            // 🧠 Smart model selection
            const model = this.openai.selectModel(request);
            logger_1.logger.info(`Using model: ${model} for ${request.analysis_goal}`);
            // 🔮 Build the God prompt
            const prompt = godPrompt_1.GodPromptSystem.buildPrompt(request);
            // 🚀 Call OpenAI
            const completion = await this.openai.getClient().chat.completions.create({
                model,
                messages: [{ role: 'user', content: prompt }],
                temperature: 0.7,
                max_tokens: 1000,
            });
            const rawResponse = completion.choices[0]?.message?.content;
            if (!rawResponse) {
                throw new Error('No response from OpenAI');
            }
            // 🧪 Parse JSON response
            const parsedResponse = this.parseAIResponse(rawResponse);
            const processingTime = Date.now() - startTime;
            logger_1.logger.info(`Analysis completed in ${processingTime}ms`);
            return {
                response: parsedResponse,
                modelUsed: model,
                processingTime,
            };
        }
        catch (error) {
            logger_1.logger.error('AI Engine Error:', error);
            throw new Error(`Analysis failed: ${error instanceof Error ? error.message : 'Unknown error'}`);
        }
    }
    parseAIResponse(rawResponse) {
        try {
            // Clean up response (remove markdown, extra text)
            const cleanedResponse = rawResponse
                .replace(/```json\n?/g, '')
                .replace(/```\n?/g, '')
                .trim();
            const parsed = JSON.parse(cleanedResponse);
            // 🔍 Validate required fields exist
            if (!parsed || typeof parsed !== 'object') {
                throw new Error('Invalid JSON structure');
            }
            return parsed;
        }
        catch (error) {
            logger_1.logger.error('JSON Parse Error:', { rawResponse, error });
            throw new Error('Failed to parse AI response as JSON');
        }
    }
}
exports.SussAIEngine = SussAIEngine;
//# sourceMappingURL=aiEngine.js.map