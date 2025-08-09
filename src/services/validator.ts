import { WhisperfireSchema } from './schema.js';
export const validatePayload = (payload: unknown) => WhisperfireSchema.parse(payload); 