import { AnalysisRequest, AnalysisResponse } from '../types/analysis';
import { LegendaryAnalysisRequest, LegendaryAnalysisResponse } from '../types/specializedAnalysis';
export declare class SussAIEngine {
    private openai;
    private cache;
    constructor();
    analyzeContent(request: AnalysisRequest | LegendaryAnalysisRequest): Promise<{
        response: AnalysisResponse | LegendaryAnalysisResponse;
        modelUsed: string;
        processingTime: number;
    }>;
    private handleLegacyRequest;
    private handleWhisperfireRequest;
    private parseLegacyAIResponse;
    private parseWhisperfireAIResponse;
    private generateMockResponse;
    private generateMockWhisperfireResponse;
    private createRequestHash;
    private cleanCache;
}
//# sourceMappingURL=aiEngine.d.ts.map