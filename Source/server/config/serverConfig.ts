import dotenv from 'dotenv';

dotenv.config({ path: process.env.NODE_ENV !== undefined ? process.env.NODE_ENV : '.env' });

export const serverConfig = {
  appName: process.env.APP_NAME,
  appVersion: process.env.APP_VERSION,
  host: process.env.HOST,
  port: process.env.PORT,
};
