export function errorHandler(err, _req, res, _next) {
    const status = err.status ?? 500;
    const msg = err.message ?? 'Internal Server Error';
    res.status(status).json({ success: false, error: msg });
}
