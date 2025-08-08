import { unmarshall } from '@aws-sdk/util-dynamodb';
import { ServerWritableStream } from '@grpc/grpc-js';
import { ShardIteratorType } from '@aws-sdk/client-dynamodb-streams';

import { logger } from '../lib/logger';
import { dynamoClient } from '../lib/dynamoClient';
import { databaseConfig } from '../config/databaseConfig';
import { Username, LocationResponse, TrackerStatus, DynamoDBEvent, dynamoDBEventFromJSON } from '../protoDefinitions/tracker';

/**
 * Real-time streaming implementation for GetUsers using DynamoDB Streams.
 * @param call gRPC server writable stream.
 */
export const getLocation = async (call: ServerWritableStream<Username, LocationResponse>): Promise<void> => {
  try {
    logger.info('Starting real-time streaming for GetLocation.');

    // Step 1: Lookup the user in the DynamoDB table
    const item = await dynamoClient.getItem('Username', call.request.name);

    // Write initial response if the user is found
    if (item) {
      logger.info(`Found location for user: ${item.Username} in the table.`);
      const response: LocationResponse = {
        status: TrackerStatus.OK,
        message: `Current location of ${item.Username} retrieved.`,
        userName: item.Username,
        location: item.CurrentLocation,
      };
      call.write(response);

      // If user not found, send USER_NOT_FOUND status and end the stream
    } else {
      logger.info(`User not found: ${call.request.name}`);

      call.write({
        status: TrackerStatus.USER_NOT_FOUND,
        message: `No user found for name: ${call.request.name}`,
        userName: call.request.name,
      });
      call.end();
      return;
    }

    // Step 2: Process real-time changes from the DynamoDB Stream
    const shardIterators: { [shardId: string]: string | undefined } = {};

    // Poll all shards
    while (true) {
      // Refresh shards periodically
      await dynamoClient.streamTable(shardIterators, ShardIteratorType.LATEST, databaseConfig.tableStreamArn);

      for (const shardId of Object.keys(shardIterators)) {
        const iterator = shardIterators[shardId];
        if (!iterator) continue;

        const streamRecords: Record<string, any>[] = await dynamoClient.getStreamRecords(shardId, iterator);

        if (streamRecords && streamRecords.length > 0) {
          // active = true; // Keep polling if there are records
          for (const record of streamRecords) {
            const eventName: DynamoDBEvent = dynamoDBEventFromJSON(record.eventName);
            let rawData: Record<string, any> | undefined;

            // Set the rawData to the OldImage to capture REMOVE events
            if (eventName === DynamoDBEvent.REMOVE) {
              rawData = record.dynamodb?.OldImage;
            } else {
              rawData = record.dynamodb?.NewImage;
            }

            if (rawData) {
              const userData = unmarshall(rawData);

              const response: LocationResponse = {
                status: TrackerStatus.OK,
                message: `Updated location for ${userData.Username}: ${JSON.stringify(userData.currentLocation)}`,
                userName: userData.Username,
                location: item.CurrentLocation,
              };

              call.write(response);
            } else {
              logger.warn(`No user data found in record: ${JSON.stringify(record)}`);
              call.write({
                status: TrackerStatus.MISSING_USER_DATA,
                message: `No user data found in record: ${JSON.stringify(record)}`,
                userName: call.request.name,
              });
            }
          }
        } else {
          logger.info('No records found in the stream.');
          call.write({
            status: TrackerStatus.NO_RECORDS,
            message: 'No records found in the stream.',
            userName: call.request.name,
          });
        }
      }
    }
  } catch (error) {
    const err: Error = error as Error;
    logger.error(`Error streaming users: ${err.message}`);
    call.write({
      status: TrackerStatus.USER_STREAM_ERROR,
      message: `Error streaming users: ${err.message}`,
      userName: call.request.name,
    });

    call.end();
  }

  logger.info('Real-time streaming for GetUsers ended.');
};
