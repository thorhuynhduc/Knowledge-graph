# ===================================================================
#  Knowledge Graph — Node.js app image
# ===================================================================
FROM node:20-alpine

WORKDIR /app

# Cài dependencies trước (tận dụng cache layer)
COPY package.json ./
RUN npm install --omit=dev

# Copy source
COPY . .

ENV NODE_ENV=production
ENV PORT=3000
EXPOSE 3000

CMD ["node", "server.js"]
