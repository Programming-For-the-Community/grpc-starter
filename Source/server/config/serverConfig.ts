import dotenv from 'dotenv';
import process from 'process';

dotenv.config({ path: process.env.NODE_ENV !== undefined ? process.env.NODE_ENV : '.env' });

export const serverConfig = {
  appName: process.env.APP_NAME,
  appVersion: process.env.APP_VERSION,
  host: process.env.HOST,
  port: process.env.PORT,
};

export const uiDimensions = {
  maxSize: process.env.MAX_SIZE ? parseFloat(process.env.MAX_SIZE) : 10000,
  minSize: process.env.MIN_SIZE ? parseFloat(process.env.MIN_SIZE) : -10000,
};

export const pathLimits = {
  minLength: process.env.MIN_PATH_LENGTH ? parseInt(process.env.MIN_PATH_LENGTH) : 15,
  maxLength: process.env.MAX_PATH_LENGTH ? parseInt(process.env.MAX_PATH_LENGTH) : 50,
};
