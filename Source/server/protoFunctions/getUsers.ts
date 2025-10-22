import { unmarshall } from '@aws-sdk/util-dynamodb';
import { ServerWritableStream } from '@grpc/grpc-js';
import { ShardIteratorType, DescribeStreamCommandOutput, GetRecordsCommandOutput, Shard } from '@aws-sdk/client-dynamodb-streams';

import { logger } from '../classes/logger';
import { dynamoClient } from '../lib/dynamoClient';
import { databaseConfig } from '../config/databaseConfig';
import { RealTimeUserResponse, TrackerStatus, DynamoDBEvent, dynamoDBEventFromJSON } from '../protoDefinitions/tracker';

/**
 * Real-time streaming implementation for GetUsers using DynamoDB Streams.
 * @param call gRPC server writable stream.
 */
export const getUsers = async (call: ServerWritableStream<{}, RealTimeUserResponse>): Promise<void> => {
  let running: boolean = true;

  // Handle client disconnection
  call.on('cancelled', () => {
    running = false;
    logger.info('Client cancelled the stream.');
  });

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
    while (running) {
      // Refresh shards periodically
      // Refresh stream description to catch new or expired shards
      const streamDescription: DescribeStreamCommandOutput = await dynamoClient.describeStream(databaseConfig.tableStreamArn);
      const shards: Shard[] | undefined = streamDescription.StreamDescription?.Shards || [];

      // Initialize iterators for new shards
      for (const shard of shards) {
        if (!shard.ShardId || shardIterators[shard.ShardId]) continue;

        const iterator = await dynamoClient.getShardIterator({
          StreamArn: databaseConfig.tableStreamArn,
          ShardId: shard.ShardId,
          ShardIteratorType: 'TRIM_HORIZON', // Get all records, not just new ones
        });

        if (iterator) {
          shardIterators[shard.ShardId] = iterator;
          logger.info(`Initialized iterator for shard: ${shard.ShardId}`);
        }
      }

      for (const [shardId, iterator] of Object.keys(shardIterators)) {
        if (!iterator) {
          delete shardIterators[shardId];
          continue;
        }

        try {
          const streamRecords: GetRecordsCommandOutput | undefined = await dynamoClient.getStreamRecords(shardId, iterator);
          const records = streamRecords?.Records || [];

          if (records && records.length > 0) {
            // active = true; // Keep polling if there are records
            for (const record of records) {
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

          // Update iterator for next poll
          if (streamRecords?.NextShardIterator) {
            shardIterators[shardId] = streamRecords.NextShardIterator;
          } else {
            // Shard has been closed
            logger.info(`Shard ${shardId} has been closed`);
            delete shardIterators[shardId];
          }
        } catch (error: Error | any) {
          if (error.name === 'ExpiredIteratorException') {
            // Get new iterator for this shard
            logger.info(`Iterator expired for shard ${shardId}, requesting new iterator`);
            delete shardIterators[shardId];
          } else {
            throw error;
          }
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
