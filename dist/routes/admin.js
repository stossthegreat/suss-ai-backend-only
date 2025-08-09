import { Router } from 'express';
import { breakerState } from '../services/circuitBreaker.js';
import { getCached } from '../services/cache.js';
const router = Router();
// lightweight sanity endpoints
router.get('/admin/status', (_req, res) => res.json({ breaker: breakerState(), time: Date.now() }));
router.post('/admin/cache/preview', (req, res) => {
    const found = getCached(req.body || {});
    res.json({ hit: !!found, data: found ?? null });
});
export default router;
