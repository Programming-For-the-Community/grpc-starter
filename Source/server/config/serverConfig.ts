import { AppConfig, ServerConfig, HealthConfig, UIDimensions, PathLimits } from '../interfaces/appInterfaces';

export function initializeServerConfig(appConfig: AppConfig): { serverConfig: ServerConfig; healthConfig: HealthConfig; uiDimensions: UIDimensions; pathLimits: PathLimits } {
  const serverConfig: ServerConfig = {
    appName: appConfig.APP_NAME,
    appVersion: appConfig.APP_VERSION,
    host: appConfig.GRPC_HOST,
    port: appConfig.GRPC_PORT,
    secure: appConfig.GRPC_SECURE === 'true',
    healthCheckIntervalMs: appConfig.HEALTH_CHECK_INTERVAL_MS ? parseInt(appConfig.HEALTH_CHECK_INTERVAL_MS) : 10000,
  };

  const healthConfig: HealthConfig = {
    host: appConfig.HTTP_HOST,
    port: appConfig.HTTP_PORT,
    secure: appConfig.HTTP_SECURE === 'true',
  };

  const uiDimensions: UIDimensions = {
    maxSize: appConfig.MAX_SIZE ? parseFloat(appConfig.MAX_SIZE) : 10000,
    minSize: appConfig.MIN_SIZE ? parseFloat(appConfig.MIN_SIZE) : -10000,
  };

  const pathLimits: PathLimits = {
    minLength: appConfig.MIN_PATH_LENGTH ? parseInt(appConfig.MIN_PATH_LENGTH) : 15,
    maxLength: appConfig.MAX_PATH_LENGTH ? parseInt(appConfig.MAX_PATH_LENGTH) : 50,
  };

  return { serverConfig, healthConfig, uiDimensions, pathLimits };
}
