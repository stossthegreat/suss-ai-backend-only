FROM node:18-alpine

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install ALL dependencies (including dev dependencies for build)
RUN npm ci

# Copy source code
COPY . .

# Build TypeScript
RUN npm run build

# Remove dev dependencies for production
RUN npm ci --only=production

# Expose port
EXPOSE 3000

# Start the app
CMD ["npm", "start"] 