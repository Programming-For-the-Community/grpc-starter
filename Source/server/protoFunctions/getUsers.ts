import { ServerWritableStream } from '@grpc/grpc-js';
import { ScanCommand } from '@aws-sdk/client-dynamodb';
import { GetRecordsOutput } from '@aws-sdk/client-dynamodb-streams';

import { logger } from '../lib/logger';
import { databaseConfig } from '../config/databaseConfig';
import { dynamoDBStreamsClient, dynamoDocumentClient } from '../lib/dynamoClient';
import { RealTimeUserResponse, TrackerStatus } from '../protoDefinitions/tracker';

/**
 * Real-time streaming implementation for GetUsers using DynamoDB Streams.
 * @param call gRPC server writable stream.
 */
export const getUsers = async (call: ServerWritableStream<{}, RealTimeUserResponse>): Promise<void> => {
  try {
    logger.info('Starting real-time streaming for GetUsers.');

    // Step 1: Query the table for existing data
    const scanCommand = new ScanCommand({ TableName: databaseConfig.tableName });
    const scanResult = await dynamoDocumentClient.send(scanCommand);

    if (scanResult.Items && scanResult.Items.length > 0) {
      logger.info(`Found ${scanResult.Items.length} existing items in the table.`);
      for (const item of scanResult.Items) {
        const response: RealTimeUserResponse = {
          status: TrackerStatus.OK,
          message: 'Existing user data retrieved.',
          eventType: 'EXISTING',
          userName: item.Username?.S || 'Unknown',
          currentLocation: {
            x: parseFloat(item.currentLocation?.M?.x?.N || '0'),
            y: parseFloat(item.currentLocation?.M?.y?.N || '0'),
          },
        };
        call.write(response);
      }
    } else {
      logger.info('No existing items found in the table.');
    }

    // Step 2: Process real-time changes from the DynamoDB Stream
    const streamDescription = await dynamoDBStreamsClient.describeStream({ StreamArn: databaseConfig.tableStreamArn });

    if (!streamDescription || !streamDescription.StreamDescription || !streamDescription.StreamDescription.Shards || streamDescription.StreamDescription.Shards.length === 0) {
      logger.warn('No shards found in the DynamoDB stream description.');

      call.write({
        status: TrackerStatus.NO_RECORDS,
        message: 'No shards found in the DynamoDB stream description.',
      });
      call.end();
      return;
    }

    const shardId = streamDescription.StreamDescription.Shards[0].ShardId;

    const shardIteratorResponse = await dynamoDBStreamsClient.getShardIterator({
      StreamArn: databaseConfig.tableStreamArn,
      ShardId: shardId,
      ShardIteratorType: 'LATEST', // Start from the latest changes
    });

    let shardIterator = shardIteratorResponse?.ShardIterator;

    if (!shardIterator) {
      logger.warn('Shard iterator could not be retrieved.');

      call.write({
        status: TrackerStatus.NO_RECORDS,
        message: 'Shard iterator could not be retrieved.',
      });
      call.end();
      return;
    }

    // Poll the DynamoDB Stream for changes
    while (shardIterator) {
      const streamRecords: GetRecordsOutput = await dynamoDBStreamsClient.getRecords({ ShardIterator: shardIterator });
      shardIterator = streamRecords?.NextShardIterator;

      if (streamRecords?.Records && streamRecords.Records.length > 0) {
        for (const record of streamRecords.Records) {
          const eventName = record.eventName; // INSERT, MODIFY, REMOVE
          const userData = record.dynamodb?.NewImage;

          if (userData) {
            const response: RealTimeUserResponse = {
              status: TrackerStatus.OK,
              message: `Event received: ${eventName} with user data: ${JSON.stringify(userData)}`,
              eventType: eventName,
              userName: userData.Username?.S || 'Unknown',
              currentLocation: {
                x: parseFloat(userData.currentLocation?.M?.x?.N || '0'),
                y: parseFloat(userData.currentLocation?.M?.y?.N || '0'),
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

      await new Promise((resolve) => setTimeout(resolve, databaseConfig.refreshFrequencyMs));
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
