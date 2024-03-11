FROM node:17-slim AS builder
WORKDIR /app
COPY package*.json ./
RUN apt-get update || : && apt-get install python3 -y
RUN apt-get install build-essential -y
RUN npm install --only=development
COPY . .
RUN npm run build api
#---------------------------------------------------------------------------

FROM node:17-alpine
WORKDIR /app
COPY --from=builder /app/package*.json .
RUN apk add python3
RUN apk add build-base
RUN npm install --only=production
COPY --from=builder /app/dist ./dist
EXPOSE 8080
CMD ["node", "dist/apps/api/src/main"]
