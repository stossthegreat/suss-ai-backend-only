import type { Request, Response, NextFunction } from 'express';
import { cfg } from '../services/config.js';

export function requireApiKey(req: Request, res: Response, next: NextFunction) {
  if (!cfg.API_KEY) return next(); // open if not configured
  const header = req.get('authorization') || '';
  const token = header.startsWith('Bearer ') ? header.slice(7) : null;
  if (token && token === cfg.API_KEY) return next();
  return res.status(401).json({ success: false, error: 'Unauthorized' });
} 