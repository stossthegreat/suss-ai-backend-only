import { LRUCache } from 'lru-cache';
import hash from 'object-hash';

type Key = { tab:string; relationship:string; tone:string; content_type:string; subject_name:string|null; payload:any };

const cache = new LRUCache<string, any>({
  max: 500,
  ttl: 1000 * 60 * 5 // 5 minutes
});

export function keyFor(k: Key) {
  return hash(k, { unorderedObjects: true, respectType: false });
}

export function getCached(k: Key) {
  return cache.get(keyFor(k));
}
export function setCached(k: Key, v: any) {
  cache.set(keyFor(k), v);
} 