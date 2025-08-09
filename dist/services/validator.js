import { WhisperfireSchema } from './schema.js';
export const validatePayload = (payload) => WhisperfireSchema.parse(payload);
