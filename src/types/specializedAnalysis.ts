export type Relationship =
  | 'Partner' | 'Ex' | 'Date' | 'Friend' | 'Coworker' | 'Family' | 'Roommate' | 'Stranger';
export type Tone = 'savage' | 'soft' | 'clinical';
export type ContentType = 'dm' | 'bio' | 'story' | 'post';
export type Tab = 'scan' | 'comeback' | 'pattern';

export interface WhisperfireResponse {
  context: {
    relationship: Relationship;
    tone: Tone;
    content_type: ContentType;
    subject_name: string | null;
    tab: Tab;
  };
  headline: string;
  core_take: string;
  tactic: { 
    label: 'Gaslighting'|'Guilt Tripping'|'Deflection'|'DARVO'|'Passive Aggression'|
    'Love Bombing'|'Breadcrumbing'|'Shaming'|'Silent Treatment'|'Control Test'|
    'Triangulation'|'Emotional Baiting'|'Future Faking'|'Hoovering'|'None Detected';
    confidence: number;
  };
  motives: string;
  targeting: string;
  power_play: string;
  receipts: string[];
  next_moves: string;
  suggested_reply: { 
    style: 'clipped'|'one_liner'|'reverse_uno'|'screenshot_bait'|'monologue'; 
    text: string; 
  };
  safety: { 
    risk_level: 'LOW'|'MODERATE'|'HIGH'|'CRITICAL'; 
    notes: string; 
  };
  metrics: { 
    red_flag: number; 
    certainty: number; 
    viral_potential: number; 
  };
  pattern: { 
    cycle: string | null; 
    prognosis: string | null; 
  };
  ambiguity: { 
    warning: string | null; 
    missing_evidence?: string[]; 
  };
} 