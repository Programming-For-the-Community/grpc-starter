import os from 'os';
import { AppConfig } from '../interfaces/appInterfaces';
import { LoggerConfig } from '../interfaces/loggerInterfaces';

const defaultFormat = '[%s] %s: [processor: %s, platform: %s@%s, app: %s@%s] %s: %s';

export function initializeLoggerConfig(appConfig: AppConfig): { loggerConfig: LoggerConfig } {
  const loggerConfig: LoggerConfig = {
    level: appConfig.LOG_LEVEL ?? 'info',
    format: appConfig.LOG_FORMAT ?? defaultFormat,
    processor: os.hostname(),
    platform: os.platform(),
    release: os.release(),
    app: appConfig.APP_NAME,
    version: appConfig.APP_VERSION,
  };

  return { loggerConfig };
}
