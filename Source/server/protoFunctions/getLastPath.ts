import * as grpc from '@grpc/grpc-js';

// Internal Imports
import { logger } from '../lib/logger';
import { dynamoClient } from '../lib/dynamoClient';
import { LocationResponse, TrackerStatus, Location, Path, Username } from '../protoDefinitions/tracker';

export async function getLastPath(call: grpc.ServerWritableStream<Username, LocationResponse>) {
  try {
    logger.info('Starting real-time streaming for GetLocation.');

    // Step 1: Lookup the user in the DynamoDB table
    const item = await dynamoClient.getItem('Username', call.request.name);

    // Write initial response if the user is found
    if (item?.PathsTraveled && item?.PathsTravelled.length > 0) {
      let maxPathKey: number = 0;
      for (const pathKey of Object.keys(item.PathsTraveled)) {
        if (parseInt(pathKey) > maxPathKey) {
          maxPathKey = parseInt(pathKey);
        }
      }

      logger.info(`Last path for user: ${item.Username} is ${maxPathKey}`);

      const returnPath: Path = {
        pathTraveled: item.PathsTraveled[maxPathKey],
      };

      // Write each location in the client stream
      for (const loc of returnPath.pathTraveled) {
        const response: LocationResponse = {
          status: TrackerStatus.OK,
          message: `Location ${returnPath.pathTraveled.indexOf(loc)} of path ${maxPathKey} for user ${item.Username} retrieved.`,
          userName: item.Username,
          location: loc as Location,
        };
        call.write(response);
      }

      // If user not found, send USER_NOT_FOUND status and end the stream
    } else {
      if (item) {
        logger.info(`User not found: ${call.request.name}`);

        call.write({
          status: TrackerStatus.USER_NOT_FOUND,
          message: `No user found for name: ${call.request.name}`,
          userName: call.request.name,
        });
      } else {
        logger.info(`No paths travelled found for user: ${call.request.name}`);

        call.write({
          status: TrackerStatus.PATH_NOT_FOUND,
          message: `No paths found for user: ${call.request.name}`,
          userName: call.request.name,
        });
      }
    }
  } catch (error) {
    const err: Error = error as Error;
    logger.error(`Error streaming users: ${err.message}`);
    call.write({
      status: TrackerStatus.USER_STREAM_ERROR,
      message: `Error retrieving paths for ${call.request.name}: ${err.message}`,
      userName: call.request.name,
    });
  }

  call.end();
  logger.info('Streaming for GetLastPath ended.');
}
