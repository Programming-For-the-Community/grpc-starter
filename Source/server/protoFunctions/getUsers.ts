import { unmarshall } from '@aws-sdk/util-dynamodb';
import { ServerWritableStream } from '@grpc/grpc-js';
import { ShardIteratorType } from '@aws-sdk/client-dynamodb-streams';

import { logger } from '../lib/logger';
import { dynamoClient } from '../lib/dynamoClient';
import { databaseConfig } from '../config/databaseConfig';
import { RealTimeUserResponse, TrackerStatus, DynamoDBEvent, dynamoDBEventFromJSON } from '../protoDefinitions/tracker';

/**
 * Real-time streaming implementation for GetUsers using DynamoDB Streams.
 * @param call gRPC server writable stream.
 */
export const getUsers = async (call: ServerWritableStream<{}, RealTimeUserResponse>): Promise<void> => {
  try {
    logger.info('Starting real-time streaming for GetUsers.');

    // Step 1: Query the table for existing data
    const scanResult = await dynamoClient.scanTable();

    if (scanResult && scanResult.length > 0) {
      logger.info(`Found ${scanResult.length} existing items in the table.`);
      for (const item of scanResult) {
        logger.debug('Processing item:', JSON.stringify(item));

        const response: RealTimeUserResponse = {
          status: TrackerStatus.OK,
          message: 'Existing user data retrieved.',
          eventType: DynamoDBEvent.EXISTING,
          userName: item.Username,
          currentLocation: item.CurrentLocation,
        };
        call.write(response);
      }
    } else {
      logger.info('No existing items found in the table.');
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

              const response: RealTimeUserResponse = {
                status: TrackerStatus.OK,
                message: `Event received: ${eventName} with user data: ${JSON.stringify(userData)}`,
                eventType: eventName,
                userName: userData.Username,
                currentLocation: userData.CurrentLocation,
              };

              call.write(response);
            } else {
              logger.warn(`No user data found in record: ${JSON.stringify(record)}`);
              call.write({
                status: TrackerStatus.MISSING_USER_DATA,
                message: `No user data found in record: ${JSON.stringify(record)}`,
              });
            }
          }
        } else {
          logger.info('No records found in the stream.');
          call.write({
            status: TrackerStatus.NO_RECORDS,
            message: 'No records found in the stream.',
          });
        }

        // Delay the next polling iteration using REFRESH_FREQUENCY_MS
        await new Promise((resolve) => setTimeout(resolve, databaseConfig.refreshFrequencyMs));
      }
    }
  } catch (error) {
    const err: Error = error as Error;
    logger.error(`Error streaming users: ${err.message}`);
    call.write({
      status: TrackerStatus.USER_STREAM_ERROR,
      message: `Error streaming users: ${err.message}`,
    });

    call.end();
  }

  logger.info('Real-time streaming for GetUsers ended.');
};
