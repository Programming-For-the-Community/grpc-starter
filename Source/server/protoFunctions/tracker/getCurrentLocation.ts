import * as grpc from '@grpc/grpc-js';

// Internal Imports
import { Logger } from '../../singletons/logger';
import { dynamoClient } from '../../singletons/dynamoClient';
import { User, LocationResponse, Username, TrackerStatus } from '../../protoDefinitions/tracker';

export async function getCurrentLocation(call: grpc.ServerUnaryCall<Username, LocationResponse>, callback: grpc.sendUnaryData<LocationResponse>) {
  const logger: Logger = Logger.get();

  const { name } = call.request;

  try {
    const item: Record<string, any> | undefined = await dynamoClient.getItem('Username', name);

    if (item) {
      const user: User = {
        name: item.Username,
        currentLocation: item.CurrentLocation,
        pathsTraveled: item.PathsTraveled,
      };

      logger.debug('Retrieved user data:', JSON.stringify(user));

      callback(null, {
        status: TrackerStatus.OK,
        message: `User ${name} retrieved successfully`,
        userName: user.name,
        location: user.currentLocation,
      });
    } else {
      logger.info(`No user found for name: ${name}`);
      callback(null, {
        status: TrackerStatus.USER_NOT_FOUND,
        message: `No user found for name: ${name}`,
        userName: name,
      });
    }
  } catch (error) {
    const err: Error = error as Error;
    logger.error(`Error retrieving user ${name}:`, error);

    callback(null, {
      status: TrackerStatus.USER_NOT_FOUND,
      message: `Error retrieving user: ${name} - ${err.message}`,
      userName: name,
    });
  }
}
