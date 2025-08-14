export const WhisperfireSchema = z.object({
  ...,

  // New / Enforced fields for Scan tab
  profile_tag: z.string().max(120).optional(),  // 👤 Viral-style personality label
  identified_tactic: z.string().max(120).optional(), // short human-readable tactic name

  // New / Enforced fields for Comeback tab
  savage_alt: z.string().max(200).optional(), // distinct alternative comeback
  ice_cold_dismissal: z.string().max(200).optional(), // short cold closer

  // New / Enforced fields for Pattern tab
  contradiction_audit: z.array(z.string()).max(4).optional(),
  psychological_weapons_arsenal: z.array(z.string()).max(5).optional(),
  future_shock_forecast: z.array(z.object({
    window: z.string().max(40),
    event: z.string().max(120),
    likelihood: z.number().min(0).max(100)
  })).max(4).optional(),

  // Viral headline/quote per Pattern scan
  pattern_quote: z.string().max(200).optional()
});
