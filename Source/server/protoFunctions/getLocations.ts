import * as grpc from '@grpc/grpc-js';

// Internal Imports
import { logger } from '../classes/logger';
import { dynamoClient } from '../lib/dynamoClient';
import { User, LocationResponse, Username, TrackerStatus } from '../protoDefinitions/tracker';

export async function getLocations(call: grpc.ServerDuplexStream<Username, LocationResponse>) {
  call.on('data', async (username: Username) => {
    try {
      const item: Record<string, any> | undefined = await dynamoClient.getItem('Username', username.name);

      if (item) {
        const user: User = {
          name: item.Username,
          currentLocation: item.CurrentLocation,
          pathsTraveled: item.PathsTraveled,
        };

        logger.debug('Retrieved user data:', JSON.stringify(user));

        call.write({
          status: TrackerStatus.OK,
          message: `User ${username.name} retrieved successfully`,
          userName: user.name,
          location: user.currentLocation,
        });
      } else {
        logger.info(`No user found for name: ${username.name}`);
        call.write({
          status: TrackerStatus.USER_NOT_FOUND,
          message: `No user found for name: ${username.name}`,
          userName: username.name,
        });
      }
    } catch (error) {
      const err: Error = error as Error;
      logger.error(`Error retrieving user ${username.name}:`, error);

      call.write({
        status: TrackerStatus.USER_NOT_FOUND,
        message: `Error retrieving user: ${username.name} - ${err.message}`,
        userName: username.name,
      });
    }
  });

  call.on('end', () => {
    logger.info('Stream ended by client.');
    call.end();
  });
}
