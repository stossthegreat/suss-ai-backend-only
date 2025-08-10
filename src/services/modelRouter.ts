import OpenAI from 'openai';
import { WhisperfireSchema } from './schema.js';
import { retry } from './retry.js';
import { canCall, recordFailure } from './circuitBreaker.js';
import { modelCalls } from './metrics.js';
import { flags } from './flags.js';
import { cfg } from './config.js';

// Clients (OpenAI + Together/OpenAI-compatible)
if (!cfg.OPENAI_API_KEY) {
  console.warn('⚠️  OpenAI client will not be available - OPENAI_API_KEY is missing');
}
if (!cfg.TOGETHER_API_KEY && !cfg.DEEPSEEK_API_KEY) {
  console.warn('⚠️  DeepSeek/Together client will not be available - set TOGETHER_API_KEY (or legacy DEEPSEEK_API_KEY)');
}

const openai = cfg.OPENAI_API_KEY ? new OpenAI({ apiKey: cfg.OPENAI_API_KEY }) : null;
const togetherKey = cfg.TOGETHER_API_KEY || cfg.DEEPSEEK_API_KEY || '';
const deepseek = togetherKey
  ? new OpenAI({ apiKey: togetherKey, baseURL: 'https://api.together.ai/v1' })
  : null;

type ChatArgs = { system: string; user: string; model: string };

async function callLLM(client: OpenAI, { system, user, model }: ChatArgs) {
  try {
    const res = await client.chat.completions.create({
      model,
      response_format: { type: 'json_object' }, // force pure JSON
      temperature: 0.2,
      top_p: 1,
      max_tokens: 1800,
      messages: [
        { role: 'system', content: system },
        { role: 'user', content: user }
      ]
    });
    return res.choices[0]?.message?.content ?? '';
  } catch (error: any) {
    throw new Error(`LLM call failed: ${error?.message ?? 'Unknown error'}`);
  }
}

function safeJSON(str: string) {
  if (!str || typeof str !== 'string') return null;
  const trimmed = str.trim();
  if (trimmed.startsWith('{') && trimmed.endsWith('}')) {
    try { return JSON.parse(trimmed); } catch {}
  }
  const jsonMatch = str.match(/```(?:json)?\s*(\{[\s\S]*?\})\s*```/);
  if (jsonMatch) {
    try { return JSON.parse(jsonMatch[1]); } catch {}
  }
  try { return JSON.parse(str); } catch { return null; }
}

// Extract context from the user prompt (supports both old "TAB:" lines and new "CONTEXT: {...}")
function extractContextFromUser(user: string) {
  try {
    const m = user.match(/CONTEXT:\s*(\{[\s\S]*?\})/);
    if (m) {
      const ctx = JSON.parse(m[1]);
      return {
        tab: ctx.tab ?? 'scan',
        relationship: ctx.relationship ?? 'Partner',
        tone: ctx.tone ?? 'clinical',
        content_type: ctx.content_type ?? 'dm',
        subject_name: ctx.subject_name ?? null
      };
    }
  } catch {}
  // Fallback: parse legacy header lines
  const pick = (label: string, def: string|null) => {
    const re = new RegExp(`^${label}:\\s*(.+)$`, 'mi');
    const mm = user.match(re);
    return (mm?.[1] ?? def) as any;
  };
  return {
    tab: pick('TAB', 'scan'),
    relationship: pick('RELATIONSHIP', 'Partner'),
    tone: pick('TONE', 'clinical'),
    content_type: pick('CONTENT_TYPE', 'dm'),
    subject_name: pick('SUBJECT_NAME', null) === 'null' ? null : pick('SUBJECT_NAME', null)
  };
}

