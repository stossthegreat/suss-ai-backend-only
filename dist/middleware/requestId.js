import { randomUUID } from 'node:crypto';
export function requestId(req, res, next) {
    const id = req.get('X-Request-Id') || randomUUID();
    req.reqId = id;
    res.set('X-Request-Id', id);
    next();
}
