import { AnalysisRequest, AnalysisResponse } from '../types/analysis';
export declare class SussAIEngine {
    private openai;
    constructor();
    analyzeContent(request: AnalysisRequest): Promise<{
        response: AnalysisResponse;
        modelUsed: string;
        processingTime: number;
    }>;
    private parseAIResponse;
}
//# sourceMappingURL=aiEngine.d.ts.map