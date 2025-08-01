"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.OpenAIConfig = void 0;
const openai_1 = __importDefault(require("openai"));
class OpenAIConfig {
    constructor() {
        this.client = null;
        // Don't initialize client here - do it lazily
    }
    getClient() {
        if (!this.client) {
            const apiKey = process.env.OPENAI_API_KEY;
            if (!apiKey) {
                throw new Error('OPENAI_API_KEY environment variable is required');
            }
            this.client = new openai_1.default({
                apiKey: apiKey,
            });
        }
        return this.client;
    }
    // 🧠 SMART MODEL ROUTING - Handles both Legacy and WHISPERFIRE
    selectModel(request) {
        const textLength = Array.isArray(request.input_text)
            ? request.input_text.join('').length
            : request.input_text.length;
        // 🧠 Legacy system routing
        if ('comeback_enabled' in request) {
            // Use GPT-4 Turbo for heavy lifting
            if (request.analysis_goal === 'lie_detection' ||
                request.analysis_goal === 'pattern_analysis' ||
                textLength > 500 ||
                Array.isArray(request.input_text)) {
                return 'gpt-4';
            }
            // Use GPT-4 Mini for fast scans
            return 'gpt-4o-mini';
        }
        // 🚀 WHISPERFIRE system routing
        if (request.analysis_goal === 'pattern_profiling' ||
            request.analysis_goal === 'instant_scan' ||
            textLength > 500 ||
            Array.isArray(request.input_text)) {
            return 'gpt-4';
        }
        // Use GPT-4 Mini for comeback generation and simple scans
        return 'gpt-4o-mini';
    }
    getOpenAIClient() {
        return this.getClient();
    }
}
exports.OpenAIConfig = OpenAIConfig;
//# sourceMappingURL=openai.js.map