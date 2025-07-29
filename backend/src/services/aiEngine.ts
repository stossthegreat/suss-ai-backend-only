import { OpenAIConfig } from '../config/openai';
import { GodPromptSystem } from '../prompts/godPrompt';
import { AnalysisRequest, AnalysisResponse } from '../types/analysis';
import { logger } from '../utils/logger';

export class SussAIEngine {
  private openai: OpenAIConfig;

  constructor() {
    this.openai = new OpenAIConfig();
  }

  async analyzeContent(request: AnalysisRequest): Promise<{
    response: AnalysisResponse;
    modelUsed: string;
    processingTime: number;
  }> {
    const startTime = Date.now();
    
    try {
      // 🧠 Smart model selection
      const model = this.openai.selectModel(request);
      logger.info(`Using model: ${model} for ${request.analysis_goal}`);

      // 🔮 Build the God prompt
      const prompt = GodPromptSystem.buildPrompt(request);

      // 🚀 Call OpenAI
      const completion = await this.openai.getOpenAIClient().chat.completions.create({
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

      logger.info(`Analysis completed in ${processingTime}ms`);

      return {
        response: parsedResponse,
        modelUsed: model,
        processingTime,
      };

    } catch (error) {
      logger.error('AI Engine Error:', error);
      throw new Error(`Analysis failed: ${error instanceof Error ? error.message : 'Unknown error'}`);
    }
  }

  private parseAIResponse(rawResponse: string): AnalysisResponse {
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

      return parsed as AnalysisResponse;
    } catch (error) {
      logger.error('JSON Parse Error:', { rawResponse, error });
      throw new Error('Failed to parse AI response as JSON');
    }
  }
} 