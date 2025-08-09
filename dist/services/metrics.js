import client from 'prom-client';
export const registry = new client.Registry();
client.collectDefaultMetrics({ register: registry });
export const httpDuration = new client.Histogram({
    name: 'http_request_duration_ms',
    help: 'HTTP latency',
    labelNames: ['route', 'method', 'status'],
    buckets: [50, 100, 200, 400, 800, 1600, 3200]
});
registry.registerMetric(httpDuration);
export const modelCalls = new client.Counter({
    name: 'model_calls_total',
    help: 'LLM calls',
    labelNames: ['model', 'result']
});
registry.registerMetric(modelCalls);
