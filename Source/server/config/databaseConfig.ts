import dotenv from 'dotenv';

dotenv.config({ path: process.env.NODE_ENV !== undefined ? process.env.NODE_ENV : '.env' });

export const databaseConfig = {
  awsRegion: process.env.AWS_REGION,
  tableName: process.env.TABLE_NAME,
};
