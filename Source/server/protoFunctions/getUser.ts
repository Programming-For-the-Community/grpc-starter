import * as grpc from '@grpc/grpc-js';
import { GetCommand, GetCommandInput, DynamoDBDocumentClient } from '@aws-sdk/lib-dynamodb';

// Internal Imports
import { logger } from '../lib/logger';
import { getDynamoDocumentClient } from '../lib/dynamoClient';
import { databaseConfig } from '../config/databaseConfig';
import { User, UserResponse, Username, TrackerStatus } from '../protoDefinitions/tracker';

export async function getUser(call: grpc.ServerUnaryCall<Username, UserResponse>, callback: grpc.sendUnaryData<UserResponse>) {
  const { name } = call.request;
  let dynamoDocumentClient: DynamoDBDocumentClient | undefined = undefined;
  // Check if the user already exists
  try {
    logger.info('Initializing dynamoDB clients for user creation.');
    dynamoDocumentClient = await getDynamoDocumentClient();
    logger.info('DynamoDB clients initialized successfully for user creation.');

    const getItemParams: GetCommandInput = {
      TableName: databaseConfig.tableName ?? '',
      Key: {
        Username: name,
      },
    };

    const user: User = {
      name: name,
      currentLocation: {
        x: 0,
        y: 0,
      },
      pathsTraveled: {},
    };

    const getCommand: GetCommand = new GetCommand(getItemParams);

    const { Item } = await dynamoDocumentClient.send(getCommand);

    // Return if user exists
    if (Item) {
      logger.info(`User ${name} retrieved successfully`);
      logger.debug('Retrieved user data:', JSON.stringify(Item));

      user.name = Item.Username?.S || name;
      user.currentLocation = {
        x: parseFloat(Item.CurrentLocation?.x),
        y: parseFloat(Item.CurrentLocation?.y),
      };
      user.pathsTraveled = Item.PathsTraveled;

      callback(null, {
        status: TrackerStatus.OK,
        message: `User ${name} retrieved successfully`,
        user: user,
      });
    } else {
      logger.info(`No user found for name: ${name}`);
      callback(null, {
        status: TrackerStatus.USER_NOT_FOUND,
        message: `No user found for name: ${name}`,
      });
    }
  } catch (error) {
    logger.error(`Error retrieving user ${name}:`, error);

    if (error instanceof Error) {
      callback(null, {
        status: TrackerStatus.USER_NOT_FOUND,
        message: `Error retrieving user: ${name} - ${error.message}`,
      });
    } else {
      callback(null, {
        status: TrackerStatus.USER_NOT_FOUND,
        message: `Unknown error retrieving user: ${name}`,
      });
    }
  }
}
