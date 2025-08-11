import { DynamoDBClient } from '@aws-sdk/client-dynamodb';
import { DynamoDBDocumentClient, GetCommand, GetCommandInput, PutCommand, PutCommandInput, ScanCommand, UpdateCommand, UpdateCommandInput } from '@aws-sdk/lib-dynamodb';
import {
  DynamoDBStreamsClient,
  DescribeStreamCommand,
  DescribeStreamCommandOutput,
  Shard,
  GetRecordsCommand,
  GetRecordsCommandOutput,
  ShardIteratorType,
  GetShardIteratorCommand,
  GetShardIteratorCommandOutput,
} from '@aws-sdk/client-dynamodb-streams';

// Internal Imports
import { logger } from '../lib/logger';
import { databaseConfig } from '../config/databaseConfig';
import { getAssumedRoleCredentials } from './getAssumedRoleCredentials';

class DynamoClient {
  private static instance: DynamoClient;
  constructor() {
    if (DynamoClient.instance) {
      return DynamoClient.instance;
    }

    DynamoClient.instance = this;
  }

  static getInstance() {
    if (!DynamoClient.instance) {
      DynamoClient.instance = new DynamoClient();
    }

    return DynamoClient.instance;
  }

  private async getDynamoDocumentClient(): Promise<DynamoDBDocumentClient> {
    const credentials = await getAssumedRoleCredentials();
    const dbClient: DynamoDBClient = new DynamoDBClient({
      region: databaseConfig.awsRegion,
      credentials,
    });

    return DynamoDBDocumentClient.from(dbClient);
  }

  private async getDynamoStreamsClient(): Promise<DynamoDBStreamsClient> {
    const credentials = await getAssumedRoleCredentials();
    return new DynamoDBStreamsClient({
      region: databaseConfig.awsRegion,
      credentials,
    });
  }

  public async getItem(keyName: string, keyId: string, tableName: string | undefined = undefined): Promise<Record<string, any> | undefined> {
    let dynamoDocumentClient: DynamoDBDocumentClient | undefined = undefined;

    try {
      logger.info('Initializing dynamoDB clients for user retrieval.');
      dynamoDocumentClient = await this.getDynamoDocumentClient();
      logger.info('DynamoDB clients initialized successfully for user retrieval.');

      const getCommand: GetCommandInput = {
        TableName: tableName || databaseConfig.tableName,
        Key: { [keyName]: keyId },
      };

      const { Item } = await dynamoDocumentClient.send(new GetCommand(getCommand));

      logger.info(`${keyName}: ${keyId} retrieved successfully from DynamoDB.`);
      logger.debug('Retrieved item:', JSON.stringify(Item));

      dynamoDocumentClient.destroy();
      return Item;
    } catch (error) {
      const err: Error = error as Error;
      logger.error(`Error retrieving ${keyName}: ${keyId} from DynamoDB: ${error}`);

      if (dynamoDocumentClient) {
        dynamoDocumentClient.destroy();
      }

      throw new Error(`Failed to retrieve item: ${err.message}`);
    }
  }

  public async putItem(item: Record<string, any>, tableName: string | undefined = undefined): Promise<void> {
    let dynamoDocumentClient: DynamoDBDocumentClient | undefined = undefined;

    try {
      logger.info('Initializing dynamoDB clients for item insertion.');
      dynamoDocumentClient = await this.getDynamoDocumentClient();
      logger.info('DynamoDB clients initialized successfully for item insertion.');

      const putCommandInput: PutCommandInput = {
        TableName: tableName || databaseConfig.tableName,
        Item: item,
      };

      await dynamoDocumentClient.send(new PutCommand(putCommandInput));
      logger.info('Item inserted successfully into DynamoDB.');

      dynamoDocumentClient.destroy();
    } catch (error) {
      const err: Error = error as Error;
      logger.error(`Error inserting item into DynamoDB: ${err}`);

      if (dynamoDocumentClient) {
        dynamoDocumentClient.destroy();
      }

      throw new Error(`Failed to insert item: ${err.message}`);
    }
  }

  public async scanTable(tableName: string | undefined = undefined): Promise<Record<string, any>[] | undefined> {
    let dynamoDocumentClient: DynamoDBDocumentClient | undefined = undefined;

    try {
      logger.info('Initializing dynamoDB clients for table scan.');
      dynamoDocumentClient = await this.getDynamoDocumentClient();
      logger.info('DynamoDB clients initialized successfully for table scan.');

      const scanCommand: ScanCommand = new ScanCommand({
        TableName: tableName || databaseConfig.tableName,
      });

      const { Items } = await dynamoDocumentClient.send(scanCommand);
      logger.info(`Table ${tableName || databaseConfig.tableName} scanned successfully.`);

      dynamoDocumentClient.destroy();
      return Items;
    } catch (error) {
      const err: Error = error as Error;
      logger.error(`Error scanning table ${tableName || databaseConfig.tableName}: ${err}`);

      if (dynamoDocumentClient) {
        dynamoDocumentClient.destroy();
      }

      throw new Error(`Failed to scan table: ${err.message}`);
    }
  }

