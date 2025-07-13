import { STSClient, AssumeRoleCommand } from '@aws-sdk/client-sts';

import { databaseConfig } from '../config/databaseConfig';

export const getAssumedRoleCredentials = async () => {
  const stsClient = new STSClient({ region: databaseConfig.awsRegion });
  const assumeRoleCommand = new AssumeRoleCommand({
    RoleArn: databaseConfig.grpcDynamoDBRoleArn,
    RoleSessionName: 'grpcDynamoSession',
  });

  const response = await stsClient.send(assumeRoleCommand);
  return {
    accessKeyId: response.Credentials?.AccessKeyId || '',
    secretAccessKey: response.Credentials?.SecretAccessKey || '',
    sessionToken: response.Credentials?.SessionToken || '',
  };
};
