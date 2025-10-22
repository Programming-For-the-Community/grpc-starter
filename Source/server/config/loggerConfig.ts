import { appConfig } from '../server';

const defaultFormat = '[%s] %s: [processor: %s, platform: %s@%s, app: %s@%s]: %s';

export const loggerConfig = {
  level: appConfig.LOG_LEVEL ?? 'info',
  format: appConfig.LOG_FORMAT ?? defaultFormat,
};
