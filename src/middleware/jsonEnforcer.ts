import type { Request, Response, NextFunction } from 'express';
export function jsonEnforcer(_req: Request, res: Response, next: NextFunction) {
  res.type('application/json; charset=utf-8'); next();
} 