# Stage 1: Builder
FROM node:18-alpine AS builder
WORKDIR /app

# Copy package.json dan package-lock.json
COPY package*.json ./

# Install dependencies (butuh build tools kalau ada native modules)
RUN apk add --no-cache python3 make g++ bash \
  && npm ci

# Copy seluruh source code
COPY . .

# Build Next.js
RUN npm run build

# Stage 2: Production
FROM node:18-alpine
WORKDIR /app

# Copy package.json dan node_modules dari builder
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/node_modules ./node_modules

# Copy hasil build Next.js
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public

EXPOSE 3000
CMD ["npm", "start"]
