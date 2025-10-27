import * as grpc from '@grpc/grpc-js';

// Internal Imports
import { config } from '../../server';
import { Logger } from '../../singletons/logger';
import { Location } from '../../protoDefinitions/tracker';
import { getRandomCoords } from '../../lib/getRandomCoords';
import { dynamoClient } from '../../singletons/dynamoClient';
import { UserResponse, Username, TrackerStatus, User } from '../../protoDefinitions/tracker';

/**
 * Creates a new user in the DynamoDB database.
 * @param call gRPC server unary call containing the username.
 * @param callback grpc callback to send the response.
 */
export async function takeTrip(call: grpc.ServerUnaryCall<Username, UserResponse>, callback: grpc.sendUnaryData<UserResponse>) {
  const logger: Logger = Logger.get();

  const { name } = call.request;
  let foundUser: boolean = false;
  const user: User = {
    name: '',
    currentLocation: { x: 0, y: 0 },
    pathsTraveled: [],
  };

  // Get user from database that we are going to add a trip for
  try {
    const item: Record<string, any> | undefined = await dynamoClient.getItem('Username', name);

    if (item) {
      user.name = item.Username;
      user.currentLocation = item.CurrentLocation;
      user.pathsTraveled = item.PathsTraveled;

      logger.debug('Retrieved user data:', JSON.stringify(user));

      foundUser = true;
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

  // Create a new trip for the user if they were found
  if (foundUser) {
    // Randomly generate a new trip for the user
    const pathLength = Math.floor(Math.random() * (config.pathLimits!.maxLength - config.pathLimits!.minLength) + config.pathLimits!.minLength);
    const newTrip: Location[] = [];

    // Generate random path based off the user's current location and the path length
    for (let i = 0; i < pathLength; i++) {
      const { x = 0, y = 0 } = user.currentLocation || {};

      const xMin = x - 25;
      const xMax = x + 75;
      const yMin = y - 25;
      const yMax = y + 75;

      const newLocation: Location = getRandomCoords(xMin, xMax, yMin, yMax);

      user.currentLocation = newLocation;
      newTrip.push(newLocation);
    }

    // Assign the new trip to the user's paths traveled
    user.pathsTraveled[Object.keys(user.pathsTraveled).length] = { pathTraveled: newTrip };

    // Update the user in the database with the new trip and current location
    try {
      await dynamoClient.updateItem(
        'Username',
        user.name,
        new Map([
          ['CurrentLocation', user.currentLocation],
          ['PathsTraveled', user.pathsTraveled],
        ]),
      );

      // Successful user creation
      callback(null, {
        status: TrackerStatus.OK,
        message: `Successfully created a new trip for user ${user.name} with an end location: ${JSON.stringify(user.currentLocation)}`,
        user: user,
      });
    } catch (error) {
      const err: Error = error as Error;
      logger.error(`Could not update user in DynamoDB: ${err.message}`);

      callback(null, {
        status: TrackerStatus.USER_NOT_MOVED,
        message: `Could not update user in DynamoDB: ${err.message}`,
      });
    }
  }
}
