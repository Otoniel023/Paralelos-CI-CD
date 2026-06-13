FROM node:20-alpine

RUN addgroup -g 1001 -S nodejs \
    && adduser -S appuser -u 1001 -G nodejs

WORKDIR /app

COPY package*.json ./

RUN npm ci --only=production

COPY --chown=appuser:nodejs . .

USER appuser

EXPOSE 8080

ENV PORT=8080
ENV NODE_ENV=production

CMD ["node", "src/index.js"]