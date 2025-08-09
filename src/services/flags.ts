export const flags = { forceGPTFor: (tab: string) => process.env[`FLAG_FORCE_GPT_${tab?.toUpperCase()}`] === "1" };
