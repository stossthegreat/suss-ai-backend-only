import OpenAI from 'openai';
import { AnalysisRequest } from '../types/analysis';
import { LegendaryAnalysisRequest } from '../types/specializedAnalysis';

export class OpenAIConfig {
  private client: OpenAI | null = null;

  constructor() {
    // Don't initialize client here - do it lazily
  }

  private getClient(): OpenAI {
    if (!this.client) {
      const apiKey = process.env.OPENAI_API_KEY;
      if (!apiKey) {
        throw new Error('OPENAI_API_KEY environment variable is required');
      }
      this.client = new OpenAI({
        apiKey: apiKey,
      });
    }
    return this.client;
  }

  // 🧠 SMART MODEL ROUTING - Handles both Legacy and WHISPERFIRE
  selectModel(request: AnalysisRequest | LegendaryAnalysisRequest): 'gpt-4' | 'gpt-4o-mini' {
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

  getOpenAIClient(): OpenAI {
    return this.getClient();
  }
} 