# syntax=docker/dockerfile:1

########### Builder ###########
FROM node:20-alpine AS builder
WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

########### Runner ###########
FROM node:20-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production

# prod deps only
COPY package*.json ./
RUN npm ci --omit=dev

# compiled JS + optional spec
COPY --from=builder /app/dist ./dist
# If you actually have openapi.yaml in repo root, this works. If you don't, delete this next line.
COPY --from=builder /app/openapi.yaml ./openapi.yaml

EXPOSE 3000
CMD ["node", "dist/server.js"]

