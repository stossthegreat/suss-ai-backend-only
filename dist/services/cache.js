import { LRUCache } from 'lru-cache';
import hash from 'object-hash';
const cache = new LRUCache({
    max: 500,
    ttl: 1000 * 60 * 5 // 5 minutes
});
export function keyFor(k) {
    return hash(k, { unorderedObjects: true, respectType: false });
}
export function getCached(k) {
    return cache.get(keyFor(k));
}
export function setCached(k, v) {
    cache.set(keyFor(k), v);
}
