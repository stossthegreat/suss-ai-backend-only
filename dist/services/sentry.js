import * as Sentry from '@sentry/node';
import { cfg } from './config.js';
export function initSentry() {
    if (!cfg.SENTRY_DSN)
        return;
    Sentry.init({
        dsn: cfg.SENTRY_DSN,
        tracesSampleRate: 0.1
    });
}
export { Sentry };
