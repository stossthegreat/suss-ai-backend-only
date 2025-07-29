import OpenAI from 'openai';
import { AnalysisRequest } from '../types/analysis';

export class OpenAIConfig {
  private client: OpenAI;

  constructor() {
    this.client = new OpenAI({
      apiKey: process.env.OPENAI_API_KEY,
    });
  }

  // 🧠 SMART MODEL ROUTING - Exactly as specified
  selectModel(request: AnalysisRequest): 'gpt-4' | 'gpt-4o-mini' {
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

  getClient(): OpenAI {
    return this.client;
  }
} 