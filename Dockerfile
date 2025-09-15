# stage 1 builder
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*json.json ./
RUN npm install
COPY . .
RUN npm run build

# stage 2 production
FROM node:18-alpine
WORKDIR /app
COPY --from=builder /app/package*.json ./
RUN npm install --only=production
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
EXPOSE 3000
CMD ["npm", "start"]