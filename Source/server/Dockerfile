# ========================
# Build Stage
# ========================
FROM node:25.0.0-slim AS build
WORKDIR /app

COPY server ./server
COPY proto ./proto

# Install dependencies
WORKDIR /app/server
RUN npm ci
RUN npm run build

# ========================
# Runtime Stage
# ========================
FROM node:25.0.0-slim
WORKDIR /app

# Environment setup
RUN mkdir /runtimeconfig
ENV NODE_ENV=/runtimeconfig/.env.docker

# Copy built artifacts and proto files from build stage
COPY --from=build /app/server/dist ./dist
COPY --from=build /app/server/node_modules ./node_modules
COPY --from=build /app/proto ./proto
COPY --from=build /app/server/package*.json ./

# UNCOMMENT FOR LOCAL TESTING
COPY server/.env.docker /runtimeconfig/.env.docker

# Install only production deps
RUN npm ci --omit=dev

EXPOSE 8443 8080 50051
CMD ["npm", "run", "start"]
