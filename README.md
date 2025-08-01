# SUSS AI Backend - Railway Deployment

## 🚀 Quick Deploy to Railway

1. **Fork/Clone this repo**
2. **Go to [Railway.app](https://railway.app)**
3. **Create new project → Deploy from GitHub repo**
4. **Add environment variables:**
   - `OPENAI_API_KEY` = Your OpenAI API key
   - `NODE_ENV` = production
   - `PORT` = 3000

## 🔧 Environment Variables

```env
OPENAI_API_KEY=sk-proj-your-key-here
NODE_ENV=production
PORT=3000
LOG_LEVEL=info
```

## 📡 API Endpoints

- `GET /api/v1/health` - Health check
- `POST /api/v1/analyze` - Analyze message

## 🎯 Usage

```bash
curl -X POST https://your-railway-url.railway.app/api/v1/analyze \
  -H "Content-Type: application/json" \
  -d '{
    "input_text": "Sorry, just saw this now. Been super busy lately...",
    "content_type": "dm",
    "analysis_goal": "lie_detection",
    "tone": "brutal",
    "comeback_enabled": true
  }'
```

## 🏗️ Build Process

1. `npm ci` - Install dependencies
2. `npm run build` - Compile TypeScript
3. `npm start` - Start production server

## 🔥 Features

- ✅ OpenAI GPT-4 Integration
- ✅ Smart Model Routing
- ✅ Real-time Analysis
- ✅ CORS Enabled
- ✅ Health Checks
- ✅ Production Ready 