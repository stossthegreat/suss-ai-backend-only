import rateLimit from 'express-rate-limit';

// On Railway / any proxy, trust proxy must be enabled in server.ts.
// This limiter is defensive: if XFF looks weird, we fall back to req.ip.
export const limiter = rateLimit({
  windowMs: Number(process.env.RATE_LIMIT_WINDOW_MS || 60_000),
  max: Number(process.env.RATE_LIMIT_MAX || 60),
  standardHeaders: true,
  legacyHeaders: false,
  skipFailedRequests: false,
  keyGenerator: (req) => {
    // Prefer Express' computed IP (honors trust proxy)
    return req.ip || req.headers['x-forwarded-for']?.toString() || req.socket.remoteAddress || 'unknown';
  }
});
