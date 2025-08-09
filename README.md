# Whisperfire Backend API

Real-time psychological insight engine for analyzing manipulation tactics and generating viral comebacks.

## Features

- **Unified Schema**: Single JSON schema across scan, comeback, and pattern analysis
- **Model Fallback**: DeepSeek V3 primary, GPT-4 Turbo fallback
- **Security**: API key auth, rate limiting, CORS protection
- **Resilience**: Circuit breaker, retries, JSON parsing guards
- **Observability**: Prometheus metrics, health checks, Sentry integration
- **Caching**: 5-minute LRU cache for identical inputs

## Quick Start

### Prerequisites

- Node.js 18+ 
- Railway account (for deployment)
- OpenAI API key
- DeepSeek API key

### Local Development

1. **Clone and install**
   ```bash
   git clone <repo>
   cd whisperfire-backend
   npm ci
   ```

2. **Configure environment**
   ```bash
   cp env.example .env
   # Edit .env with your API keys
   ```

3. **Run development server**
   ```bash
   npm run dev
   ```

4. **Test the API**
   ```bash
   curl -X POST http://localhost:8080/api/v1/analyze \
     -H "Content-Type: application/json" \
     -H "Authorization: Bearer YOUR_API_KEY" \
     -d '{
       "tab": "scan",
       "relationship": "Partner", 
       "tone": "clinical",
       "content_type": "dm",
       "message": "Why are you always so sensitive?"
     }'
   ```

## API Reference

### Authentication

All endpoints require API key authentication via `Authorization: Bearer YOUR_API_KEY` header.

### Endpoints

#### POST `/api/v1/analyze`

Analyze messages for manipulation tactics.

**Request Body:**
```json
{
  "tab": "scan|comeback|pattern",
  "relationship": "Partner|Ex|Date|Friend|Coworker|Family|Roommate|Stranger",
  "tone": "savage|soft|clinical", 
  "content_type": "dm|bio|story|post",
  "subject_name": "string|null",
  "message": "string", // Required for scan/comeback
  "messages": ["string"] // Required for pattern (min 2)
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "context": { /* analysis context */ },
    "headline": "string",
    "core_take": "string", 
    "tactic": { "label": "string", "confidence": number },
    "motives": "string",
    "targeting": "string",
    "power_play": "string",
    "receipts": ["string"],
    "next_moves": "string",
    "suggested_reply": { "style": "string", "text": "string" },
    "safety": { "risk_level": "string", "notes": "string" },
    "metrics": { "red_flag": number, "certainty": number, "viral_potential": number },
    "pattern": { "cycle": "string|null", "prognosis": "string|null" },
    "ambiguity": { "warning": "string|null", "missing_evidence": ["string"] }
  },
  "processing_time": number,
  "model_used": "string"
}
```

#### GET `/api/v1/health`

Health check endpoint.

#### GET `/api/v1/metrics` 

Prometheus metrics endpoint.

#### GET `/api/v1/openapi.yaml`

OpenAPI specification.

### Tab-Specific Behavior

- **scan**: 2 receipts, short replies, no pattern analysis
- **comeback**: Prioritizes suggested_reply, 2 receipts, no pattern
- **pattern**: 3-4 receipts, fills pattern.cycle & prognosis, boundary-safe replies

## Configuration

### Environment Variables

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `PORT` | No | 8080 | Server port |
| `NODE_ENV` | No | production | Environment |
| `OPENAI_API_KEY` | Yes | - | OpenAI API key |
| `DEEPSEEK_API_KEY` | Yes | - | DeepSeek API key |
| `PRIMARY_MODEL` | No | deepseek-chat | Primary model |
| `FALLBACK_MODEL` | No | gpt-4o-mini | Fallback model |
| `API_KEY` | No | - | API authentication key |
| `CORS_ORIGINS` | No | - | CORS allowed origins |
| `RATE_LIMIT_WINDOW_MS` | No | 60000 | Rate limit window |
| `RATE_LIMIT_MAX` | No | 60 | Rate limit max requests |
| `CB_FAILS` | No | 5 | Circuit breaker failure threshold |
| `CB_RESET_MS` | No | 30000 | Circuit breaker reset time |
| `SENTRY_DSN` | No | - | Sentry DSN for monitoring |

## Deployment

### Railway

1. **Connect repository** to Railway
2. **Set environment variables** in Railway dashboard
3. **Deploy** - Railway auto-detects Node.js

### Docker

```bash
docker build -t whisperfire-backend .
docker run -p 8080:8080 --env-file .env whisperfire-backend
```

## Development

### Scripts

- `npm run dev` - Development server with hot reload
- `npm run build` - TypeScript compilation
- `npm start` - Production server
- `npm test` - Run tests
- `npm run lint` - ESLint check

### Architecture

```
src/
├── server.ts          # Express app setup
├── routes/            # Route definitions
│   ├── analyze.ts     # Main analysis endpoint
│   ├── health.ts      # Health checks
│   ├── metrics.ts     # Prometheus metrics
│   ├── docs.ts        # OpenAPI spec
│   └── admin.ts       # Admin endpoints
├── controllers/       # Request handlers
│   └── analyzeController.ts
├── services/          # Business logic
│   ├── modelRouter.ts # LLM orchestration
│   ├── schema.ts      # Zod validation
│   ├── cache.ts       # LRU caching
│   ├── config.ts      # Environment config
│   └── ...
├── middleware/        # Express middleware
│   ├── auth.ts        # API key auth
│   ├── rateLimit.ts   # Rate limiting
│   ├── security.ts    # Security headers
│   └── ...
└── tests/            # Test files
```

### Testing

```bash
# Run all tests
npm test

# Run specific test
npm test -- schema.test.ts

# Development mode
npm run test:dev
```

## Security

- **API Key Authentication**: Required for all endpoints
- **Rate Limiting**: Per-key and global limits
- **CORS Protection**: Configurable origins
- **Security Headers**: Helmet.js integration
- **Input Validation**: Zod schema validation
- **JSON Parsing Guards**: Safe JSON extraction

## Monitoring

- **Health Checks**: `/api/v1/health`
- **Metrics**: Prometheus format at `/api/v1/metrics`
- **Sentry**: Error tracking (optional)
- **Circuit Breaker**: Automatic failure detection
- **Request ID**: Traceable requests

## Schema Validation

The API uses a unified Zod schema that validates:

- Required fields for each tab type
- Enum values for relationships, tones, content types
- Array lengths for receipts (2-4)
- String length limits
- Numeric ranges for confidence/risk scores

Invalid model outputs trigger fallback to secondary model.

## Error Handling

- **400**: Invalid input (missing fields, wrong types)
- **401**: Missing/invalid API key
- **429**: Rate limit exceeded
- **500**: Internal server error (model failures, etc.)

All errors return JSON with `success: false` and error message.

## Performance

- **Caching**: 5-minute LRU cache for identical requests
- **Circuit Breaker**: Prevents cascade failures
- **Retries**: Automatic retry on transient failures
- **Model Fallback**: Automatic switch on primary model failure
- **Response Time**: Typically 1-3 seconds

## Contributing

1. Fork the repository
2. Create feature branch
3. Add tests for new functionality
4. Ensure `npm run build` passes
5. Submit pull request

## License

Proprietary - All rights reserved. 