import { DynamoDBClient, DescribeTableCommand, DescribeTableCommandOutput } from '@aws-sdk/client-dynamodb';
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
import { Logger } from '../singletons/logger';
import { config } from '../server';
import { getAssumedRoleCredentials } from '../lib/getAssumedRoleCredentials';

class DynamoClient {
  private static instance: DynamoClient;
  private logger = Logger.get();

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
      region: config.databaseConfig!.awsRegion,
      credentials,
    });

    return DynamoDBDocumentClient.from(dbClient);
  }

  private async getDynamoStreamsClient(): Promise<DynamoDBStreamsClient> {
    const credentials = await getAssumedRoleCredentials();
    return new DynamoDBStreamsClient({
      region: config.databaseConfig!.awsRegion,
      credentials,
    });
  }

  private destroyDocumentClient(client: DynamoDBDocumentClient | undefined) {
    if (client) {
      client.destroy();
    }
  }

  private destroyStreamsClient(client: DynamoDBStreamsClient | undefined) {
    if (client) {
      client.destroy();
    }
  }

  public async getItem(keyName: string, keyId: string, tableName: string | undefined = undefined): Promise<Record<string, any> | undefined> {
    let dynamoDocumentClient: DynamoDBDocumentClient | undefined = undefined;

    try {
      this.logger.info('Initializing dynamoDB clients for user retrieval.');
      dynamoDocumentClient = await this.getDynamoDocumentClient();
      this.logger.info('DynamoDB clients initialized successfully for user retrieval.');

      const getCommand: GetCommandInput = {
        TableName: tableName || config.databaseConfig!.tableName,
        Key: { [keyName]: keyId },
      };

      const { Item } = await dynamoDocumentClient.send(new GetCommand(getCommand));

      this.logger.info(`${keyName}: ${keyId} retrieved successfully from DynamoDB.`);
      this.logger.debug('Retrieved item:', JSON.stringify(Item));

      this.destroyDocumentClient(dynamoDocumentClient);
      return Item;
    } catch (error) {
      const err: Error = error as Error;
      this.logger.error(`Error retrieving ${keyName}: ${keyId} from DynamoDB: ${error}`);

      this.destroyDocumentClient(dynamoDocumentClient);

      throw new Error(`Failed to retrieve item: ${err.message}`);
    }
  }

  public async putItem(item: Record<string, any>, tableName: string | undefined = undefined): Promise<void> {
    let dynamoDocumentClient: DynamoDBDocumentClient | undefined = undefined;

    try {
      this.logger.info('Initializing dynamoDB clients for item insertion.');
      dynamoDocumentClient = await this.getDynamoDocumentClient();
      this.logger.info('DynamoDB clients initialized successfully for item insertion.');

      const putCommandInput: PutCommandInput = {
        TableName: tableName || config.databaseConfig!.tableName,
        Item: item,
      };

      await dynamoDocumentClient.send(new PutCommand(putCommandInput));
      this.logger.info('Item inserted successfully into DynamoDB.');

      this.destroyDocumentClient(dynamoDocumentClient);
    } catch (error) {
      const err: Error = error as Error;
      this.logger.error(`Error inserting item into DynamoDB: ${err}`);

      this.destroyDocumentClient(dynamoDocumentClient);

      throw new Error(`Failed to insert item: ${err.message}`);
    }
  }

  public async scanTable(tableName: string | undefined = undefined): Promise<Record<string, any>[] | undefined> {
    let dynamoDocumentClient: DynamoDBDocumentClient | undefined = undefined;

    try {
      this.logger.info('Initializing dynamoDB clients for table scan.');
      dynamoDocumentClient = await this.getDynamoDocumentClient();
      this.logger.info('DynamoDB clients initialized successfully for table scan.');

      const scanCommand: ScanCommand = new ScanCommand({
        TableName: tableName || config.databaseConfig!.tableName,
      });

      const { Items } = await dynamoDocumentClient.send(scanCommand);
      this.logger.info(`Table ${tableName || config.databaseConfig!.tableName} scanned successfully.`);

      this.destroyDocumentClient(dynamoDocumentClient);
      return Items;
    } catch (error) {
      const err: Error = error as Error;
      this.logger.error(`Error scanning table ${tableName || config.databaseConfig!.tableName}: ${err}`);

      this.destroyDocumentClient(dynamoDocumentClient);

      throw new Error(`Failed to scan table: ${err.message}`);
    }
  }

  public async streamTable(shardIterators: { [shardId: string]: string | undefined }, shardIteratorType: ShardIteratorType, tableArn: string | undefined = undefined): Promise<void> {
    let dynamoDBStreamsClient: DynamoDBStreamsClient | undefined = undefined;

    try {
      this.logger.info('Initializing DynamoDB Streams client for table streaming.');
      dynamoDBStreamsClient = await this.getDynamoStreamsClient();
      this.logger.info('DynamoDB Streams client initialized successfully.');

      const describeStreamCommand: DescribeStreamCommand = new DescribeStreamCommand({
        StreamArn: tableArn || config.databaseConfig!.tableStreamArn,
      });

      const streamDescription: DescribeStreamCommandOutput = await dynamoDBStreamsClient.send(describeStreamCommand);
      const shards: Shard[] = streamDescription.StreamDescription?.Shards || [];

      if (!streamDescription.StreamDescription?.Shards || streamDescription.StreamDescription.Shards.length === 0) {
        this.logger.warn(`No shards found in the stream for table ${tableArn}.`);
        return;
      }

      // Loop through each shard and get the shard iterator
      this.logger.info(`Found ${shards.length} shards in the stream for table ${tableArn || config.databaseConfig!.tableStreamArn}.`);
      for (const shard of shards) {
        if (!shard || !shard.ShardId) {
          this.logger.warn('Shard is undefined or missing ShardId.');
          continue;
        }

        if (!shardIterators[shard.ShardId]) {
          const getShardIteratorCommand: GetShardIteratorCommand = new GetShardIteratorCommand({
            StreamArn: tableArn || config.databaseConfig!.tableStreamArn,
            ShardId: shard.ShardId,
            ShardIteratorType: shardIteratorType,
          });

          const shardIteratorResponse: GetShardIteratorCommandOutput = await dynamoDBStreamsClient.send(getShardIteratorCommand);
          shardIterators[shard.ShardId] = shardIteratorResponse?.ShardIterator;
        }
      }

      this.logger.info(`Successfully retrieved shard iterator for table ${tableArn}.`);

      return;
    } catch (error) {
      const err: Error = error as Error;
      this.logger.error(`Error streaming table ${tableArn}: ${err}`);

      this.destroyStreamsClient(dynamoDBStreamsClient);

      throw new Error(`Failed to stream table: ${err.message}`);
    }
  }

  public async getStreamRecords(shardId: string, shardIterator: string): Promise<GetRecordsCommandOutput | undefined> {
    let dynamoDBStreamsClient: DynamoDBStreamsClient | undefined = undefined;

    try {
      this.logger.info(`Initializing DynamoDB Streams client for shard ${shardId}.`);
      dynamoDBStreamsClient = await this.getDynamoStreamsClient();
      this.logger.info(`DynamoDB Streams client initialized successfully for shard ${shardId}.`);

      const getRecordsCommand: GetRecordsCommand = new GetRecordsCommand({
        ShardIterator: shardIterator,
      });

      const streamRecords: GetRecordsCommandOutput = await dynamoDBStreamsClient.send(getRecordsCommand);
      this.logger.info(`Retrieved records from shard ${shardId}.`);

      if (streamRecords.Records && streamRecords.Records.length > 0) {
        return streamRecords;
      } else {
        this.logger.info(`No records found in shard ${shardId}.`);
        return undefined;
      }
    } catch (error) {
      const err: Error = error as Error;
      this.logger.error(`Error retrieving records from shard ${shardId}: ${err}`);

      if (dynamoDBStreamsClient) {
        dynamoDBStreamsClient.destroy();
      }

      throw new Error(`Failed to retrieve records from shard: ${err.message}`);
    }
  }

  public async describeStream(streamArn: string | undefined): Promise<DescribeStreamCommandOutput> {
    let dynamoDBStreamsClient: DynamoDBStreamsClient | undefined = undefined;

    try {
      this.logger.info('Initializing DynamoDB Streams client for stream description.');
      dynamoDBStreamsClient = await this.getDynamoStreamsClient();
      this.logger.info('DynamoDB Streams client initialized successfully.');

      const describeStreamCommand: DescribeStreamCommand = new DescribeStreamCommand({
        StreamArn: streamArn,
      });

      const streamDescription: DescribeStreamCommandOutput = await dynamoDBStreamsClient.send(describeStreamCommand);
      this.logger.info(`Successfully described stream ${streamArn}`);

      return streamDescription;
    } catch (error) {
      const err: Error = error as Error;
      this.logger.error(`Error describing stream ${streamArn}: ${err}`);

      throw new Error(`Failed to describe stream: ${err.message}`);
    } finally {
      this.destroyStreamsClient(dynamoDBStreamsClient);
    }
  }

  public async getShardIterator(params: { StreamArn: string | undefined; ShardId: string; ShardIteratorType: ShardIteratorType }): Promise<string | undefined> {
    let dynamoDBStreamsClient: DynamoDBStreamsClient | undefined = undefined;

    try {
      this.logger.info('Initializing DynamoDB Streams client for shard iterator.');
      dynamoDBStreamsClient = await this.getDynamoStreamsClient();
      this.logger.info('DynamoDB Streams client initialized successfully.');

      const command = new GetShardIteratorCommand({
        StreamArn: params.StreamArn,
        ShardId: params.ShardId,
        ShardIteratorType: params.ShardIteratorType,
      });

      const response = await dynamoDBStreamsClient.send(command);
      this.logger.info(`Retrieved shard iterator for shard ${params.ShardId}`);

      return response.ShardIterator;
    } catch (error) {
      const err: Error = error as Error;
      this.logger.error(`Error getting shard iterator for shard ${params.ShardId}: ${err}`);

      throw new Error(`Failed to get shard iterator: ${err.message}`);
    } finally {
      this.destroyStreamsClient(dynamoDBStreamsClient);
    }
  }

  public async updateItem(keyName: string, keyValue: string, updateValues: Map<string, any>, tableName: string | undefined = undefined): Promise<void> {
    let dynamoDocumentClient: DynamoDBDocumentClient | undefined = undefined;

    try {
      this.logger.info('Initializing dynamoDB clients for item update.');
      dynamoDocumentClient = await this.getDynamoDocumentClient();
      this.logger.info('DynamoDB clients initialized successfully for item update.');

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
        TableName: tableName || config.databaseConfig!.tableName,
        Key: { [keyName]: keyValue },
        UpdateExpression: updateExpression,
        ExpressionAttributeNames: expressionAttributeNames,
        ExpressionAttributeValues: expressionAttributeValues,
      };

      await dynamoDocumentClient.send(new UpdateCommand(updateCommand));
      this.logger.info(`Item ${keyName} on table ${tableName || config.databaseConfig!.tableName}: Successfully updated values ${JSON.stringify(updateValues)}.`);

      this.destroyDocumentClient(dynamoDocumentClient);
    } catch (error) {
      const err: Error = error as Error;
      this.logger.error(`Error updating item with ${keyName}: ${updateValues.get(keyName)} in DynamoDB: ${err}`);

      this.destroyDocumentClient(dynamoDocumentClient);

      throw new Error(`Failed to update item: ${err.message}`);
    }
  }

  public async isDynamoActive(): Promise<boolean> {
    let dynamoDocumentClient: DynamoDBDocumentClient | undefined = undefined;

    try {
      dynamoDocumentClient = await this.getDynamoDocumentClient();

      const describeTable: DescribeTableCommand = new DescribeTableCommand({
        TableName: config.databaseConfig!.tableName,
      });

      const tableInfo: DescribeTableCommandOutput = await dynamoDocumentClient.send(describeTable);
      this.logger.info(`DynamoDB Table Status: ${tableInfo.Table?.TableStatus}`);

      if (tableInfo.Table?.TableStatus !== 'ACTIVE') {
        this.logger.error(`DynamoDB Table ${config.databaseConfig!.tableName} is not active.`);
        dynamoDocumentClient.destroy();
        return false;
      }

      this.destroyDocumentClient(dynamoDocumentClient);

      return true;
    } catch (error: Error | any) {
      this.destroyDocumentClient(dynamoDocumentClient);
      this.logger.error(`DynamoDB is not active: ${error.message}`);
      return false;
    }
  }
}

// Exporting a singleton instance of DynamoClient
export const dynamoClient: DynamoClient = new DynamoClient();
