import OpenAI from 'openai';
import { AnalysisRequest } from '../types/analysis';
export declare class OpenAIConfig {
    private client;
    constructor();
    private getClient;
    selectModel(request: AnalysisRequest): 'gpt-4' | 'gpt-4o-mini';
    getOpenAIClient(): OpenAI;
}
//# sourceMappingURL=openai.d.ts.map