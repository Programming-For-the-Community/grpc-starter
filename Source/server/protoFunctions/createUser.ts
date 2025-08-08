import * as grpc from '@grpc/grpc-js';

// Internal Imports
import { logger } from '../lib/logger';
import { dynamoClient } from '../lib/dynamoClient';
import { User, UserResponse, Username, TrackerStatus } from '../protoDefinitions/tracker';

/**
 * Creates a new user in the DynamoDB database.
 * @param call gRPC server unary call containing the username.
 * @param callback grpc callback to send the response.
 */
export async function createUser(call: grpc.ServerUnaryCall<Username, UserResponse>, callback: grpc.sendUnaryData<UserResponse>) {
  const { name } = call.request;

  try {
    // Check if user already exists
    const item: Record<string, any> | undefined = await dynamoClient.getItem('Username', name);

    // Return if user exists
    if (item) {
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
    const newUserDynamoItem = {
      Username: name,
      CurrentLocation: newUser.currentLocation,
      PathsTraveled: {},
    };

    await dynamoClient.putItem(newUserDynamoItem);

    // Successful user creation
    callback(null, {
      status: TrackerStatus.OK,
      message: `Successfully  create user ${name}`,
      user: newUser,
    });
  } catch (error) {
    const err: Error = error as Error;
    logger.error(`Could not create user in DynamoDB: ${err.message}`);

    callback(null, {
      status: TrackerStatus.USER_NOT_CREATED,
      message: `Could not create user in DynamoDB: ${err.message}`,
    });
  }
}
