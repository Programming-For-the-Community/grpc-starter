import { DynamoDBClient } from '@aws-sdk/client-dynamodb';
import { DynamoDBDocumentClient } from '@aws-sdk/lib-dynamodb';
import { DynamoDBStreams } from '@aws-sdk/client-dynamodb-streams';

// Internal Imports
import { databaseConfig } from '../config/databaseConfig';
import { getAssumedRoleCredentials } from './getAssumedRoleCredentials';

export const getDynamoDocumentClient = async (): Promise<DynamoDBDocumentClient> => {
  const credentials = await getAssumedRoleCredentials();
  const dbClient: DynamoDBClient = new DynamoDBClient({
    region: databaseConfig.awsRegion,
    credentials,
  });

  return DynamoDBDocumentClient.from(dbClient);
};

export const getDynamoStreamsClient = async () => {
  const credentials = await getAssumedRoleCredentials();
  return new DynamoDBStreams({
    region: databaseConfig.awsRegion,
    credentials,
  });
};
