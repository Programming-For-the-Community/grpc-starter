import * as grpc from '@grpc/grpc-js';

// Internal Imports
import { logger } from '../lib/logger';
import { dynamoClient } from '../lib/dynamoClient';
import { Location } from '../protoDefinitions/tracker';
import { getRandomCoords } from '../lib/getRandomCoords';
import { UserResponse, Username, TrackerStatus } from '../protoDefinitions/tracker';

/**
 * Creates a new user in the DynamoDB database.
 * @param call gRPC server unary call containing the username.
 * @param callback grpc callback to send the response.
 */
export async function createUser(call: grpc.ServerUnaryCall<Username, UserResponse>, callback: grpc.sendUnaryData<UserResponse>) {
  try {
    // Randomly generate new coordinates within the UI dimensions
    const newLocation: Location = getRandomCoords();

    await dynamoClient.updateItem('Username', call.request.name, new Map([['CurrentLocation', newLocation]]));

    // Successful user creation
    callback(null, {
      status: TrackerStatus.OK,
      message: `Successfully updated user ${call.request.name} with new location: ${JSON.stringify(newLocation)}`,
    });
  } catch (error) {
    const err: Error = error as Error;
    logger.error(`Could not create user in DynamoDB: ${err.message}`);

    callback(null, {
      status: TrackerStatus.USER_NOT_MOVED,
      message: `Could not update current location of user in DynamoDB: ${err.message}`,
    });
  }
}
