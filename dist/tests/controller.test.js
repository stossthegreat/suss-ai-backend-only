import { describe, it, expect, vi, beforeEach } from 'vitest';
import { analyze } from '../controllers/analyzeController.js';
// Mock the services
vi.mock('../services/modelRouter.js', () => ({
    generateWhisperfire: vi.fn()
}));
vi.mock('../services/cache.js', () => ({
    getCached: vi.fn(),
    setCached: vi.fn()
}));
vi.mock('../services/logger.js', () => ({
    log: vi.fn()
}));
import { generateWhisperfire } from '../services/modelRouter.js';
import { getCached } from '../services/cache.js';
describe('Analyze Controller', () => {
    let mockRequest;
    let mockResponse;
    let mockJson;
    let mockStatus;
    beforeEach(() => {
        mockJson = vi.fn();
        mockStatus = vi.fn().mockReturnValue({ json: mockJson });
        mockRequest = {
            body: {}
        };
        mockResponse = {
            status: mockStatus,
            json: mockJson
        };
        vi.clearAllMocks();
    });
    const mockValidResponse = {
        context: {
            relationship: 'Partner',
            tone: 'clinical',
            content_type: 'dm',
            subject_name: null,
            tab: 'scan'
        },
        headline: 'Gaslighting detected',
        core_take: 'Clear attempt to invalidate feelings',
        tactic: {
            label: 'Gaslighting',
            confidence: 85
        },
        motives: 'Control and dominance',
        targeting: 'Emotional vulnerability',
        power_play: 'Invalidation tactic',
        receipts: ['Dismissive language', 'Emotional invalidation'],
        next_moves: 'Document and set boundaries',
        suggested_reply: {
            style: 'clipped',
            text: 'My feelings are valid.'
        },
        safety: {
            risk_level: 'MODERATE',
            notes: 'Monitor for escalation'
        },
        metrics: {
            red_flag: 75,
            certainty: 85,
            viral_potential: 60
        },
        pattern: {
            cycle: null,
            prognosis: null
        },
        ambiguity: {
            warning: null,
            missing_evidence: []
        }
    };
    it('should handle scan analysis successfully', async () => {
        mockRequest.body = {
            tab: 'scan',
            relationship: 'Partner',
            tone: 'clinical',
            content_type: 'dm',
            subject_name: 'Alex',
            message: 'Why are you always so sensitive?'
        };
        getCached.mockReturnValue(null);
        generateWhisperfire.mockResolvedValue(mockValidResponse);
        await analyze(mockRequest, mockResponse);
        expect(mockStatus).toHaveBeenCalledWith(200);
        expect(mockJson).toHaveBeenCalledWith({
            success: true,
            data: mockValidResponse,
            processing_time: expect.any(Number),
            model_used: expect.any(String)
        });
    });
    it('should return 400 for missing required fields', async () => {
        mockRequest.body = {
            tab: 'scan',
            relationship: 'Partner'
            // Missing tone and content_type
        };
        await analyze(mockRequest, mockResponse);
        expect(mockStatus).toHaveBeenCalledWith(400);
        expect(mockJson).toHaveBeenCalledWith({
            success: false,
            error: 'Missing required fields: tab, relationship, tone, content_type'
        });
    });
    it('should return 400 for invalid tab', async () => {
        mockRequest.body = {
            tab: 'invalid',
            relationship: 'Partner',
            tone: 'clinical',
            content_type: 'dm',
            message: 'Test'
        };
        await analyze(mockRequest, mockResponse);
        expect(mockStatus).toHaveBeenCalledWith(400);
        expect(mockJson).toHaveBeenCalledWith({
            success: false,
            error: 'Invalid tab: must be scan, comeback, or pattern'
        });
    });
});
