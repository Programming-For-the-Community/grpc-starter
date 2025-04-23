import * as grpc from '@grpc/grpc-js';
import { PutItemCommand, PutItemCommandInput, GetItemCommand, GetItemCommandInput } from '@aws-sdk/client-dynamodb';

// Internal Imports
import { logger } from '../lib/logger';
import { databaseConfig } from '../config/databaseConfig';
import { dynamoDocumentClient } from '../lib/dynamoClient';
import { User, UserResponse, Username, TrackerStatus } from '../protoDefinitions/tracker';

export async function createUser(call: grpc.ServerUnaryCall<Username, UserResponse>, callback: grpc.sendUnaryData<UserResponse>) {
  const { name } = call.request;

  // Check if the user already exists
  try {
    const getItemParams: GetItemCommandInput = {
      TableName: databaseConfig.tableName ?? '',
      Key: {
        Username: { S: name },
      },
    };

    const getCommand: GetItemCommand = new GetItemCommand(getItemParams);

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
  } catch (err) {
    logger.error(err);
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
  try {
    const newUserParams: PutItemCommandInput = {
      TableName: databaseConfig.tableName ?? '',
      Item: {
        Username: { S: name },
        CurrentLocation: { S: JSON.stringify(newUser.currentLocation) },
        User: { S: JSON.stringify(newUser) },
      },
    };

    const putCommand: PutItemCommand = new PutItemCommand(newUserParams);

    await dynamoDocumentClient.send(putCommand);

    // Successful user creation
    callback(null, {
      status: TrackerStatus.OK,
      message: `Successfully  create user ${name}`,
      user: newUser,
    });
  } catch (err) {
    logger.error(`Could not create user in DynamoDB: ${err}`);

    callback(null, {
      status: TrackerStatus.USER_NOT_CREATED,
      message: `Could not create user in DynamoDB: ${err}`,
    });
  }
}
