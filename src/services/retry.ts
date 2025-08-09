export async function retry<T>(fn: () => Promise<T>, attempts = 2, baseMs = 200) {
  let err: any;
  for (let i = 0; i <= attempts; i++) {
    try { return await fn(); } catch (e) {
      err = e; await new Promise(r => setTimeout(r, baseMs * (i + 1)));
    }
  }
  throw err;
} 