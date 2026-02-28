# ========================
# Flutter Build Stage
# ========================
FROM ghcr.io/cirruslabs/flutter:stable AS flutter

# BUILD TIME ARGS
#ARG SERVER_URL=http://0.0.0.0:8080
#ARG APP_NAME=flutter-grpc-client
#ARG APP_VERSION=1.0.0
#ARG APP_ENV=production

# LOCAL TESTING ARGUMENTS
ARG SERVER_URL=http://0.0.0.0:8080
ARG APP_NAME=flutter-grpc-client
ARG APP_VERSION=1.0.0
ARG APP_ENV=docker

# Install protoc and dart protoc plugin
RUN apt-get update && apt-get install -y protobuf-compiler curl unzip
RUN dart pub global activate protoc_plugin 21.1.2

# Add dart global bin to PATH
ENV PATH="${PATH}:/root/.pub-cache/bin"

WORKDIR /workspace

# Copy proto files from parent directory
COPY proto/ /workspace/proto/

# Copy Flutter app
COPY client/ /workspace/client/

WORKDIR /workspace/client

# Get Flutter dependencies first (for better caching)
COPY client/pubspec.* ./
RUN flutter pub get

# Generate Dart code from proto files
# Adjust the paths according to your proto file structure
RUN protoc --dart_out=grpc:lib/proto -I/workspace/proto /workspace/proto/*.proto

# Build Flutter web app with build-time environment variables via --dart-define
RUN flutter build web --release \
    --dart-define=SERVER_URL=${SERVER_URL} \
    --dart-define=APP_NAME=${APP_NAME} \
    --dart-define=APP_VERSION=${APP_VERSION} \
    --dart-define=APP_ENV=${APP_ENV}

# ========================
# NPM Build Stage
# ========================
FROM node:25.0.0-slim AS node
WORKDIR /workspace

# Copy over NPM Config
COPY client/package.json ./

# Install dependencies
RUN npm install
RUN npm ci --omit=dev

# ========================
# Runtime Stage
# ========================
FROM node:25.0.0-slim
WORKDIR /app

# UNCOMMENT FOR LOCAL TESTING
# ENV PORT=8080
# ENV SERVER_SECURE=false
# ENV APP_NAME=flutter-grpc-client
# ENV APP_VERSION=1.0.0
# ENV APP_HOST=0.0.0.0

# Runtime environment variables (injected via Docker -e or ECS task definition)
# These will be read by server.js and exposed via /config endpoint
# Examples (set via: docker run -e GRPC_HOST=your.host ...):
# ENV GRPC_HOST=0.0.0.0
# ENV GRPC_PORT=50051
# ENV GRPC_SECURE=false
# ENV APP_ENV=local
# ENV SERVER_URL=http://0.0.0.0:8080
# See server.js /config endpoint for full list of available variables

# Install bash if needed
RUN apt-get update && apt-get install -y bash && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy build files
COPY --from=flutter /workspace/client/build/web /app/build/web
COPY --from=node /workspace/node_modules /app/node_modules
COPY --from=node /workspace/package*.json /app

#COPY Server Definition
COPY client/server.js /app

# FOR DEBUGGING PURPOSES ONLY
# COPY client/.env.dev /app

# Expose the port
EXPOSE 8080 8443
CMD ["node", "server.js"]