import process from 'process';
import dotenv from 'dotenv';
import { SecretsManagerClient, GetSecretValueCommand } from '@aws-sdk/client-secrets-manager';

// Internal Imports
import { AppConfig } from '../interfaces/appInterfaces';

export class ConfigManager {
  private static instance: ConfigManager | null = null;
  private config: AppConfig | null = null;
  private initialized: boolean = false;

  private constructor() {}

  public static getInstance(): ConfigManager {
    if (!ConfigManager.instance) {
      ConfigManager.instance = new ConfigManager();
    }
    return ConfigManager.instance;
  }

  public async initialize(): Promise<AppConfig> {
    if (this.initialized && this.config) {
      return this.config;
    }

    let config: AppConfig = {};
    const isLocal: boolean = process.env.NODE_ENV !== 'AWS';

    if (isLocal) {
      // Load from local .env file
      const localConfig = dotenv.config({ path: process.env.NODE_ENV });

      if (localConfig.error) {
        throw localConfig.error;
      }

      config = localConfig.parsed || {};
    } else {
      // Load from AWS Secrets Manager
      const secretName: string | undefined = process.env.AWS_SECRET_NAME;
      const region: string | undefined = process.env.AWS_REGION;

      if (!secretName) {
        throw new Error('AWS_SECRET_NAME environment variable is not set.');
      }

      if (!region) {
        throw new Error('AWS_REGION environment variable is not set.');
      }

      const client = new SecretsManagerClient({ region: region });
      const command = new GetSecretValueCommand({ SecretId: secretName });

      try {
        const response = await client.send(command);

        if (!response.SecretString) {
          throw new Error('SecretString is empty in the retrieved secret.');
        }

        config = JSON.parse(response.SecretString);
      } catch (error: Error | any) {
        throw error;
      }
    }

    // Merge with existing environment variables (env vars take precedence)
    const mergedConfig: AppConfig = {
      ...config,
      ...(process.env.GRPC_DYNAMODB_ROLE_ARN && { GRPC_DYNAMODB_ROLE_ARN: process.env.GRPC_DYNAMODB_ROLE_ARN }),
      ...(process.env.TABLE_NAME && { TABLE_NAME: process.env.TABLE_NAME }),
      ...(process.env.TABLE_STREAM_ARN && { TABLE_STREAM_ARN: process.env.TABLE_STREAM_ARN }),
    };

    this.config = mergedConfig;
    this.initialized = true;

    return config;
  }

  public getConfig(): AppConfig {
    if (!this.initialized || !this.config) {
      throw new Error('Config not initialized. Call ConfigManager.getInstance().initialize() first.');
    }
    return this.config;
  }

  public get<K extends keyof AppConfig>(key: K): AppConfig[K] {
    return this.getConfig()[key];
  }

  public isInitialized(): boolean {
    return this.initialized;
  }
}
