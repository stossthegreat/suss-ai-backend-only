import helmet from 'helmet';
import cors from 'cors';
import { cfg } from '../services/config.js';
const ORIGINS = (cfg.CORS_ORIGINS ?? '')
    .split(',').map(s => s.trim()).filter(Boolean);
export const security = [
    helmet({
        crossOriginOpenerPolicy: { policy: 'same-origin' },
        crossOriginResourcePolicy: { policy: 'cross-origin' }
    }),
    cors({
        origin: ORIGINS.length ? ORIGINS : true,
        credentials: false,
        methods: ['POST', 'GET'],
        allowedHeaders: ['Content-Type', 'Authorization', 'Idempotency-Key']
    })
];
export function noSniff(_req, res, next) {
    res.setHeader('X-Content-Type-Options', 'nosniff');
    next();
}
