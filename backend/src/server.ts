import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import dotenv from 'dotenv';
import { analysisRouter } from './routes/analysis';
import { logger } from './utils/logger';

// Load environment variables
dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

// 🛡️ Security middleware
app.use(helmet());
app.use(cors({
  origin: true, // Allow all origins for development
  credentials: true
}));

// 📝 Request parsing
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true }));

// 📊 Request logging
app.use((req, res, next) => {
  logger.info(`${req.method} ${req.path}`, {
    ip: req.ip,
    userAgent: req.get('User-Agent')
  });
  next();
});

// 🎯 API Routes
app.use('/api/v1', analysisRouter);

// 🏠 Root endpoint
app.get('/', (req, res) => {
  res.json({
    name: 'SUSS AI Backend',
    version: '1.0.0',
    status: 'The most dangerous AI scanner ever built 🔥',
    docs: '/api/v1/health'
  });
});

// 🚨 Error handling
app.use((error: Error, req: express.Request, res: express.Response, next: express.NextFunction) => {
  logger.error('Unhandled error:', error);
  res.status(500).json({
    success: false,
    error: 'Internal server error'
  });
});

// 🚀 Start server
app.listen(PORT, () => {
  logger.info(`🔥 SUSS AI Backend running on port ${PORT}`);
  logger.info(`🧠 OpenAI integration ready`);
  logger.info(`🎯 God prompt system loaded`);
}); 