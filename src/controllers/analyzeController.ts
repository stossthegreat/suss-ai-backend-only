import type { Request, Response } from 'express';
import { generateWhisperfire } from '../services/modelRouter.js';
import { SYSTEM_PROMPT, buildUserPrompt } from '../services/promptBuilder.js';
import { getCached, setCached } from '../services/cache.js';
import { cfg } from '../services/config.js';
import { log } from '../services/logger.js';
import { WhisperfireSchema } from '../services/schema.js';

// Input validation schema
const AnalyzeInputSchema = {
  scan: {
    required: ['tab', 'relationship', 'tone', 'content_type', 'message'],
    optional: ['subject_name']
  },
  comeback: {
    required: ['tab', 'relationship', 'tone', 'content_type', 'message'],
    optional: ['subject_name']
  },
  pattern: {
    required: ['tab', 'relationship', 'tone', 'content_type', 'messages'],
    optional: ['subject_name']
  }
} as const;

export async function analyze(req: Request, res: Response) {
  const { tab, relationship, tone, content_type, subject_name, message, messages } = req.body ?? {};
  
  // Enhanced input validation
  if (!tab || !relationship || !tone || !content_type) {
    return res.status(400).json({ 
      success: false, 
      error: 'Missing required fields: tab, relationship, tone, content_type' 
    });
  }

  if (!['scan', 'comeback', 'pattern'].includes(tab)) {
    return res.status(400).json({ 
      success: false, 
      error: 'Invalid tab: must be scan, comeback, or pattern' 
    });
  }

  const tabConfig = AnalyzeInputSchema[tab as keyof typeof AnalyzeInputSchema];
  
  // Validate tab-specific requirements
  if (tab === 'pattern') {
    if (!Array.isArray(messages) || messages.length < 2) {
      return res.status(400).json({ 
        success: false, 
        error: 'Pattern tab requires messages array with at least 2 messages' 
      });
    }
  } else {
    if (typeof message !== 'string' || !message.trim()) {
      return res.status(400).json({ 
        success: false, 
        error: 'Scan/comeback tabs require non-empty message string' 
      });
    }
  }

  // Validate relationship and tone enums
  const validRelationships = ['Partner', 'Ex', 'Date', 'Friend', 'Coworker', 'Family', 'Roommate', 'Stranger'];
  const validTones = ['savage', 'soft', 'clinical'];
  const validContentTypes = ['dm', 'bio', 'story', 'post'];

  if (!validRelationships.includes(relationship)) {
    return res.status(400).json({ 
      success: false, 
      error: `Invalid relationship: must be one of ${validRelationships.join(', ')}` 
    });
  }

  if (!validTones.includes(tone)) {
    return res.status(400).json({ 
      success: false, 
      error: `Invalid tone: must be one of ${validTones.join(', ')}` 
    });
  }

  if (!validContentTypes.includes(content_type)) {
    return res.status(400).json({ 
      success: false, 
      error: `Invalid content_type: must be one of ${validContentTypes.join(', ')}` 
    });
  }

  const cacheKey = {
    tab, relationship, tone, content_type, subject_name: subject_name ?? null,
    payload: tab === 'pattern' ? messages : message
  };

  const cached = getCached(cacheKey);
  if (cached) {
    return res.json({
      success: true,
      data: cached,
      processing_time: 0,
      model_used: 'cache'
    });
  }

  const userPrompt = buildUserPrompt(
    tab, relationship, tone, content_type, subject_name ?? null,
    tab === 'pattern' ? { messages } : { message }
  );

  try {
    const t0 = Date.now();
    const data = await generateWhisperfire(SYSTEM_PROMPT, userPrompt, tab);
    const ms = Date.now() - t0;
    
    // Validate model output against schema
    const validation = WhisperfireSchema.safeParse(data);
    if (!validation.success) {
      log('fail', 'Schema validation failed', validation.error);
      return res.status(500).json({ 
        success: false, 
        error: 'Model returned invalid response format' 
      });
    }
    
    log('ok', tab, relationship, tone, `${ms}ms`);
    
    setCached(cacheKey, validation.data);
    res.json({
      success: true,
      data: validation.data,
      processing_time: ms,
      model_used: cfg.PRIMARY_MODEL
    });
  } catch (e: any) {
    log('fail', e?.message);
    res.status(500).json({ 
      success: false, 
      error: e?.message ?? 'Generation failed' 
    });
  }
} 