// 🧠 LEGACY SCHEMA (for backward compatibility)
const legacyAnalysisRequestSchema = z.object({
  input_text: z.union([z.string(), z.array(z.string())]),
  content_type: z.enum(['dm', 'bio', 'story', 'post']),
  analysis_goal: z.enum(['subtext_scan', 'lie_detection', 'pattern_analysis']),
  tone: z.enum(['brutal', 'soft', 'clinical', 'playful', 'petty', 'mature']),
  comeback_enabled: z.boolean(),
  relationship: z.string().optional(),
  // 🔧 MAKE THESE OPTIONAL FOR BACKWARD COMPATIBILITY
  person_name: z.string().optional().nullable(),
  style_preference: z.enum(['clipped', 'one_liner', 'reverse_uno', 'screenshot_bait', 'monologue']).optional().nullable(),
}); 