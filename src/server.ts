import 'dotenv/config';
import express from 'express';
import morgan from 'morgan';
import analyzeRouter from './routes/analyze.js';
import healthRouter from './routes/health.js';
import docsRouter from './routes/docs.js';
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

initSentry();

const app = express();
if (cfg.SENTRY_DSN) app.use(Sentry.Handlers.requestHandler());

app.use(requestId);
app.use(security);
app.use(noSniff);
app.use(morgan('tiny'));
app.use(limiter);
app.use(perKeyLimiter);

// NOTE: Stripe webhook requires raw body; mount it separately if needed

app.use(express.json({ limit: '1mb' })); // after stripe hook
app.use(jsonEnforcer);
app.use(requireApiKey);

app.get('/', (_req, res) => res.json({ ok: true, name: 'Whisperfire API' }));
app.use('/api/v1', healthRouter);
app.use('/api/v1', docsRouter);
app.use('/api/v1', metricsRouter);
app.use('/api/v1', adminRouter);
app.use('/api/v1', analyzeRouter);

if (cfg.SENTRY_DSN) app.use(Sentry.Handlers.errorHandler());
app.use(errorHandler);

const server = app.listen(cfg.PORT, () => console.log(`Whisperfire listening on ${cfg.PORT}`));
process.on('SIGTERM', () => server.close());
process.on('SIGINT', () => server.close()); 