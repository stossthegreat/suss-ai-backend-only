export class HttpError extends Error { status = 500; constructor(msg: string, status = 500){ super(msg); this.status = status; } }
export class BadRequest extends HttpError { constructor(msg='Bad Request'){ super(msg, 400);} }
export class Unauthorized extends HttpError { constructor(msg='Unauthorized'){ super(msg, 401);} }
export class TooMany extends HttpError { constructor(msg='Too Many Requests'){ super(msg, 429);} } 