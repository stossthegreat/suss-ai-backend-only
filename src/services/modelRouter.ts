import OpenAI from 'openai';
import { WhisperfireSchema } from './schema.js';
import { retry } from './retry.js';
import { canCall, recordFailure, recordSuccess } from './circuitBreaker.js';
import { modelCalls } from './metrics.js';
import { flags } from './flags.js';
import { cfg } from './config.js';

const openai = new OpenAI({ apiKey: cfg.OPENAI_API_KEY });
const deepseek = new OpenAI({ 
  apiKey: cfg.DEEPSEEK_API_KEY, 
  baseURL: 'https://api.together.xyz/v1' 
});

type ChatArgs = { system: string; user: string; model: string };

async function callLLM(client: OpenAI, { system, user, model }: ChatArgs) {
  try {
    const res = await client.chat.completions.create({
      model, 
      temperature: 0.6, 
      top_p: 0.8, 
      frequency_penalty: 0.15,
      max_tokens: 2000, // Prevent excessive responses
      messages: [{ role: 'system', content: system }, { role: 'user', content: user }]
    });
    return res.choices[0]?.message?.content ?? '';
  } catch (error: any) {
    throw new Error(`LLM call failed: ${error?.message ?? 'Unknown error'}`);
  }
}

function safeJSON(str: string) {
  if (!str || typeof str !== 'string') return null;
  
  // Try to extract JSON from markdown code blocks
  const jsonMatch = str.match(/```(?:json)?\s*(\{[\s\S]*?\})\s*```/);
  if (jsonMatch) {
    try {
      return JSON.parse(jsonMatch[1]);
    } catch {
      // Fall through to direct parsing
    }
  }
  
  // Try direct JSON parsing
  try { 
    return JSON.parse(str); 
  } catch { 
    return null; 
  }
}

export async function generateWhisperfire(system: string, user: string, tab?: string) {
  if (!canCall()) throw new Error('Circuit open: upstream unstable');

  const tryModel = async (client: OpenAI, model: string, label: string) => {
    const raw = await retry(() => callLLM(client, { system, user, model }), 1, 200);
    const json = safeJSON(raw);
    
    if (!json) {
      modelCalls.inc({ model: label, result: 'no_json' });
      throw new Error(`${label} returned invalid JSON format`);
    }
    
    const parsed = WhisperfireSchema.safeParse(json);
    const ok = parsed.success;
    
    modelCalls.inc({ model: label, result: ok ? 'ok' : 'bad_schema' });
    
    if (!ok) {
      throw new Error(`${label} schema validation failed: ${parsed.error?.message ?? 'Unknown error'}`);
    }
    
    return parsed.data;
  };

  const forceGPT = tab && flags.forceGPTFor(tab);
  
  try {
    const primary = forceGPT 
      ? await tryModel(openai, cfg.FALLBACK_MODEL, 'gpt4')
      : await tryModel(deepseek, cfg.PRIMARY_MODEL, 'deepseek');
    recordSuccess(); 
    return primary;
  } catch (primaryError) {
    try {
      const fallback = forceGPT 
        ? await tryModel(deepseek, cfg.PRIMARY_MODEL, 'deepseek')
        : await tryModel(openai, cfg.FALLBACK_MODEL, 'gpt4');
      recordSuccess(); 
      return fallback;
    } catch (fallbackError) {
      recordFailure(); 
      const primaryMsg = primaryError instanceof Error ? primaryError.message : 'Unknown error';
      const fallbackMsg = fallbackError instanceof Error ? fallbackError.message : 'Unknown error';
      throw new Error(`All models failed. Primary: ${primaryMsg}, Fallback: ${fallbackMsg}`);
    }
  }
} 