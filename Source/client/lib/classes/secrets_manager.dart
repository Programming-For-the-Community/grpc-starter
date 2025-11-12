import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:aws_secretsmanager_api/secretsmanager-2017-10-17.dart' as aws_sm;

class SecretsManager {
  static Future<Map<String, String>> loadSecrets() async {
    // Check if running in AWS environment
    const env = String.fromEnvironment('FLUTTER_ENV', defaultValue: "local");

    const isAwsEnv = env == 'AWS';

    if (isAwsEnv) {
      return await _loadFromAwsSecretsManager();
    } else {
      return await _loadFromEnvFile();
    }
  }

  static Future<Map<String, String>> _loadFromAwsSecretsManager() async {
    try {
      const region = String.fromEnvironment('AWS_REGION', defaultValue: 'us-east-2');
      const secretName = String.fromEnvironment('FLUTTER_SECRET', defaultValue: 'flutter-app-secrets');

      // Create Secrets Manager client
      // When running in ECS with an execution role, the SDK automatically
      // retrieves credentials from the ECS task metadata endpoint
      final secretsManagerClient = aws_sm.SecretsManager(
        region: region,
      );

      final response = await secretsManagerClient.getSecretValue(
        secretId: secretName,
      );

      if (response.secretString != null && response.secretString!.isNotEmpty) {
        final Map<String, dynamic> secrets = jsonDecode(response.secretString!);

        // Load in specific env values not in secrets manager
        secrets['GRPC_HOST'] = const String.fromEnvironment('GRPC_HOST', defaultValue: 'localhost');
        secrets['APP_VERSION'] = const String.fromEnvironment('APP_VERSION', defaultValue: '1.0.0');
        secrets['SERVER_URL'] = const String.fromEnvironment('SERVER_URL', defaultValue: 'localhost');

        return secrets.map((key, value) => MapEntry(key, value.toString()));
      }

      throw Exception('Secret string is null or empty');
    } catch (e) {
      // Fallback to .env file on error
      return await _loadFromEnvFile();
    }
  }

  static Future<Map<String, String>> _loadFromEnvFile() async {
    try {
      const envPath = String.fromEnvironment('ENV_PATH', defaultValue: '.env.dev');
      final fileName = envPath.isNotEmpty ? envPath : '.env.dev';
      await dotenv.load(fileName: fileName);
      return dotenv.env;
    } catch (e) {
      return {};
    }
  }
}