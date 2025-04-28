FROM node:20-alpine AS build
WORKDIR /workspace
COPY package*.json ./
RUN npm ci --omit=dev && npm cache clean --force
COPY . .
RUN npm run build

FROM node:20-alpine
RUN npm install -g serve
WORKDIR /app
COPY --from=build /workspace/build ./build
EXPOSE 3000
CMD ["serve", "-s", "build", "-l", "3000"]
