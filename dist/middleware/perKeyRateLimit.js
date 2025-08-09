import rateLimit from 'express-rate-limit';
export const perKeyLimiter = rateLimit({
    keyGenerator: (req) => {
        const auth = req.get('authorization') ?? '';
        if (auth.startsWith('Bearer '))
            return 'key:' + auth.slice(7);
        const ip = req.headers['x-forwarded-for'] || req.ip || 'anon';
        return 'ip:' + ip;
    },
    windowMs: Number(process.env.RATE_LIMIT_WINDOW_MS ?? 60000),
    max: Number(process.env.RATE_LIMIT_MAX ?? 60),
    standardHeaders: true,
    legacyHeaders: false
});
