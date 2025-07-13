import { DynamoDBClient } from '@aws-sdk/client-dynamodb';
import { DynamoDBStreams } from '@aws-sdk/client-dynamodb-streams';

// Internal Imports
import { databaseConfig } from '../config/databaseConfig';

export const dynamoDocumentClient = new DynamoDBClient({
  region: databaseConfig.awsRegion,
  credentials: {
    accessKeyId: databaseConfig.awsAccessKeyId,
    secretAccessKey: databaseConfig.awsSecretAccessKey,
  },
});

export const dynamoDBStreamsClient = new DynamoDBStreams({
  region: databaseConfig.awsRegion,
  credentials: {
    accessKeyId: databaseConfig.awsAccessKeyId,
    secretAccessKey: databaseConfig.awsSecretAccessKey,
  },
}); // Replace with your AWS region
