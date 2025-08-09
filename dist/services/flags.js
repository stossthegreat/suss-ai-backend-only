export const flags = { forceGPTFor: (tab) => process.env[`FLAG_FORCE_GPT_${tab?.toUpperCase()}`] === "1" };
