import { z } from 'zod';

console.log('🔍 Environment check:');
console.log('NODE_ENV:', process.env.NODE_ENV);
console.log('PORT:', process.env.PORT);
console.log('OPENAI_API_KEY length:', process.env.OPENAI_API_KEY?.length || 'NOT SET');
console.log('TOGETHER_API_KEY length:', process.env.TOGETHER_API_KEY?.length || 'NOT SET');
console.log('DEEPSEEK_API_KEY length (legacy):', process.env.DEEPSEEK_API_KEY?.length || 'NOT SET');
console.log('API_KEY length:', process.env.API_KEY?.length || 'NOT SET');

const isRailway = process.env.RAILWAY_ENVIRONMENT || process.env.RAILWAY_PROJECT_ID;
console.log('🚂 Running on Railway:', !!isRailway);

const Env = z.object({
  NODE_ENV: z.enum(['development','production','test']).default('production'),
  PORT: z.coerce.number().default(8080),
  OPENAI_API_KEY: z.string().min(10).optional(),
  TOGETHER_API_KEY: z.string().min(10).optional(),
  DEEPSEEK_API_KEY: z.string().min(10).optional(),
  PRIMARY_MODEL: z.string().default('deepseek-ai/DeepSeek-V3'),
  FALLBACK_MODEL: z.string().default('gpt-4o-mini'),
  API_KEY: z.string().optional(),
  CORS_ORIGINS: z.string().optional(),
  SENTRY_DSN: z.string().optional(),
  RATE_LIMIT_WINDOW_MS: z.coerce.number().default(60000),
  RATE_LIMIT_MAX: z.coerce.number().default(60),
  CB_FAILS: z.coerce.number().default(5),
  CB_RESET_MS: z.coerce.number().default(30000)
});

let cfg;
try {
  cfg = Env.parse(process.env);
  if (!cfg.TOGETHER_API_KEY && cfg.DEEPSEEK_API_KEY) cfg.TOGETHER_API_KEY = cfg.DEEPSEEK_API_KEY;
  if (!cfg.DEEPSEEK_API_KEY && cfg.TOGETHER_API_KEY) cfg.DEEPSEEK_API_KEY = cfg.TOGETHER_API_KEY;
  console.log('✅ Config validation successful');
  if (!cfg.OPENAI_API_KEY) console.warn('⚠️  WARNING: OPENAI_API_KEY is not set');
  if (!cfg.TOGETHER_API_KEY) console.warn('⚠️  WARNING: TOGETHER_API_KEY (or legacy DEEPSEEK_API_KEY) is not set');
} catch (e) {
  console.error('❌ Config validation failed:', e);
  process.exit(1);
}

export { cfg };
