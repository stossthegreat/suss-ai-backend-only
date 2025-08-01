import OpenAI from 'openai';
import { AnalysisRequest } from '../types/analysis';
import { LegendaryAnalysisRequest } from '../types/specializedAnalysis';
export declare class OpenAIConfig {
    private client;
    constructor();
    private getClient;
    selectModel(request: AnalysisRequest | LegendaryAnalysisRequest): 'gpt-4' | 'gpt-4o-mini';
    getOpenAIClient(): OpenAI;
}
//# sourceMappingURL=openai.d.ts.map