  public async streamTable(shardIterators: { [shardId: string]: string | undefined }, shardIteratorType: ShardIteratorType, tableArn: string | undefined = undefined): Promise<void> {
    let dynamoDBStreamsClient: DynamoDBStreamsClient | undefined = undefined;

    try {
      logger.info('Initializing DynamoDB Streams client for table streaming.');
      dynamoDBStreamsClient = await this.getDynamoStreamsClient();
      logger.info('DynamoDB Streams client initialized successfully.');

      const describeStreamCommand: DescribeStreamCommand = new DescribeStreamCommand({
        StreamArn: tableArn || databaseConfig.tableStreamArn,
      });

      const streamDescription: DescribeStreamCommandOutput = await dynamoDBStreamsClient.send(describeStreamCommand);
      const shards: Shard[] = streamDescription.StreamDescription?.Shards || [];

      if (!streamDescription.StreamDescription?.Shards || streamDescription.StreamDescription.Shards.length === 0) {
        logger.warn(`No shards found in the stream for table ${tableArn}.`);
        return;
      }

      // Loop through each shard and get the shard iterator
      logger.info(`Found ${shards.length} shards in the stream for table ${tableArn || databaseConfig.tableStreamArn}.`);
      for (const shard of shards) {
        if (!shard || !shard.ShardId) {
          logger.warn('Shard is undefined or missing ShardId.');
          continue;
        }

        if (!shardIterators[shard.ShardId]) {
          const getShardIteratorCommand: GetShardIteratorCommand = new GetShardIteratorCommand({
            StreamArn: tableArn || databaseConfig.tableStreamArn,
            ShardId: shard.ShardId,
            ShardIteratorType: shardIteratorType,
          });

          const shardIteratorResponse: GetShardIteratorCommandOutput = await dynamoDBStreamsClient.send(getShardIteratorCommand);
          shardIterators[shard.ShardId] = shardIteratorResponse?.ShardIterator;
        }
      }

      logger.info(`Successfully retrieved shard iterator for table ${tableArn}.`);

      return;
    } catch (error) {
      const err: Error = error as Error;
      logger.error(`Error streaming table ${tableArn}: ${err}`);

      if (dynamoDBStreamsClient) {
        dynamoDBStreamsClient.destroy();
      }

      throw new Error(`Failed to stream table: ${err.message}`);
    }
  }

  public async getStreamRecords(shardId: string, shardIterator: string): Promise<Record<string, any>[]> {
    let dynamoDBStreamsClient: DynamoDBStreamsClient | undefined = undefined;

    try {
      logger.info(`Initializing DynamoDB Streams client for shard ${shardId}.`);
      dynamoDBStreamsClient = await this.getDynamoStreamsClient();
      logger.info(`DynamoDB Streams client initialized successfully for shard ${shardId}.`);

      const getRecordsCommand: GetRecordsCommand = new GetRecordsCommand({
        ShardIterator: shardIterator,
      });

      const streamRecords: GetRecordsCommandOutput = await dynamoDBStreamsClient.send(getRecordsCommand);
      logger.info(`Retrieved records from shard ${shardId}.`);

      if (streamRecords.Records && streamRecords.Records.length > 0) {
        return streamRecords.Records;
      } else {
        logger.info(`No records found in shard ${shardId}.`);
        return [];
      }
    } catch (error) {
      const err: Error = error as Error;
      logger.error(`Error retrieving records from shard ${shardId}: ${err}`);

      if (dynamoDBStreamsClient) {
        dynamoDBStreamsClient.destroy();
      }

      throw new Error(`Failed to retrieve records from shard: ${err.message}`);
    }
  }

  public async updateItem(keyName: string, keyValue: string, updateValues: Map<string, any>, tableName: string | undefined = undefined): Promise<void> {
    let dynamoDocumentClient: DynamoDBDocumentClient | undefined = undefined;

    try {
      logger.info('Initializing dynamoDB clients for item update.');
      dynamoDocumentClient = await this.getDynamoDocumentClient();
      logger.info('DynamoDB clients initialized successfully for item update.');

      let updateExpression = 'SET';
      const expressionAttributeNames: Record<string, string> = {};
      const expressionAttributeValues: Record<string, any> = {};

      let i: number = 0;
      for (const key of updateValues.keys()) {
        updateExpression += ` #field${i} = :value${i},`;
        expressionAttributeNames[`#field${i}`] = key;
        expressionAttributeValues[`:value${i}`] = updateValues.get(key);

        i++; // Increment index for next field
      }

      // Remove trailing comma
      updateExpression = updateExpression.replace(/,+\s*$/, '');

      const updateCommand: UpdateCommandInput = {
        TableName: tableName || databaseConfig.tableName,
        Key: { [keyName]: keyValue },
        UpdateExpression: updateExpression,
        ExpressionAttributeNames: expressionAttributeNames,
        ExpressionAttributeValues: expressionAttributeValues,
      };

      await dynamoDocumentClient.send(new UpdateCommand(updateCommand));
      logger.info(`Item ${keyName} on table ${tableName || databaseConfig.tableName}: Successfully updated values ${JSON.stringify(updateValues)}.`);

      dynamoDocumentClient.destroy();
    } catch (error) {
      const err: Error = error as Error;
      logger.error(`Error updating item with ${keyName}: ${updateValues.get(keyName)} in DynamoDB: ${err}`);

      if (dynamoDocumentClient) {
        dynamoDocumentClient.destroy();
      }

      throw new Error(`Failed to update item: ${err.message}`);
    }
  }
}

// Exporting a singleton instance of DynamoClient
export const dynamoClient: DynamoClient = new DynamoClient();
