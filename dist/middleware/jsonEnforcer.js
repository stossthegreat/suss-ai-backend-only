export function jsonEnforcer(_req, res, next) {
    res.type('application/json; charset=utf-8');
    next();
}
