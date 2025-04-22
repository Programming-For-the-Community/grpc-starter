import path from 'path';
import * as grpc from '@grpc/grpc-js';
import * as protoLoader from '@grpc/proto-loader';

import createUser from './protoFunctions/createUser';

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
        path.resolve(__dirname, '../../node_modules/google-proto-files') // google protobufs
      ],
});

// Get typed service definition
const grpcObject = grpc.loadPackageDefinition(packageDefinition) as any;
const trackerService = grpcObject.Tracker.service;

// Create gRPC server
const server = new grpc.Server();
console.log("Hello world");
server.addService(trackerService, {
    createUser: createUser
});