// Map/normalize all drift to strict schema before validating
function normalize(json: any, expectedCtx: any) {
  const upper = (s?: string) => (s || '').toUpperCase();
  const clamp01 = (n: any) => {
    const v = typeof n === 'boolean' ? (n ? 1 : 0) : Number(n ?? 0);
    return Math.max(0, Math.min(1, isFinite(v) ? v : 0));
  };
  const arr = (v: any) => v == null ? [] : Array.isArray(v) ? v : [v];

  const allowed = [
    'Gaslighting','Guilt Tripping','Deflection','DARVO','Passive Aggression',
    'Love Bombing','Breadcrumbing','Shaming','Silent Treatment','Control Test',
    'Triangulation','Emotional Baiting','Future Faking','Hoovering','None Detected'
  ];
  const map: Record<string,string> = {
    'appeasement':'None Detected',
    'accountability':'None Detected',
    'apology':'None Detected',
    'apology and reconciliation':'None Detected',
    'stonewalling':'Silent Treatment',
    'withholding':'Silent Treatment',
    'threat':'Emotional Baiting'
  };
  const labelIn = String(json?.tactic?.label || '').toLowerCase();
  const mappedLabel = allowed.includes(json?.tactic?.label)
    ? json?.tactic?.label
    : (map[labelIn] || 'None Detected');

  // receipts: ensure 2..4
  let receipts = arr(json?.receipts).map(String).filter(Boolean);
  if (receipts.length < 2) {
    const hints = [String(json?.headline || ''), String(json?.core_take || '')].filter(Boolean);
    for (const h of hints) { if (receipts.length < 2 && h) receipts.push(h.slice(0,120)); }
  }
  receipts = receipts.slice(0, 4);

  return {
    context: typeof json?.context === 'object'
      ? {
          relationship: json.context.relationship ?? expectedCtx.relationship,
          tone: json.context.tone ?? expectedCtx.tone,
          content_type: json.context.content_type ?? expectedCtx.content_type,
          subject_name: json.context.subject_name ?? expectedCtx.subject_name,
          tab: json.context.tab ?? expectedCtx.tab
        }
      : expectedCtx,
    headline: String(json?.headline ?? '').slice(0,120),
    core_take: String(json?.core_take ?? '').slice(0,500),
    tactic: { label: mappedLabel, confidence: Math.round(clamp01(json?.tactic?.confidence)*100) },
    motives: Array.isArray(json?.motives) ? json.motives.join('; ').slice(0,200) : String(json?.motives ?? '').slice(0,200),
    targeting: Array.isArray(json?.targeting) ? json.targeting.join('; ').slice(0,120) : String(json?.targeting ?? '').slice(0,120),
    power_play: String(json?.power_play ?? '').slice(0,120),
    receipts,
    next_moves: Array.isArray(json?.next_moves) ? json.next_moves.join(' · ').slice(0,120) : String(json?.next_moves ?? '').slice(0,120),
    suggested_reply: {
      style: (json?.suggested_reply?.style ?? 'clipped'),
      text: String(json?.suggested_reply?.text ?? '').slice(0,300)
    },
    safety: {
      risk_level: ['LOW','MODERATE','HIGH','CRITICAL'].includes(upper(json?.safety?.risk_level))
        ? upper(json?.safety?.risk_level)
        : 'LOW',
      notes: String(json?.safety?.notes ?? '').slice(0,200)
    },
    metrics: {
      red_flag: Math.round(clamp01(json?.metrics?.red_flag)*100),
      certainty: Math.round(clamp01(json?.metrics?.certainty ?? 0.6)*100),
      viral_potential: Math.round(clamp01(json?.metrics?.viral_potential)*100)
    },
    pattern: {
      cycle: json?.pattern?.cycle == null ? null : String(json?.pattern?.cycle).slice(0,200),
      prognosis: json?.pattern?.prognosis == null ? null : String(json?.pattern?.prognosis).slice(0,200)
    },
    ambiguity: {
      warning: json?.ambiguity?.warning == null ? null : String(json?.ambiguity?.warning).slice(0,200),
      missing_evidence: arr(json?.ambiguity?.missing_evidence).map(String)
    }
  };
}

export async function generateWhisperfire(system: string, user: string, tab?: string) {
  if (!canCall()) throw new Error('Circuit open: upstream unstable');

  if (!openai && !deepseek) {
    throw new Error('No API keys configured. Set OPENAI_API_KEY and/or TOGETHER_API_KEY (or DEEPSEEK_API_KEY).');
  }

  const expectedCtx = extractContextFromUser(user);

  const tryModel = async (client: OpenAI, model: string, label: string) => {
    const raw = await retry(() => callLLM(client, { system, user, model }), 1, 200);
    const json = safeJSON(raw);
    if (!json) {
      modelCalls.inc({ model: label, result: 'no_json' });
      throw new Error(`${label} returned invalid JSON format`);
    }

    const coerced = normalize(json, expectedCtx);
    const parsed = WhisperfireSchema.safeParse(coerced);
    const ok = parsed.success;

    modelCalls.inc({ model: label, result: ok ? 'ok' : 'bad_schema' });
    if (!ok) {
      throw new Error(`${label} schema validation failed: ${parsed.error?.message ?? 'Unknown error'}`);
    }
    return parsed.data;
  };

  const forceGPT = tab && flags.forceGPTFor(tab);

  try {
    if (forceGPT && openai) {
      return await tryModel(openai, cfg.FALLBACK_MODEL, 'gpt4');
    } else if (!forceGPT && deepseek) {
      return await tryModel(deepseek, cfg.PRIMARY_MODEL, 'deepseek');
    }

    if (forceGPT && deepseek) {
      return await tryModel(deepseek, cfg.PRIMARY_MODEL, 'deepseek');
    } else if (!forceGPT && openai) {
      return await tryModel(openai, cfg.FALLBACK_MODEL, 'gpt4');
    }

    throw new Error('No available models for the requested configuration');
  } catch (primaryError) {
    try {
      if (forceGPT && deepseek) {
        return await tryModel(deepseek, cfg.PRIMARY_MODEL, 'deepseek');
      } else if (!forceGPT && openai) {
        return await tryModel(openai, cfg.FALLBACK_MODEL, 'gpt4');
      }
      throw new Error('No fallback models available');
    } catch (fallbackError) {
      recordFailure();
      const primaryMsg = primaryError instanceof Error ? primaryError.message : 'Unknown error';
      const fallbackMsg = fallbackError instanceof Error ? fallbackError.message : 'Unknown error';
      throw new Error(`All models failed. Primary: ${primaryMsg}, Fallback: ${fallbackMsg}`);
    }
  }
                   }
