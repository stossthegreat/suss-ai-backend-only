# ---------- build stage ----------
FROM node:20-alpine AS build
WORKDIR /app

# Install prod deps (no dev) for smaller image
COPY package*.json ./
RUN npm ci --omit=dev

# Compile TypeScript -> dist/
COPY . .
RUN npm run build

# ---------- runtime stage ----------
FROM node:20-alpine AS runtime
WORKDIR /app
ENV NODE_ENV=production

# Install only prod deps again in a clean layer
COPY package*.json ./
RUN npm ci --omit=dev --ignore-scripts

# Bring in build artifacts & any non-TS assets you serve
COPY --from=build /app/dist ./dist
COPY --from=build /app/openapi.yaml ./openapi.yaml

# Railway sets PORT; our server reads cfg.PORT, default 8080
EXPOSE 8080

# IMPORTANT: start the server (runs "prestart" then "start")
CMD ["npm","start"]
