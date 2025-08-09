import { Router } from 'express';
import { loadOpenApi } from '../services/openapi.js';

const router = Router();
router.get('/openapi.yaml', (_req, res) => {
  res.type('text/yaml').send(loadOpenApi());
});
export default router; 