// Internal Imports
import { Logger } from '../singletons/logger';
import { config } from '../server';
import { dynamoClient } from '../singletons/dynamoClient';
import { ServingStatus } from '../protoFunctions/health/healthService';

export function monitorDatabaseHealth() {
  const logger: Logger = Logger.get();

  setInterval(async () => {
    try {
      const dbHealthy: boolean = await dynamoClient.isDynamoActive();

      if (dbHealthy) {
        logger.info('Database health healthy');
        config.healthCheckService!.setStatus('tracker.Tracker', ServingStatus.SERVING);
      } else {
        logger.error('Database health unhealthy');
        config.healthCheckService!.setStatus('tracker.Tracker', ServingStatus.NOT_SERVING);
      }

      config.healthCheckService!.setStatus('', ServingStatus.SERVING);
    } catch (error) {
      logger.error('Server down:', error);
      config.healthCheckService!.setStatus('', ServingStatus.NOT_SERVING);
      config.healthCheckService!.setStatus('tracker.Tracker', ServingStatus.NOT_SERVING);
    }
  }, config.serverConfig!.healthCheckIntervalMs);
}
