import { Router } from 'express';
import { cfg } from '../services/config.js';
import { WhisperfireSchema } from '../services/schema.js';
const router = Router();
router.get('/health', (_req, res) => {
    res.json({
        status: 'ok',
        timestamp: new Date().toISOString(),
        uptime: process.uptime(),
        env: cfg.NODE_ENV,
        model: cfg.PRIMARY_MODEL
    });
});
router.get('/version', (_req, res) => {
    res.json({
        name: 'Whisperfire API',
        version: '1.0.0',
        description: 'Real-time psychological insight engine'
    });
});
router.get('/schema', (_req, res) => {
    res.json(JSON.parse(WhisperfireSchema.toString())); // lightweight peek; not full zod JSON schema
});
export default router;
