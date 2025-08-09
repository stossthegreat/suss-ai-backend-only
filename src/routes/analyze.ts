import { Router } from 'express';
import { analyze } from '../controllers/analyzeController.js';

const router = Router();
router.post('/analyze', analyze);
export default router; 