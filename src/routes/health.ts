import { Router } from 'express';
import { cfg } from '../services/config.js';

const r = Router();

r.get('/health', (_req, res) => {
  res.json({
    ok: true,
    provider: {
      openai: !!cfg.OPENAI_API_KEY,
      together: !!(cfg.TOGETHER_API_KEY || cfg.DEEPSEEK_API_KEY)
    },
    models: {
      primary: cfg.PRIMARY_MODEL,
      fallback: cfg.FALLBACK_MODEL
    },
    build: process.env.RAILWAY_GIT_COMMIT_SHA || process.env.VERCEL_GIT_COMMIT_SHA || 'local'
  });
});

export default r;
