#!/bin/bash

echo "🚀 Creating SUSS AI Backend Structure..."

# Create backend directory
mkdir -p backend
cd backend

# Create directory structure
mkdir -p src/{config,services,utils,middleware,routes,types,prompts,database}
mkdir -p src/database/migrations
mkdir -p prisma
mkdir -p logs

echo "📁 Backend directory structure created!"

# Create package.json
cat > package.json << 'EOF'
{
  "name": "suss-ai-backend",
  "version": "1.0.0",
  "description": "The most dangerous AI scanner backend ever built",
  "main": "dist/server.js",
  "scripts": {
    "dev": "nodemon src/server.ts",
    "build": "tsc",
    "start": "node dist/server.js",
    "test": "jest",
    "db:migrate": "npx prisma migrate dev",
    "db:generate": "npx prisma generate",
    "db:seed": "ts-node src/database/seed.ts",
    "db:studio": "npx prisma studio"
  },
  "dependencies": {
    "express": "^4.18.2",
    "cors": "^2.8.5",
    "helmet": "^7.1.0",
    "dotenv": "^16.3.1",
    "openai": "^4.20.1",
    "zod": "^3.22.4",
    "rate-limiter-flexible": "^3.0.8",
    "winston": "^3.11.0",
    "uuid": "^9.0.1",
    "@prisma/client": "^5.7.1",
    "bcryptjs": "^2.4.3",
    "jsonwebtoken": "^9.0.2",
    "express-rate-limit": "^7.1.5"
  },
  "devDependencies": {
    "@types/express": "^4.17.21",
    "@types/cors": "^2.8.17",
    "@types/uuid": "^9.0.7",
    "@types/bcryptjs": "^2.4.6",
    "@types/jsonwebtoken": "^9.0.5",
    "typescript": "^5.2.2",
    "nodemon": "^3.0.2",
    "ts-node": "^10.9.1",
    "jest": "^29.7.0",
    "@types/jest": "^29.5.8",
    "prisma": "^5.7.1"
  }
}
EOF

# Create tsconfig.json
cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "commonjs",
    "lib": ["ES2020"],
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true,
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist", "**/*.test.ts"]
}
EOF

# Create environment file
cat > env.example << 'EOF'
# OpenAI Configuration
OPENAI_API_KEY=your_openai_api_key_here

# Database Configuration
DATABASE_URL="postgresql://username:password@localhost:5432/suss_ai_db?schema=public"

# JWT Configuration
JWT_SECRET=your_super_secret_jwt_key_here_minimum_32_characters

# Server Configuration  
NODE_ENV=development
PORT=3000
LOG_LEVEL=info

# CORS Configuration
ALLOWED_ORIGINS=http://localhost:3000,http://localhost:8080
EOF

echo "✅ Backend structure created!"
echo "📝 Next steps:"
echo "1. cd backend"
echo "2. npm install"
echo "3. cp env.example .env"
echo "4. Edit .env with your API keys"
echo "5. Copy all the backend source files you provided"
echo "6. npm run db:generate"
echo "7. npm run db:migrate"
echo "8. npm run dev" 