import * as grpc from '@grpc/grpc-js';

// Internal Imports
import { logger } from '../lib/logger';
import { dynamoClient } from '../lib/dynamoClient';
import { User, LocationResponse, Username, TrackerStatus, Location, Path, PathRequest } from '../protoDefinitions/tracker';

export async function getLocations(call: grpc.ServerWritableStream<PathRequest, LocationResponse>) {
  try {
    logger.info('Starting real-time streaming for GetLocation.');

    // Step 1: Lookup the user in the DynamoDB table
    const item = await dynamoClient.getItem('Username', call.request.userName);

    // Write initial response if the user is found
    if (item?.PathsTraveled && item?.PathsTravelled[call.request.pathKey]) {
      logger.info(`Found path ${call.request.pathKey} for user: ${item.Username} in the table.`);
      const returnPath: Path = {
        pathTraveled: item.PathsTraveled[call.request.pathKey],
      };

      // Write each location in the client stream
      for (const loc of returnPath.pathTraveled) {
        const response: LocationResponse = {
          status: TrackerStatus.OK,
          message: `Location ${returnPath.pathTraveled.indexOf(loc)} of path ${call.request.pathKey} for user ${item.Username} retrieved.`,
          userName: item.Username,
          location: {
            x: loc.x,
            y: loc.y,
          },
        };
        call.write(response);
      }

      // If user not found, send USER_NOT_FOUND status and end the stream
    } else {
      if (item) {
        logger.info(`User not found: ${call.request.userName}`);

        call.write({
          status: TrackerStatus.USER_NOT_FOUND,
          message: `No user found for name: ${call.request.userName}`,
          userName: call.request.userName,
        });
      } else {
        logger.info(`No paths traveled found for user: ${call.request.userName}`);

        call.write({
          status: TrackerStatus.PATH_NOT_FOUND,
          message: `No path ${call.request.pathKey} found for user: ${call.request.userName}`,
          userName: call.request.userName,
        });
      }
    }
  } catch (error) {
    const err: Error = error as Error;
    logger.error(`Error streaming users: ${err.message}`);
    call.write({
      status: TrackerStatus.USER_STREAM_ERROR,
      message: `Error retrieving path ${call.request.pathKey} for ${call.request.userName}: ${err.message}`,
      userName: call.request.userName,
    });
  }

  call.end();
  logger.info('Streaming for GetPath ended.');
}
