import path from 'path';
import { format } from 'util';
import winston from 'winston';

import { LoggerConfig } from '../interfaces/loggerInterfaces';

export class Logger {
  private static instance: Logger | undefined;
  private logger: winston.Logger;
  private consoleTransport: winston.transports.ConsoleTransportInstance;

  private constructor() {
    // Create console transport that we can update later
    this.consoleTransport = new winston.transports.Console({
      format: winston.format.combine(winston.format.colorize(), winston.format.simple()),
    });

    // Create logger with basic default configuration
    this.logger = winston.createLogger({
      level: 'info',
      format: winston.format.combine(winston.format.timestamp(), winston.format.simple()),
      transports: [this.consoleTransport],
    });
  }

  public static get(): Logger {
    if (!Logger.instance) {
      Logger.instance = new Logger();
    }
    return Logger.instance;
  }

  public setFormat(config: LoggerConfig): void {
    // Remove the old transport
    this.logger.clear();

    // Create new format
    const customFormat = winston.format.combine(
      winston.format.timestamp(),
      winston.format.colorize(), // Colorize first
      winston.format.printf(({ level, message, timestamp, file, ...metadata }) => {
        // level is already colored and uppercased by colorize()
        let msg = format(config.format, level, timestamp, config.processor, config.platform, config.release, config.app, config.version, file, message);

        if (Object.keys(metadata).length > 0) {
          msg += ' ' + JSON.stringify(metadata);
        }
        return msg;
      }),
    );

    // Add new transport with custom format
    this.consoleTransport = new winston.transports.Console({
      format: customFormat,
    });

    this.logger.add(this.consoleTransport);
  }

  public info(message: string, meta?: any): void {
    const file = this.getCallerFile();
    this.logger.info(message, { ...meta, file });
  }

  public error(message: string, meta?: any): void {
    const file = this.getCallerFile();
    this.logger.error(message, { ...meta, file });
  }

  public warn(message: string, meta?: any): void {
    const file = this.getCallerFile();
    this.logger.warn(message, { ...meta, file });
  }

  public debug(message: string, meta?: any): void {
    const file = this.getCallerFile();
    this.logger.debug(message, { ...meta, file });
  }

  private getCallerFile(): string {
    const originalFunc = Error.prepareStackTrace;

    try {
      const err = new Error();
      Error.prepareStackTrace = (_, stack) => stack;

      const stack = err.stack as unknown as NodeJS.CallSite[];

      // Stack: [0] = getCallerFile, [1] = info/error/etc, [2] = actual caller
      const callerFile = stack[2].getFileName();

      if (callerFile) {
        return path.basename(callerFile);
      }
      return 'unknown';
    } finally {
      Error.prepareStackTrace = originalFunc;
    }
  }
}
