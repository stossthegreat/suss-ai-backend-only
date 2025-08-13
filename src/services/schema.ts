import { z } from 'zod';

export const WhisperfireSchema = z.object({
  context: z.object({
    relationship: z.enum(['Partner','Ex','Date','Friend','Coworker','Family','Roommate','Stranger']),
    tone: z.enum(['savage','soft','clinical']),
    content_type: z.enum(['dm','bio','story','post']),
    subject_name: z.string().nullable(),
    tab: z.enum(['scan','comeback','pattern'])
  }),

  // Core fields (used across tabs)
  headline: z.string().max(120),
  core_take: z.string().max(500),  // "The Read" or Hidden Agenda Scan
  tactic: z.object({
    label: z.enum([
      'Gaslighting','Guilt Tripping','Deflection','DARVO','Passive Aggression',
      'Love Bombing','Breadcrumbing','Shaming','Silent Treatment','Control Test',
      'Triangulation','Emotional Baiting','Future Faking','Hoovering','None Detected'
    ]),
    confidence: z.number().min(0).max(100)
  }),
  motives: z.string().max(200),          // Long Game Warning / endgame
  targeting: z.string().max(120),
  power_play: z.string().max(120),
  receipts: z.array(z.string()).min(2).max(4),
  next_moves: z.string().max(120),

  suggested_reply: z.object({
    // NOTE: comeback requires multi-line text (Roast / Savage Alt / Ice-Cold)
    style: z.enum(['clipped','one_liner','reverse_uno','screenshot_bait','monologue']),
    text: z.string().max(300)
  }),

  safety: z.object({
    risk_level: z.enum(['LOW','MODERATE','HIGH','CRITICAL']),
    notes: z.string().max(200)
  }),

  metrics: z.object({
    red_flag: z.number().min(0).max(100),
    certainty: z.number().min(0).max(100),
    viral_potential: z.number().min(0).max(100)
  }),

  pattern: z.object({
    cycle: z.string().max(200).nullable(),
    prognosis: z.string().max(200).nullable()
  }),

  ambiguity: z.object({
    warning: z.string().max(200).nullable(),
    missing_evidence: z.array(z.string()).optional()
  }),

  // ——— Pattern God‑Mode (OPTIONAL enrichers for your new cards) ———
  hidden_agenda: z.string().max(200).optional(),
  archetypes: z.array(z.object({
    label: z.string().max(40),
    weight: z.number().min(0).max(100)
  })).max(3).optional(),
  trigger_pattern_map: z.string().max(200).optional(),
  contradictions: z.array(z.string()).max(4).optional(),
  weapons: z.array(z.string()).max(5).optional(),
  forecast: z.array(z.object({
    window: z.string().max(40),
    event: z.string().max(120),
    likelihood: z.number().min(0).max(100)
  })).max(4).optional(),
  counter_intervention: z.string().max(200).optional(),
  long_game: z.string().max(200).optional()
});

export type WhisperfireOutput = z.infer<typeof WhisperfireSchema>;
