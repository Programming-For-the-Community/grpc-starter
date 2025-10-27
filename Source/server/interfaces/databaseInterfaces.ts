export interface DatabaseConfig {
  awsRegion: string;
  tableName: string;
  tableStreamArn: string;
  refreshFrequencyMs: number;
  grpcDynamoDBRoleArn: string;
}
