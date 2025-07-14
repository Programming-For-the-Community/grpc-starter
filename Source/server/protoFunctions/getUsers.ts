import { ServerWritableStream } from '@grpc/grpc-js';
import { ScanCommand } from '@aws-sdk/client-dynamodb';
import { GetRecordsOutput } from '@aws-sdk/client-dynamodb-streams';

import { logger } from '../lib/logger';
import { databaseConfig } from '../config/databaseConfig';
import { getDynamoStreamsClient, getDynamoDocumentClient } from '../lib/dynamoClient';
import { RealTimeUserResponse, TrackerStatus } from '../protoDefinitions/tracker';

/**
 * Real-time streaming implementation for GetUsers using DynamoDB Streams.
 * @param call gRPC server writable stream.
 */
export const getUsers = async (call: ServerWritableStream<{}, RealTimeUserResponse>): Promise<void> => {
  try {
    logger.info('Starting real-time streaming for GetUsers.');

    // Initialize DynamoDB clients
    logger.info('Initializing DynamoDB clients.');
    const dynamoDBStreamsClient = await getDynamoStreamsClient();
    const dynamoDocumentClient = await getDynamoDocumentClient();
    logger.info('DynamoDB clients initialized successfully.');

    // Step 1: Query the table for existing data
    const scanCommand = new ScanCommand({ TableName: databaseConfig.tableName });
    const scanResult = await dynamoDocumentClient.send(scanCommand);

    if (scanResult.Items && scanResult.Items.length > 0) {
      logger.info(`Found ${scanResult.Items.length} existing items in the table.`);
      for (const item of scanResult.Items) {
        logger.debug('Processing item:', JSON.stringify(item));

        const response: RealTimeUserResponse = {
          status: TrackerStatus.OK,
          message: 'Existing user data retrieved.',
          eventType: 'EXISTING',
          userName: item.Username?.S || 'Unknown',
          currentLocation: {
            x: parseFloat(item.CurrentLocation?.M?.x?.N || '0'),
            y: parseFloat(item.CurrentLocation?.M?.y?.N || '0'),
          },
        };
        call.write(response);
      }
    } else {
      logger.info('No existing items found in the table.');
    }

    // Step 2: Process real-time changes from the DynamoDB Stream
    const streamDescription = await dynamoDBStreamsClient.describeStream({ StreamArn: databaseConfig.tableStreamArn });
    const shards = streamDescription.StreamDescription?.Shards || [];

    if (shards.length === 0) {
      logger.warn('No shards found in the DynamoDB stream description.');
      call.write({
        status: TrackerStatus.NO_RECORDS,
        message: 'No shards found in the DynamoDB stream description.',
      });
      call.end();
      return;
    }

    const shardIterators: { [shardId: string]: string | undefined } = {};

    // Poll all shards
    while (true) {
      // Refresh shards periodically
      const streamDescription = await dynamoDBStreamsClient.describeStream({ StreamArn: databaseConfig.tableStreamArn });
      const shards = streamDescription.StreamDescription?.Shards || [];

      for (const shard of shards) {
        if (!shard || !shard.ShardId) {
          logger.warn('Shard is undefined or missing ShardId.');
          continue;
        }

        if (!shardIterators[shard.ShardId]) {
          const shardIteratorResponse = await dynamoDBStreamsClient.getShardIterator({
            StreamArn: databaseConfig.tableStreamArn,
            ShardId: shard.ShardId,
            ShardIteratorType: 'LATEST',
          });

          shardIterators[shard.ShardId] = shardIteratorResponse?.ShardIterator;
        }
      }

      for (const shardId of Object.keys(shardIterators)) {
        const iterator = shardIterators[shardId];
        if (!iterator) continue;

        const streamRecords: GetRecordsOutput = await dynamoDBStreamsClient.getRecords({ ShardIterator: iterator });
        shardIterators[shardId] = streamRecords?.NextShardIterator;

        if (streamRecords?.Records && streamRecords.Records.length > 0) {
          // active = true; // Keep polling if there are records
          for (const record of streamRecords.Records) {
            const eventName = record.eventName;
            const userData = record.dynamodb?.NewImage;
            if (userData) {
              const response: RealTimeUserResponse = {
                status: TrackerStatus.OK,
                message: `Event received: ${eventName} with user data: ${JSON.stringify(userData)}`,
                eventType: eventName,
                userName: userData.Username?.S || 'Unknown',
                currentLocation: {
                  x: parseFloat(userData.CurrentLocation?.M?.x?.N || '0'),
                  y: parseFloat(userData.CurrentLocation?.M?.y?.N || '0'),
                },
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
      }
    }
  } catch (error) {
    if (error instanceof Error) {
      logger.error('Error streaming users:', error);
      call.write({
        status: TrackerStatus.USER_STREAM_ERROR,
        message: `Error streaming users: ${error.message}`,
      });
    } else {
      logger.error('Unknown error occurred:', error);
      call.write({
        status: TrackerStatus.USER_STREAM_ERROR,
        message: 'An unknown error occurred while streaming users.',
      });
    }
    call.end();
  }

  logger.info('Real-time streaming for GetUsers ended.');
};
