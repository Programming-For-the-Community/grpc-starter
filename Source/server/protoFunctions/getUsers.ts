import { ServerWritableStream } from '@grpc/grpc-js';

import { logger } from '../lib/logger';
import { dynamoDBStreamsClient } from '../lib/dynamoClient';
import { RealTimeUserResponse } from '../protoDefinitions/tracker';

/**
 * Real-time streaming implementation for GetUsers using DynamoDB Streams.
 * @param call gRPC server writable stream.
 */
export const getUsers = async (call: ServerWritableStream<{}, RealTimeUserResponse>): Promise<void> => {
    const streamArn = 'arn:aws:dynamodb:us-east-1:123456789012:table/UsersTable/stream/2025-06-04T00:00:00.000'; // Replace with your DynamoDB Stream ARN
  
    try {
      logger.info('Starting real-time streaming for GetUsers.');
  
      // Get the shard iterator for the DynamoDB Stream
      const streamDescription = await dynamoDBStreamsClient.describeStream({ StreamArn: streamArn });
      const shardId = streamDescription.StreamDescription.Shards[0].ShardId;
  
      const shardIteratorResponse = await dynamoDBStreamsClient.getShardIterator({
        StreamArn: streamArn,
        ShardId: shardId,
        ShardIteratorType: 'LATEST', // Start from the latest changes
      });
  
      let shardIterator = shardIteratorResponse.ShardIterator;
  
      // Poll the DynamoDB Stream for changes
      while (shardIterator) {
        const streamRecords = await dynamoDBStreamsClient.getRecords({ ShardIterator: shardIterator });
        shardIterator = streamRecords.NextShardIterator;
  
        // Process each record in the stream
        for (const record of streamRecords.Records) {
          const eventName = record.eventName; // INSERT, MODIFY, REMOVE
          const userData = record.dynamodb?.NewImage;
  
          if (userData) {
            const response = new RealTimeUserResponse();
            response.setStatus('OK');
            response.setMessage('User update');
            response.setEventType(eventName); // INSERT, MODIFY, REMOVE
            response.setUserName(userData.name.S);
            response.setCurrentLocation({
              x: parseFloat(userData.currentLocation.M.x.N),
              y: parseFloat(userData.currentLocation.M.y.N),
            });
  
            call.write(response);
          }
        }
  
        // Wait before polling again to avoid excessive requests
        await new Promise((resolve) => setTimeout(resolve, 1000));
      }
    } catch (error) {
      logger.error('Error streaming users:', error);
      call.end(); // End the stream in case of an error
    }
  
    logger.info('Real-time streaming for GetUsers ended.');
  };
