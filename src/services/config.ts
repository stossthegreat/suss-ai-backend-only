import { z } from 'zod';

// Debug: Log environment variables (without sensitive data)
console.log('🔍 Environment check:');
console.log('NODE_ENV:', process.env.NODE_ENV);
console.log('PORT:', process.env.PORT);
console.log('OPENAI_API_KEY length:', process.env.OPENAI_API_KEY?.length || 'NOT SET');
console.log('DEEPSEEK_API_KEY length:', process.env.DEEPSEEK_API_KEY?.length || 'NOT SET');
console.log('API_KEY length:', process.env.API_KEY?.length || 'NOT SET');

const Env = z.object({
  NODE_ENV: z.enum(['development','production','test']).default('production'),
  PORT: z.coerce.number().default(8080),

  // Models
  OPENAI_API_KEY: z.string().min(10, 'Missing OPENAI_API_KEY'),
  DEEPSEEK_API_KEY: z.string().min(10, 'Missing DEEPSEEK_API_KEY'),
  PRIMARY_MODEL: z.string().default('deepseek-ai/deepseek-chat'),
  FALLBACK_MODEL: z.string().default('gpt-4o-mini'),

  // Auth
  API_KEY: z.string().optional(), // optional if you're only calling from your app
  
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

try {
  export const cfg = Env.parse(process.env);
  console.log('✅ Config validation successful');
} catch (error) {
  console.error('❌ Config validation failed:', error);
  console.error('Environment variables that failed validation:');
  
  if (error instanceof z.ZodError) {
    error.errors.forEach(err => {
      console.error(`  - ${err.path.join('.')}: ${err.message}`);
    });
  }
  
  // Exit with error code so Railway knows the deployment failed
  process.exit(1);
} 