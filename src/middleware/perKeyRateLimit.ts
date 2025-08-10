import rateLimit from 'express-rate-limit';

export const perKeyLimiter = rateLimit({
  windowMs: Number(process.env.RATE_LIMIT_WINDOW_MS || 60_000),
  max: Number(process.env.RATE_LIMIT_MAX || 60),
  keyGenerator: (req) => {
    const auth = req.get('authorization') || '';
    if (auth.startsWith('Bearer ')) return `key:${auth.slice(7)}`;
    // fall back to IP (trust proxy aware via server.ts)
    return req.ip || 'anon';
  },
  standardHeaders: true,
  legacyHeaders: false,
});
