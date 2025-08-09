import type { Request, Response, NextFunction } from 'express';
import { randomUUID } from 'node:crypto';

export function requestId(req: Request, res: Response, next: NextFunction) {
  const id = req.get('X-Request-Id') || randomUUID();
  (req as any).reqId = id;
  res.set('X-Request-Id', id);
  next();
} 