import { AppConfig } from '../interfaces/appInterfaces';
import { DatabaseConfig } from '../interfaces/databaseInterfaces';

export function initializeDatabaseConfig(appConfig: AppConfig): { databaseConfig: DatabaseConfig } {
  const databaseConfig: DatabaseConfig = {
    awsRegion: appConfig.AWS_REGION,
    tableName: appConfig.TABLE_NAME,
    tableStreamArn: appConfig.TABLE_STREAM_ARN,
    refreshFrequencyMs: appConfig.REFRESH_FREQUENCY_MS ? parseInt(appConfig.REFRESH_FREQUENCY_MS) : 1000,
    grpcDynamoDBRoleArn: appConfig.GRPC_DYNAMODB_ROLE_ARN,
  };

  return { databaseConfig };
}
