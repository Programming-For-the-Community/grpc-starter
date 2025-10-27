import { ServingStatus } from '../protoFunctions/health/healthService';

/**
 * App configuration loaded from environment variables or other sources.
 */
export interface AppConfig {
  [key: string]: string;
}

export interface ServerConfig {
  appName: string;
  appVersion: string;
  host: string;
  port: string;
  secure: boolean;
  healthCheckIntervalMs: number;
}

export interface UIDimensions {
  maxSize: number;
  minSize: number;
}

export interface PathLimits {
  minLength: number;
  maxLength: number;
}

export interface HealthConfig {
  host: string;
  port: string;
  secure: boolean; // Add health-related configuration properties here if needed
}

export interface HealthCheckResponse {
  status: string;
  services: { [key: string]: string };
  error?: string;
}
