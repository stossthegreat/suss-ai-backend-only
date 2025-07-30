import { OpenAIConfig } from '../config/openai';
import { GodPromptSystem } from '../prompts/godPrompt';
import { AnalysisRequest, AnalysisResponse } from '../types/analysis';
import { logger } from '../utils/logger';
import { createHash } from 'crypto';

export class SussAIEngine {
  private openai: OpenAIConfig;
  private cache: Map<string, any> = new Map();

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

      // 🔍 Check cache for identical requests
      const requestHash = this.createRequestHash(request, prompt);
      const cachedResult = this.cache.get(requestHash);
      
      if (cachedResult) {
        logger.info(`Returning cached result for request hash: ${requestHash}`);
        return {
          response: cachedResult.response,
          modelUsed: cachedResult.modelUsed,
          processingTime: Date.now() - startTime,
        };
      }

      // 🚀 Call OpenAI
      const completion = await this.openai.getOpenAIClient().chat.completions.create({
        model,
        messages: [{ role: 'user', content: prompt }],
        temperature: 0.3, // Reduced from 0.7 for more consistent results
        max_tokens: 1000,
      });

      const rawResponse = completion.choices[0]?.message?.content;
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

  private createRequestHash(request: AnalysisRequest, prompt: string): string {
    const requestString = JSON.stringify({
      input_text: request.input_text,
      content_type: request.content_type,
      analysis_goal: request.analysis_goal,
      tone: request.tone,
      comeback_enabled: request.comeback_enabled,
    });
    
    return createHash('md5').update(requestString + prompt).digest('hex');
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