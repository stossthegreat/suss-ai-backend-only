import 'dotenv/config';
import express from 'express';
import morgan from 'morgan';
import analyzeRouter from './routes/analyze.js';
import healthRouter from './routes/health.js';
import metricsRouter from './routes/metrics.js';
import adminRouter from './routes/admin.js';
import { limiter } from './middleware/rateLimit.js';
import { perKeyLimiter } from './middleware/perKeyRateLimit.js';
import { errorHandler } from './middleware/errorHandler.js';
import { jsonEnforcer } from './middleware/jsonEnforcer.js';
import { requireApiKey } from './middleware/auth.js';
import { security, noSniff } from './middleware/security.js';
import { requestId } from './middleware/requestId.js';
import { initSentry, Sentry } from './services/sentry.js';
import { cfg } from './services/config.js';

const BUILD = process.env.RAILWAY_GIT_COMMIT_SHA || process.env.VERCEL_GIT_COMMIT_SHA || 'local';

initSentry();

const app = express();

// **** IMPORTANT: fix Railway proxy + rate-limit ****
app.set('trust proxy', 1);

if (cfg.SENTRY_DSN) app.use(Sentry.Handlers.requestHandler());

// baseline hardening
app.use(requestId);
app.use(security);
app.use(noSniff);
app.use(morgan('tiny'));

// rate limiting (must come AFTER trust proxy)
app.use(limiter);
app.use(perKeyLimiter);

// body + content-type
app.use(express.json({ limit: '1mb' }));
app.use(jsonEnforcer);

// simple health/version first (no auth!)
app.get('/', (_req, res) => res.json({ ok: true, name: 'Whisperfire API', build: BUILD }));
app.use('/api/v1', healthRouter);

// auth gate after health
app.use(requireApiKey);

// remaining routes
app.use('/api/v1', metricsRouter);
app.use('/api/v1', adminRouter);
app.use('/api/v1', analyzeRouter);

// sentry + error handler
if (cfg.SENTRY_DSN) app.use(Sentry.Handlers.errorHandler());
app.use(errorHandler);

const server = app.listen(cfg.PORT, () => {
  console.log(`Whisperfire listening on ${cfg.PORT} (build=${BUILD})`);
});
process.on('SIGTERM', () => server.close());
process.on('SIGINT', () => server.close());



