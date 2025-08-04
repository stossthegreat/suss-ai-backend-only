import express from 'express';
import cors from 'cors';
import { PatternController } from './controllers/patternController';

const app = express();
const PORT = process.env['PORT'] || 3000;

// Middleware
app.use(cors());
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true }));

// Routes
app.post('/api/v1/analyze', PatternController.analyzePattern);
app.get('/api/v1/health', PatternController.healthCheck);

// Error handling middleware
app.use((error: any, _req: express.Request, res: express.Response, _next: express.NextFunction) => {
  console.error('❌ Server error:', error);
  res.status(500).json({
    error: 'Internal server error',
    message: error.message || 'Something went wrong'
  });
});

// Start server
app.listen(PORT, () => {
  console.log(`🚀 Legendary Pattern Intelligence Server running on port ${PORT}`);
  console.log(`🧠 Pattern.AI - Behavioral Intelligence System`);
  console.log(`📊 Health check: http://localhost:${PORT}/api/v1/health`);
  console.log(`🔍 Pattern analysis: POST http://localhost:${PORT}/api/v1/analyze`);
});

export default app; 