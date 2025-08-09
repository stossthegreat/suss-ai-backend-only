import fs from 'node:fs';
import path from 'node:path';
export function loadOpenApi() {
    const p = path.resolve(process.cwd(), 'openapi.yaml');
    return fs.readFileSync(p, 'utf8');
}
