import { STSClient, AssumeRoleCommand } from '@aws-sdk/client-sts';

import { config } from '../server';

export const getAssumedRoleCredentials = async () => {
  const stsClient = new STSClient({ region: config.databaseConfig!.awsRegion });
  const assumeRoleCommand = new AssumeRoleCommand({
    RoleArn: config.databaseConfig!.grpcDynamoDBRoleArn,
    RoleSessionName: 'grpcDynamoSession',
  });

  const response = await stsClient.send(assumeRoleCommand);
  return {
    accessKeyId: response.Credentials?.AccessKeyId || '',
    secretAccessKey: response.Credentials?.SecretAccessKey || '',
    sessionToken: response.Credentials?.SessionToken || '',
  };
};
