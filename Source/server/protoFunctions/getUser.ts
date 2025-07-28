import * as grpc from '@grpc/grpc-js';

// Internal Imports
import { logger } from '../lib/logger';
import { dynamoClient } from '../lib/dynamoClient';
import { User, UserResponse, Username, TrackerStatus } from '../protoDefinitions/tracker';

export async function getUser(call: grpc.ServerUnaryCall<Username, UserResponse>, callback: grpc.sendUnaryData<UserResponse>) {
  const { name } = call.request;

  try {
    const item: Record<string, any> | undefined = await dynamoClient.getItem('Username', name);

    if (item) {
      const user: User = {
        name: item.Username,
        currentLocation: {
          x: parseFloat(item.CurrentLocation?.x),
          y: parseFloat(item.CurrentLocation?.y),
        },
        pathsTraveled: item.PathsTraveled,
      };

      logger.debug('Retrieved user data:', JSON.stringify(user));

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
    const err: Error = error as Error;
    logger.error(`Error retrieving user ${name}:`, error);

    callback(null, {
      status: TrackerStatus.USER_NOT_FOUND,
      message: `Error retrieving user: ${name} - ${err.message}`,
    });
  }
}
