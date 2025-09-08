import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static final AppConfig _instance = AppConfig._internal();

  late final String appName;
  late final String appVersion;
  late final String appEnv;

  late final double maxGridSize;
  late final double minGridSize;

  late final double bubbleWidth;
  late final double bubbleHeight;
  late final double bubblePadding;
  late final double bubbleOpacity;

  late final double tailWidth;
  late final double tailHeight;

  late final String grpcHost;
  late final int grpcPort;
  late final bool grpcSecure;

  static const List<Color> userColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.yellow,
    Colors.cyan,
    Colors.pink,
    Colors.teal,
    Colors.lime,
  ];

  AppConfig._internal();

  factory AppConfig() => _instance;

  static Future<void> load() async {
    const envPath = String.fromEnvironment('ENV_PATH');

    await dotenv.load(fileName: envPath.isNotEmpty ? envPath : '.env');

    // App Settings
    _instance.appName = dotenv.env['APP_NAME'] ?? 'flutter-grpc-client';
    _instance.appVersion = dotenv.env['APP_VERSION'] ?? '1.0.0';
    _instance.appEnv = dotenv.env['APP_ENV'] ?? 'localhost';

    // UI Settings
    _instance.maxGridSize = double.tryParse(dotenv.env['MAX_GRID_SIZE'] ?? '10000.0') ?? 10000.0;
    _instance.minGridSize = double.tryParse(dotenv.env['MIN_GRID_SIZE'] ?? '-10000.0') ?? -10000.0;

    _instance.bubbleWidth = double.tryParse(dotenv.env['BUBBLE_WIDTH'] ?? '140') ?? 140.0;
    _instance.bubbleHeight = double.tryParse(dotenv.env['BUBBLE_HEIGHT'] ?? '44') ?? 44.0;
    _instance.bubblePadding = double.tryParse(dotenv.env['BUBBLE_PADDING'] ?? '12') ?? 12.0;
    _instance.bubbleOpacity = double.tryParse(dotenv.env['BUBBLE_OPACITY'] ?? '0.85') ?? 0.85;


    _instance.tailWidth = double.tryParse(dotenv.env['TAIL_WIDTH'] ?? '18') ?? 18.0;
    _instance.tailHeight = double.tryParse(dotenv.env['TAIL_HEIGHT'] ?? '14') ?? 14.0;

    // GRPC Settings
    _instance.grpcHost = dotenv.env['GRPC_HOST'] ?? 'localhost';
    _instance.grpcPort = int.tryParse(dotenv.env['GRPC_PORT'] ?? '50051') ?? 50051;
    _instance.grpcSecure = dotenv.env['GRPC_SECURE']?.toLowerCase() == 'true';
  }
}