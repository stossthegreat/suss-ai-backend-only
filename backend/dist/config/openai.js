"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.OpenAIConfig = void 0;
const openai_1 = __importDefault(require("openai"));
class OpenAIConfig {
    constructor() {
        this.client = new openai_1.default({
            apiKey: process.env.OPENAI_API_KEY,
        });
    }
    // 🧠 SMART MODEL ROUTING - Exactly as specified
    selectModel(request) {
        const textLength = Array.isArray(request.input_text)
            ? request.input_text.join('').length
            : request.input_text.length;
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
    getClient() {
        return this.client;
    }
}
exports.OpenAIConfig = OpenAIConfig;
//# sourceMappingURL=openai.js.map