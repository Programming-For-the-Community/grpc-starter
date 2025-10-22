// External Imports
import path from 'path';
import * as grpc from '@grpc/grpc-js';
import * as protoLoader from '@grpc/proto-loader';
import * as health from 'grpc-health-check';

// Internal Imports
import { configManager } from './lib/loadConfig';
import { monitorDatabaseHealth } from './lib/healthMonitor';
// Proto file location
const PROTO_PATH = path.join(__dirname, '..', 'proto', 'tracker.proto');

// Export config singleton for other modules to import
export let appConfig: ReturnType<typeof configManager.getConfig>;
let healthCheckService: health.HealthImplementation;

async function initializeServer() {
  // Step 1: Initialize config FIRST
  appConfig = await configManager.initialize();

  // Step 2: Now safe to import modules that depend on config
  const { logger } = await import('./classes/logger');
  const { getUser } = await import('./protoFunctions/getUser');
  const { getPath } = await import('./protoFunctions/getPath');
  const { moveUser } = await import('./protoFunctions/moveUser');
  const { getUsers } = await import('./protoFunctions/getUsers');
  const { takeTrip } = await import('./protoFunctions/takeTrip');
  const { createUser } = await import('./protoFunctions/createUser');
  const { getLocation } = await import('./protoFunctions/getLocation');
  const { getLastPath } = await import('./protoFunctions/getLastPath');
  const { monitorDatabaseHealth } = await import('./lib/healthMonitor');
  const { getLocations } = await import('./protoFunctions/getLocations');
  const { getCurrentLocation } = await import('./protoFunctions/getCurrentLocation');

  logger.info('Starting gRPC server initialization');

  // Load proto file
  const packageDefinition = protoLoader.loadSync(PROTO_PATH, {
    keepCase: true,
    longs: String,
    enums: String,
    defaults: true,
    oneofs: true,
    includeDirs: [path.resolve(__dirname, '../../proto'), path.resolve(__dirname, '../../node_modules/google-proto-files')],
  });

  const grpcObject = grpc.loadPackageDefinition(packageDefinition) as any;

  logger.info(`Available services in tracker package: ${Object.keys(grpcObject.tracker)}`);

  const trackerService = grpcObject.tracker.Tracker.service;

  // Create gRPC server
  const server: grpc.Server = new grpc.Server();
  server.addService(trackerService, {
    createUser,
    getUsers,
    getUser,
    getLocation,
    getCurrentLocation,
    getLastPath,
    getPath,
    moveUser,
    takeTrip,
    getLocations,
  });

  // Add HealthCheck Service
  healthCheckService = new health.HealthImplementation({
    '': health.servingStatus.SERVING,
    'tracker.Tracker': health.servingStatus.SERVING,
  });
  healthCheckService.addToServer(server);

  // Start server
  const serverAddress = `${appConfig.GRPC_HOST}:${appConfig.GRPC_PORT}`;
  const credentials: grpc.ServerCredentials = grpc.ServerCredentials.createInsecure(); // Default to no SSL

  server.bindAsync(serverAddress, credentials, (err) => {
    if (err) {
      logger.error('Server binding error:', err);
      throw err;
    }

    logger.info(`🚀 gRPC server listening on ${serverAddress}`);
  });

  monitorDatabaseHealth();

  return { server, logger };
}

// Start the server
if (require.main === module) {
  initializeServer().catch((error) => {
    throw error;
  });
}

export { initializeServer, healthCheckService };
