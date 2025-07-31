import { AnalysisRequest, AnalysisResponse } from '../types/analysis';
export declare class SussAIEngine {
    private openai;
    private cache;
    constructor();
    analyzeContent(request: AnalysisRequest): Promise<{
        response: AnalysisResponse;
        modelUsed: string;
        processingTime: number;
    }>;
    private createRequestHash;
    private parseAIResponse;
    private generateMockResponse;
}
//# sourceMappingURL=aiEngine.d.ts.map