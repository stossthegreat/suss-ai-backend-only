import { cfg } from './config.js';

type State = 'closed'|'open'|'half';
const THRESH = cfg.CB_FAILS;
const RESET_MS = cfg.CB_RESET_MS;

let failures = 0;
let state: State = 'closed';
let openedAt = 0;

export function canCall(): boolean {
  if (state === 'open') {
    if (Date.now() - openedAt > RESET_MS) { state = 'half'; return true; }
    return false;
  }
  return true;
}

export function recordSuccess() { failures = 0; state = 'closed'; }
export function recordFailure() {
  failures++;
  if (failures >= THRESH) { state = 'open'; openedAt = Date.now(); }
}
export function breakerState() { return { state, failures }; } 