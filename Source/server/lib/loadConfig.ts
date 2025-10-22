// Internal Imports
import { AppConfig } from '../interfaces/appInterfaces';
import { ConfigManager } from '../classes/configManager';
// Export singleton instance
export const configManager = ConfigManager.getInstance();

// Convenience function for backward compatibility
export async function loadEnvironment(): Promise<AppConfig> {
  return await configManager.initialize();
}
