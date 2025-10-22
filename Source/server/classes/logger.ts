// External Imports
import log4js from 'log4js';
import os from 'os';
import util from 'util';

// Internal Imports
import { loggerConfig } from '../config/loggerConfig';
import { serverConfig } from '../config/serverConfig';

log4js.addLayout('custom', () => {
  return (logEvent) => {
    const timestamp = new Date(logEvent.startTime).toISOString().replace('T', ' ').split('.')[0];
    return util.format(loggerConfig.format, logEvent.level.levelStr, timestamp, os.hostname(), os.platform(), os.release(), serverConfig.appName, serverConfig.appVersion, logEvent.data.join(' '));
  };
});

log4js.configure({
  appenders: {
    console: {
      type: 'console',
      layout: {
        type: 'custom',
      },
    },
  },
  categories: {
    default: { appenders: ['console'], level: loggerConfig.level },
  },
});

export const logger = log4js.getLogger();
logger.level = loggerConfig.level;

logger.debug(`Logger Config: ${JSON.stringify(loggerConfig)}`);
