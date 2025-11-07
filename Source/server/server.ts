// External Imports
import path from 'path';
import * as http from 'http';
import express from 'express';
import * as https from 'https';
import * as grpc from '@grpc/grpc-js';
import * as protoLoader from '@grpc/proto-loader';

// Internal Imports
import { Logger } from './singletons/logger';
import { configManager } from './lib/loadConfig';
import { getUser } from './protoFunctions/tracker/getUser';
import { getPath } from './protoFunctions/tracker/getPath';
import { monitorDatabaseHealth } from './lib/healthMonitor';
import { moveUser } from './protoFunctions/tracker/moveUser';
import { getUsers } from './protoFunctions/tracker/getUsers';
import { takeTrip } from './protoFunctions/tracker/takeTrip';
import { initializeServerConfig } from './config/serverConfig';
import { initializeLoggerConfig } from './config/loggerConfig';
import { DatabaseConfig } from './interfaces/databaseInterfaces';
import { createUser } from './protoFunctions/tracker/createUser';
import { initializeDatabaseConfig } from './config/databaseConfig';
import { getLocation } from './protoFunctions/tracker/getLocation';
import { getLastPath } from './protoFunctions/tracker/getLastPath';
import { getLocations } from './protoFunctions/tracker/getLocations';
import { getCurrentLocation } from './protoFunctions/tracker/getCurrentLocation';
import { HealthImplementation, ServingStatus } from './protoFunctions/health/healthService';
import { AppConfig, ServerConfig, UIDimensions, PathLimits, HealthCheckResponse } from './interfaces/appInterfaces';

// Proto file location
const PROTO_PATH = path.join(__dirname, '..', 'proto', 'tracker.proto');

const logger: Logger = Logger.get();

// Export config for other modules to import
export const config = {
  healthCheckService: null as HealthImplementation | null,
  appConfig: null as AppConfig | null,
  serverConfig: null as ServerConfig | null,
  uiDimensions: null as UIDimensions | null,
  pathLimits: null as PathLimits | null,
  databaseConfig: null as DatabaseConfig | null,
};

async function initializeServer() {
  // Load in configs
  config.appConfig = await configManager.initialize();

  // Destructure into local variables first, then assign to the config object to avoid parsing ambiguity
  const { serverConfig, healthConfig, uiDimensions, pathLimits } = initializeServerConfig(config.appConfig);
  config.serverConfig = serverConfig;
  config.uiDimensions = uiDimensions;
  config.pathLimits = pathLimits;

  const { databaseConfig } = initializeDatabaseConfig(config.appConfig);
  config.databaseConfig = databaseConfig;

  const { loggerConfig } = initializeLoggerConfig(config.appConfig);

  logger.setFormat(loggerConfig);

  logger.info('Application Configuration:');

  (Object.keys(config.appConfig) as Array<keyof AppConfig>).forEach((key) => {
    logger.info(`${key}: ${config.appConfig![key]}`);
  });

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

  // Configure GRPC Services
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
  config.healthCheckService = new HealthImplementation({
    '': ServingStatus.SERVING,
    'tracker.Tracker': ServingStatus.SERVING,
  });
  config.healthCheckService.addToServer(server);

  // Start server
  const serverAddress = `${serverConfig!.host}:${serverConfig!.port}`;

  // TODO: Add SSL credentials if needed
  const credentials: grpc.ServerCredentials = grpc.ServerCredentials.createInsecure(); // Default to no SSL

  server.bindAsync(serverAddress, credentials, (err) => {
    if (err) {
      logger.error('Server binding error:', err);
      throw err;
    }

    logger.info(`🚀 gRPC server listening on ${serverAddress}`);
  });

  monitorDatabaseHealth();

  // Configure HTTP Health Endpoint
  const app = express();
  app.set('etag', false); // Disable etag caching

  app.get('/health', async (req: express.Request, res: express.Response) => {
    logger.info(`${req.method} - ${req.originalUrl}: Requestor IP - ${req.ip}`);
    const response: HealthCheckResponse = { status: ServingStatus[ServingStatus.UNKNOWN], services: { 'tracker.Tracker': ServingStatus[ServingStatus.UNKNOWN] } };

    try {
      response.status = ServingStatus[config.healthCheckService!.getStatus('')!];
      response.services['tracker.Tracker'] = ServingStatus[config.healthCheckService!.getStatus('tracker.Tracker')!];

      if (response.status === ServingStatus[ServingStatus.SERVING]) {
        res.status(200).json(response);
      } else {
        res.status(503).json(response);
      }
    } catch (error: Error | any) {
      response.status = ServingStatus[ServingStatus.NOT_SERVING];
      response.services['tracker.Tracker'] = ServingStatus[ServingStatus.NOT_SERVING];
      response.error = error.message;

      res.status(500).json(response);
    }

    logger.info(`${req.method} - ${req.originalUrl}: Response - ${res.statusCode} - ${JSON.stringify(response)}`);
  });

  // Deny all non-health paths
  app.use((req: express.Request, res: express.Response) => {
    logger.info(`${req.method} - ${req.originalUrl}: Requestor IP - ${req.ip}`);

    res.status(404).json({
      error: 'Path not supported',
      path: req.originalUrl,
      method: req.method,
    });
  });

  // TODO: Add HTTPS options if needed
  const httpsOptions: https.ServerOptions = {};

  const healthServer = healthConfig.secure ? https.createServer(httpsOptions, app) : http.createServer(app);

  healthServer.listen(parseInt(healthConfig.port), healthConfig.host, () => {
    logger.info(`Health check HTTP server listening on ${healthConfig.secure ? 'https' : 'http'}://${healthConfig.host}:${healthConfig.port}/health`);
  });
}

initializeServer();
