import dotenv from 'dotenv';
import process from 'process';

import { appConfig } from '../server';

dotenv.config({ path: process.env.NODE_ENV !== undefined ? process.env.NODE_ENV : '.env' });

export const serverConfig = {
  appName: appConfig.APP_NAME,
  appVersion: appConfig.APP_VERSION,
  host: appConfig.HOST,
  port: appConfig.PORT,
  healthCheckIntervalMs: appConfig.HEALTH_CHECK_INTERVAL_MS ? parseInt(appConfig.HEALTH_CHECK_INTERVAL_MS) : 10000,
};

export const uiDimensions = {
  maxSize: appConfig.MAX_SIZE ? parseFloat(appConfig.MAX_SIZE) : 10000,
  minSize: appConfig.MIN_SIZE ? parseFloat(appConfig.MIN_SIZE) : -10000,
};

export const pathLimits = {
  minLength: appConfig.MIN_PATH_LENGTH ? parseInt(appConfig.MIN_PATH_LENGTH) : 15,
  maxLength: appConfig.MAX_PATH_LENGTH ? parseInt(appConfig.MAX_PATH_LENGTH) : 50,
};
