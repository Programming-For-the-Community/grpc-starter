import * as grpc from '@grpc/grpc-js';
import * as protoLoader from '@grpc/proto-loader';
import path from 'path';

import { Logger } from '../../singletons/logger';

const logger: Logger = Logger.get();

// Load the health check proto
const HEALTH_PROTO_PATH = path.join(__dirname, '../../..', 'proto', 'health.proto');

const healthProtoDefinition = protoLoader.loadSync(HEALTH_PROTO_PATH, {
  keepCase: true,
  longs: String,
  enums: String,
  defaults: true,
  oneofs: true,
});

const healthProto = grpc.loadPackageDefinition(healthProtoDefinition) as any;
const healthService = healthProto.grpc.health.v1.Health.service;

export enum ServingStatus {
  UNKNOWN = 0,
  SERVING = 1,
  NOT_SERVING = 2,
  SERVICE_UNKNOWN = 3,
}

export class HealthImplementation {
  private statusMap: Map<string, ServingStatus>;

  constructor(initialStatus?: { [key: string]: ServingStatus }) {
    this.statusMap = new Map();
    if (initialStatus) {
      Object.entries(initialStatus).forEach(([service, status]) => {
        this.statusMap.set(service, status);
      });
    }
  }

  public check(call: grpc.ServerUnaryCall<{ service: string }, { status: ServingStatus }>, callback: grpc.sendUnaryData<{ status: ServingStatus }>) {
    const service = call.request.service;
    const status = this.statusMap.get(service);

    if (status === undefined) {
      callback(null, { status: ServingStatus.SERVICE_UNKNOWN });
      return;
    }

    callback(null, { status });
  }

  public watch(call: grpc.ServerWritableStream<{ service: string }, { status: ServingStatus }>) {
    const service = call.request.service;
    const status = this.statusMap.get(service);

    if (status === undefined) {
      call.write({ status: ServingStatus.SERVICE_UNKNOWN });
      return;
    }

    call.write({ status });
  }

  public setStatus(service: string, status: ServingStatus): void {
    this.statusMap.set(service, status);
    logger.info(`Health status for service ${service} set to ${ServingStatus[status]}`);
  }

  public getStatus(service: string): ServingStatus | undefined {
    return this.statusMap.get(service);
  }

  public addToServer(server: grpc.Server): void {
    // Use the properly loaded health service definition
    server.addService(healthService, {
      check: this.check.bind(this),
      watch: this.watch.bind(this),
    });
  }
}
