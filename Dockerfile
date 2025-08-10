# syntax=docker/dockerfile:1

########### Builder: install dev deps and compile TS ###########
FROM node:20-alpine AS builder
WORKDIR /app

# Only package files first for better caching
COPY package*.json ./
RUN npm ci

# Copy the rest and build
COPY . .
RUN npm run build

########### Runner: prod deps only + compiled JS ###########
FROM node:20-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production

# Prod deps only for small runtime
COPY package*.json ./
RUN npm ci --omit=dev

# Bring compiled JS from builder
COPY --from=builder /app/dist ./dist

# If your app reads openapi.yaml or other runtime assets from CWD, copy them:
# (ignore if not present)
COPY openapi.yaml ./  || true

# Railway injects PORT; your server already reads cfg.PORT
EXPOSE 3000
CMD ["node", "dist/server.js"]
