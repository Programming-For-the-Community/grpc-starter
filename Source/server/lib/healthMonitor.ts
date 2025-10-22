import * as healthCheck from 'grpc-health-check';

// Internal Imports
import { logger } from '../classes/logger';
import { healthCheckService } from '../server';
import { serverConfig } from '../config/serverConfig';
import { dynamoClient } from './dynamoClient';

export function monitorDatabaseHealth() {
  setInterval(async () => {
    try {
      const dbHealthy: boolean = await dynamoClient.isDynamoActive();

      if (dbHealthy) {
        logger.info('Database health healthy');
        healthCheckService.setStatus('tracker.Tracker', healthCheck.servingStatus.SERVING);
      } else {
        logger.error('Database health unhealthy');
        healthCheckService.setStatus('tracker.Tracker', healthCheck.servingStatus.NOT_SERVING);
      }

      healthCheckService.setStatus('tracker.Tracker', healthCheck.servingStatus.SERVING);
    } catch (error) {
      logger.error('Server down:', error);
      healthCheckService.setStatus('', healthCheck.servingStatus.NOT_SERVING);
      healthCheckService.setStatus('tracker.Tracker', healthCheck.servingStatus.NOT_SERVING);
    }
  }, serverConfig.healthCheckIntervalMs);
}
