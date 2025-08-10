import { z } from 'zod';

// Debug: Log environment variables (without sensitive data)
console.log('🔍 Environment check:');
console.log('NODE_ENV:', process.env.NODE_ENV);
console.log('PORT:', process.env.PORT);
console.log('OPENAI_API_KEY length:', process.env.OPENAI_API_KEY?.length || 'NOT SET');
console.log('TOGETHER_API_KEY length:', process.env.TOGETHER_API_KEY?.length || 'NOT SET');
console.log('DEEPSEEK_API_KEY length (legacy):', process.env.DEEPSEEK_API_KEY?.length || 'NOT SET');
console.log('API_KEY length:', process.env.API_KEY?.length || 'NOT SET');

// Check if we're running on Railway
const isRailway = process.env.RAILWAY_ENVIRONMENT || process.env.RAILWAY_PROJECT_ID;
console.log('🚂 Running on Railway:', !!isRailway);

const Env = z.object({
  NODE_ENV: z.enum(['development','production','test']).default('production'),
  PORT: z.coerce.number().default(8080),

  // Providers / Models
  OPENAI_API_KEY: z.string().min(10, 'Missing OPENAI_API_KEY').optional(),
  TOGETHER_API_KEY: z.string().min(10, 'Missing TOGETHER_API_KEY').optional(),
  // Legacy alias; we’ll merge it with TOGETHER_API_KEY after parse
  DEEPSEEK_API_KEY: z.string().min(10, 'Missing DEEPSEEK_API_KEY').optional(),

  // Model slugs
  PRIMARY_MODEL: z.string().default('deepseek-ai/DeepSeek-V3'),
  FALLBACK_MODEL: z.string().default('gpt-4o-mini'),

  // Auth
  API_KEY: z.string().optional(),

  // Security
  CORS_ORIGINS: z.string().optional(),

  // Observability
  SENTRY_DSN: z.string().optional(),

  // Rate limit
  RATE_LIMIT_WINDOW_MS: z.coerce.number().default(60000),
  RATE_LIMIT_MAX: z.coerce.number().default(60),

  // Circuit breaker
  CB_FAILS: z.coerce.number().default(5),
  CB_RESET_MS: z.coerce.number().default(30000)
});

// Parse environment variables
let parsedConfig;
try {
  parsedConfig = Env.parse(process.env);

  // Merge Together/DeepSeek keys so either name works everywhere
  if (!parsedConfig.TOGETHER_API_KEY && parsedConfig.DEEPSEEK_API_KEY) {
    parsedConfig.TOGETHER_API_KEY = parsedConfig.DEEPSEEK_API_KEY;
  }
  if (!parsedConfig.DEEPSEEK_API_KEY && parsedConfig.TOGETHER_API_KEY) {
    parsedConfig.DEEPSEEK_API_KEY = parsedConfig.TOGETHER_API_KEY;
  }

  console.log('✅ Config validation successful');

  if (!parsedConfig.OPENAI_API_KEY) {
    console.warn('⚠️  WARNING: OPENAI_API_KEY is not set');
  }
  if (!parsedConfig.TOGETHER_API_KEY && !parsedConfig.DEEPSEEK_API_KEY) {
    console.warn('⚠️  WARNING: TOGETHER_API_KEY (or legacy DEEPSEEK_API_KEY) is not set');
  }
} catch (error) {
  console.error('❌ Config validation failed:', error);
  console.error('Environment variables that failed validation:');
  if (error instanceof z.ZodError) {
    error.errors.forEach(err => {
      console.error(`  - ${err.path.join('.')}: ${err.message}`);
    });
  }
  process.exit(1);
}

// Export the parsed config
export const cfg = parsedConfig;
