"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const cors_1 = __importDefault(require("cors"));
const helmet_1 = __importDefault(require("helmet"));
const dotenv_1 = __importDefault(require("dotenv"));
const analysis_1 = require("./routes/analysis");
const logger_1 = require("./utils/logger");
// Load environment variables
dotenv_1.default.config();
const app = (0, express_1.default)();
const PORT = process.env.PORT || 3000;
// 🛡️ Security middleware
app.use((0, helmet_1.default)());
app.use((0, cors_1.default)({
    origin: true, // Allow all origins for development
    credentials: true
}));
// 📝 Request parsing
app.use(express_1.default.json({ limit: '10mb' }));
app.use(express_1.default.urlencoded({ extended: true }));
// 📊 Request logging
app.use((req, res, next) => {
    logger_1.logger.info(`${req.method} ${req.path}`, {
        ip: req.ip,
        userAgent: req.get('User-Agent')
    });
    next();
});
// 🎯 API Routes
app.use('/api/v1', analysis_1.analysisRouter);
// 🏠 Root endpoint
app.get('/', (req, res) => {
    res.json({
        name: 'SUSS AI Backend',
        version: '2.0.0',
        status: 'WHISPERFIRE: The most dangerous AI scanner ever built 🔥',
        systems: {
            legacy: 'active',
            whisperfire: 'active'
        },
        docs: '/api/v1/health',
        features: {
            instant_scan: 'WHISPERFIRE psychological radar',
            comeback_generation: 'COMEBACK.GPT viral weapon',
            pattern_profiling: 'PATTERN.AI behavioral profiler'
        }
    });
});
// 🚨 Error handling
app.use((error, req, res, next) => {
    logger_1.logger.error('Unhandled error:', error);
    res.status(500).json({
        success: false,
        error: 'Internal server error'
    });
});
// 🚀 Start server
app.listen(PORT, () => {
    logger_1.logger.info(`🔥 SUSS AI Backend running on port ${PORT}`);
    logger_1.logger.info(`🧠 OpenAI integration ready`);
    logger_1.logger.info(`🎯 Legacy God prompt system loaded`);
    logger_1.logger.info(`🚀 WHISPERFIRE system active`);
    logger_1.logger.info(`🗡️ COMEBACK.GPT viral weapon ready`);
    logger_1.logger.info(`🧠 PATTERN.AI behavioral profiler active`);
});
//# sourceMappingURL=server.js.map