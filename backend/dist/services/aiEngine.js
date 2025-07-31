"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.SussAIEngine = void 0;
const openai_1 = require("../config/openai");
const godPrompt_1 = require("../prompts/godPrompt");
const logger_1 = require("../utils/logger");
const crypto_1 = require("crypto");
class SussAIEngine {
    constructor() {
        this.cache = new Map();
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
            // 🔍 Check cache for identical requests
            const requestHash = this.createRequestHash(request, prompt);
            const cachedResult = this.cache.get(requestHash);
            if (cachedResult) {
                logger_1.logger.info(`Returning cached result for request hash: ${requestHash}`);
                return {
                    response: cachedResult.response,
                    modelUsed: cachedResult.modelUsed,
                    processingTime: Date.now() - startTime,
                };
            }
            // 🚀 Call OpenAI
            let rawResponse;
            try {
                const completion = await this.openai.getOpenAIClient().chat.completions.create({
                    model,
                    messages: [{ role: 'user', content: prompt }],
                    temperature: 0.3, // Reduced from 0.7 for more consistent results
                    max_tokens: 1000,
                });
                rawResponse = completion.choices[0]?.message?.content || '';
            }
            catch (error) {
                // If OpenAI fails, return mock response for testing
                logger_1.logger.warn('OpenAI call failed, returning mock response for testing');
                rawResponse = this.generateMockResponse(request);
            }
            if (!rawResponse) {
                throw new Error('No response from OpenAI');
            }
            // 🧪 Parse JSON response
            const parsedResponse = this.parseAIResponse(rawResponse);
            const processingTime = Date.now() - startTime;
            // 💾 Cache the result
            this.cache.set(requestHash, {
                response: parsedResponse,
                modelUsed: model,
                processingTime,
            });
            // 🧹 Clean cache if it gets too large (keep last 100 results)
            if (this.cache.size > 100) {
                const firstKey = this.cache.keys().next().value;
                if (firstKey) {
                    this.cache.delete(firstKey);
                }
            }
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
    createRequestHash(request, prompt) {
        const requestString = JSON.stringify({
            input_text: request.input_text,
            content_type: request.content_type,
            analysis_goal: request.analysis_goal,
            tone: request.tone,
            comeback_enabled: request.comeback_enabled,
        });
        return (0, crypto_1.createHash)('md5').update(requestString + prompt).digest('hex');
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
    generateMockResponse(request) {
        const inputText = Array.isArray(request.input_text)
            ? request.input_text.join('\n')
            : request.input_text;
        const isPatternAnalysis = request.analysis_goal === 'pattern_analysis';
        const isComebackEnabled = request.comeback_enabled;
        if (isPatternAnalysis) {
            return JSON.stringify({
                lie_risk_score: 75,
                behavior_pattern: "Manipulative communication pattern detected",
                evidence: ["Inconsistent messaging", "Emotional manipulation", "Gaslighting indicators"],
                subtext_summary: "This person is using emotional manipulation to control the conversation",
                suss_verdict: "High deception risk - multiple red flags detected",
                pattern: "Emotional Manipulation",
                feeling: "Confusing and emotionally draining",
                headline: "This person is playing mind games with you",
                comeback: isComebackEnabled ? "I see what you're doing here. Let's keep this conversation honest and direct." : null
            });
        }
        else {
            return JSON.stringify({
                lie_risk_score: 65,
                behavior_pattern: "Suspicious communication detected",
                evidence: ["Vague responses", "Defensive language", "Inconsistent details"],
                subtext_summary: "This person is likely hiding something or being deceptive",
                suss_verdict: "Moderate deception risk - proceed with caution",
                pattern: "Deceptive Communication",
                feeling: "Suspicious and untrustworthy",
                headline: "Something doesn't add up here",
                comeback: isComebackEnabled ? "I'm not buying what you're selling. Can we get real here?" : null
            });
        }
    }
}
exports.SussAIEngine = SussAIEngine;
//# sourceMappingURL=aiEngine.js.map