import { DynamoDBClient } from '@aws-sdk/client-dynamodb';

// Internal Imports
import { databaseConfig } from '../config/databaseConfig';

export const dynamoDocumentClient = new DynamoDBClient({ region: databaseConfig.awsRegion });
