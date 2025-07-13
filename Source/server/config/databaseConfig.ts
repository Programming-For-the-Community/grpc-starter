import dotenv from 'dotenv';

dotenv.config({ path: process.env.NODE_ENV !== undefined ? process.env.NODE_ENV : '.env' });

export const databaseConfig = {
  awsRegion: process.env.AWS_REGION,
  tableName: process.env.TABLE_NAME,
  tableStreamArn: process.env.TABLE_STREAM_ARN,
  refreshFrequencyMs: process.env.REFRESH_FREQUENCY_MS ? parseInt(process.env.REFRESH_FREQUENCY_MS) : 1000,
  awsAccessKeyId: process.env.AWS_ACCESS_KEY_ID || '',
  awsSecretAccessKey: process.env.AWS_SECRET_ACCESS_KEY || '',
};
