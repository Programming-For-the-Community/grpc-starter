import * as grpc from '@grpc/grpc-js';
import { PutCommand, GetCommand, PutCommandInput, GetCommandInput, DynamoDBDocumentClient } from '@aws-sdk/lib-dynamodb';

// Internal Imports
import { logger } from '../lib/logger';
import { getDynamoDocumentClient } from '../lib/dynamoClient';
import { databaseConfig } from '../config/databaseConfig';
import { User, UserResponse, Username, TrackerStatus } from '../protoDefinitions/tracker';

export async function createUser(call: grpc.ServerUnaryCall<Username, UserResponse>, callback: grpc.sendUnaryData<UserResponse>) {
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

    const getCommand: GetCommand = new GetCommand(getItemParams);

    const { Item } = await dynamoDocumentClient.send(getCommand);

    // Return if user exists
    if (Item) {
      logger.info(`User ${name} already exists`);

      callback(null, {
        status: TrackerStatus.USER_ALREADY_EXISTS,
        message: `User ${name} already exists`,
      });
      return;
    }

    const newUser: User = {
      name: name,
      currentLocation: {
        x: 0,
        y: 0,
      },
      pathsTraveled: {},
    };

    // Create user in database
    const newUserParams: PutCommandInput = {
      TableName: databaseConfig.tableName ?? '',
      Item: {
        Username: name,
        CurrentLocation: {
          x: newUser.currentLocation?.x,
          y: newUser.currentLocation?.y,
        },
        PathsTraveled: {
          0: [
            {
              x: 0,
              y: 0,
            },
          ],
        },
      },
    };

    const putCommand: PutCommand = new PutCommand(newUserParams);

    await dynamoDocumentClient.send(putCommand);
    logger.info(`User ${name} created successfully in DynamoDB.`);

    // Destroy the DynamoDB client
    await dynamoDocumentClient.destroy();
    logger.info('DynamoDB client destroyed after user creation.');

    // Successful user creation
    callback(null, {
      status: TrackerStatus.OK,
      message: `Successfully  create user ${name}`,
      user: newUser,
    });
  } catch (err) {
    logger.error(`Could not create user in DynamoDB: ${err}`);

    // Destroy the DynamoDB client in case of error
    if (dynamoDocumentClient !== undefined) {
      await dynamoDocumentClient.destroy();
      logger.info('DynamoDB client destroyed after error in user creation.');
    }

    callback(null, {
      status: TrackerStatus.USER_NOT_CREATED,
      message: `Could not create user in DynamoDB: ${err}`,
    });
  }
}
