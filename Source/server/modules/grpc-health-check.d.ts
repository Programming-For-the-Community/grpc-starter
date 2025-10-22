declare module 'grpc-health-check' {
  import * as grpc from '@grpc/grpc-js';

  export enum servingStatus {
    UNKNOWN = 0,
    SERVING = 1,
    NOT_SERVING = 2,
    SERVICE_UNKNOWN = 3,
  }

  export class HealthImplementation {
    constructor(statusMap: { [service: string]: servingStatus });
    addToServer(server: grpc.Server): void;
    setStatus(service: string, status: servingStatus): void;
  }
}
