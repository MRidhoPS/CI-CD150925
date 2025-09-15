# stage 1 builder
FROM node:18-alphine AS builder
Workdir /app
copy package*json.json ./
run npm install
copy . .
run npm run build

# stage 2 production
FROM node:18-alphine
WORKDIR /app
COPY --from=builder /app/package*.json ./
RUN npm install --only=production
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
EXPOSE 3000
CMD ["npm", "start"]