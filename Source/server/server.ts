// External Imports
import path from 'path';
import * as grpc from '@grpc/grpc-js';
import * as protoLoader from '@grpc/proto-loader';

// Internal Imports
import { createUser } from './protoFunctions/createUser';
import { logger } from './lib/logger';
import { serverConfig } from './config/serverConfig';

// Proto file location
const PROTO_PATH = path.join(__dirname, '..', 'proto', 'tracker.proto');

// Load proto file dynamically
const packageDefinition = protoLoader.loadSync(PROTO_PATH, {
  keepCase: true,
  longs: String,
  enums: String,
  defaults: true,
  oneofs: true,
  includeDirs: [
    path.resolve(__dirname, '../../proto'), // your proto/ folder
    path.resolve(__dirname, '../../node_modules/google-proto-files'), // google protobufs
  ],
});

// Get typed service definition
const grpcObject = grpc.loadPackageDefinition(packageDefinition) as any;

logger.info(`Available services in tracker package: ${Object.keys(grpcObject.tracker)}`);

const trackerService = grpcObject.tracker.Tracker.service;

// Create gRPC server
const server: grpc.Server = new grpc.Server();
server.addService(trackerService, {
  createUser: createUser,
});

server.bindAsync(`${serverConfig.host}:${serverConfig.port}`, grpc.ServerCredentials.createInsecure(), (err) => {
  if (err) {
    logger.error('Server binding error:', err);
    return;
  }

  logger.info(`🚀 gRPC server listening on ${serverConfig.host}:${serverConfig.port}`);
});
