# ---------- builder ----------
FROM node:20-alpine AS builder
WORKDIR /app

# Install ALL deps (incl. dev) so tsc exists
COPY package*.json ./
RUN npm ci

# Copy source and build
COPY . .
RUN npm run build

# ---------- runner ----------
FROM node:20-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production

# Install ONLY prod deps
COPY package*.json ./
RUN npm ci --omit=dev

# Bring in compiled JS only
COPY --from=builder /app/dist ./dist

# Expose port (matches your cfg.PORT default 3000 in Railway)
EXPOSE 3000

# Run the compiled server directly (bypasses any npm prestart hooks)
CMD ["node", "dist/server.js"]
