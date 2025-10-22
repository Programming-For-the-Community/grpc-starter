FROM node:25.0.0-slim

# Set Working Dirctory
WORKDIR /app

# Environment Variables
ENV NODE_ENV=/runtimeconfig/.env.dev

RUN mkdir proto
RUN mkdir /runtimeconfig

# Copy Source Code
COPY ./proto/tracker.proto proto
COPY ./server .
COPY ./server/.env.dev /runtimeconfig/.env.dev

RUN npm install && npm run build

EXPOSE 8443
EXPOSE 8080
EXPOSE 50051

CMD ["npm", "run", "start"]