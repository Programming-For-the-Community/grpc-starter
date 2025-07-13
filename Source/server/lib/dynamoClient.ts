import { DynamoDBClient } from '@aws-sdk/client-dynamodb';
import { DynamoDBStreams } from '@aws-sdk/client-dynamodb-streams';

// Internal Imports
import { databaseConfig } from '../config/databaseConfig';
import { getAssumedRoleCredentials } from './getAssumedRoleCredentials';

export const getDynamoDocumentClient = async () => {
  const credentials = await getAssumedRoleCredentials();
  return new DynamoDBClient({
    region: databaseConfig.awsRegion,
    credentials,
  });
};

export const getDynamoStreamsClient = async () => {
  const credentials = await getAssumedRoleCredentials();
  return new DynamoDBStreams({
    region: databaseConfig.awsRegion,
    credentials,
  });
};
