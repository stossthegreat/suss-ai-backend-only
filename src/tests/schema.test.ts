import { describe, it, expect } from 'vitest';
import { WhisperfireSchema } from '../services/schema.js';

describe('Whisperfire schema', () => {
  it('accepts minimal scan payload', () => {
    const ok = WhisperfireSchema.safeParse({
      context:{relationship:'Partner',tone:'clinical',content_type:'dm',subject_name:null,tab:'scan'},
      headline:'x', core_take:'y',
      tactic:{label:'None Detected',confidence:10},
      motives:'m',targeting:'t',power_play:'p',
      receipts:['a','b'],next_moves:'n',
      suggested_reply:{style:'clipped',text:'ok'},
      safety:{risk_level:'LOW',notes:'ok'},
      metrics:{red_flag:0,certainty:10,viral_potential:20},
      pattern:{cycle:null,prognosis:null},
      ambiguity:{warning:null,missing_evidence:[]}
    });
    expect(ok.success).toBe(true);
  });
}); 