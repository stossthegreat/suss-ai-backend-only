import { z } from 'zod';

export const WhisperfireSchema = z.object({
  context: z.object({
    relationship: z.enum(['Partner','Ex','Date','Friend','Coworker','Family','Roommate','Stranger']),
    tone: z.enum(['savage','soft','clinical']),
    content_type: z.enum(['dm','bio','story','post']),
    subject_name: z.string().nullable(),
    tab: z.enum(['scan','comeback','pattern'])
  }),

  // Core cards (unchanged)
  headline: z.string().max(120),
  core_take: z.string().max(500),
  tactic: z.object({
    label: z.enum([
      'Gaslighting','Guilt Tripping','Deflection','DARVO','Passive Aggression',
      'Love Bombing','Breadcrumbing','Shaming','Silent Treatment','Control Test',
      'Triangulation','Emotional Baiting','Future Faking','Hoovering','None Detected'
    ]),
    confidence: z.number().min(0).max(100)
  }),
  motives: z.string().max(200),
  targeting: z.string().max(120),
  power_play: z.string().max(120),
  receipts: z.array(z.string()).min(2).max(4),
  next_moves: z.string().max(120),
  suggested_reply: z.object({
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

  // ——— NEW OPTIONAL FIELDS (for your upgraded cards) ———
  hidden_agenda: z.string().max(200).optional(),         // e.g. “Endgame: reshape your instincts…”
  archetypes: z.array(z.object({
    label: z.string().max(40),                           // e.g. "Charm-to-Chokehold"
    weight: z.number().min(0).max(100)                   // contribution %
  })).max(3).optional(),
  contradictions: z.array(z.string()).max(4).optional(), // e.g. “Says ‘I hate drama’ → creates chaos”
  weapons: z.array(z.string()).max(5).optional(),        // e.g. “Guilt Bombs”, “Mirror Baiting”
  forecast: z.array(z.object({
    window: z.string().max(40),                          // "72h", "5–7 days"
    event: z.string().max(120),                          // "Sweet outreach", "Cold withdrawal"
    likelihood: z.number().min(0).max(100)
  })).max(4).optional(),
  long_game: z.string().max(200).optional()              // “They’re methodically calibrating you…”
});

export type WhisperfireOutput = z.infer<typeof WhisperfireSchema>;
