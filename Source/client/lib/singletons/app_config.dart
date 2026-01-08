import 'package:flutter/material.dart';

import '../classes/secrets_manager.dart';

class AppConfig {
  static final AppConfig _instance = AppConfig._internal();

  late final String appName;
  late final String appVersion;
  late final String appEnv;
  late final String serverUrl;

  late final double maxGridSize;
  late final double minGridSize;
  late final double majorGridlineSpacing;
  late final double majorGridlineWidth;
  late final double minorGridlineSpacing;
  late final double minorGridlineWidth;
  late final double originWidth;

  late final double bubbleWidth;
  late final double bubbleHeight;
  late final double bubblePadding;
  late final double bubbleOpacity;
  late final double bubbleCornerRadius;
  late final double bubbleBorderWidth;
  late final double bubbleFontSize;

  late final double tailWidth;
  late final double tailHeight;
  late final double tailShadowElevation;

  late final double pathOpacity;
  late final double startPointOpacity;

  late final double userDotRadius;

  late final double usersListDisplayWidth;
  late final double usersListButtonWidth;
  late final double usersListButtonHeight;
  late final double usersListButtonFontSize;

  late final String fontFamily;

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
    // Load in Appp Config from .env or Secrets Manager
    final Map<String, String> envConfig = await SecretsManager.loadSecrets();

    // App Settings
    _instance.appName = envConfig['APP_NAME'] ?? 'flutter-grpc-client';
    _instance.appVersion = envConfig['APP_VERSION'] ?? '1.0.0';
    _instance.appEnv = envConfig['APP_ENV'] ?? 'localhost';
    _instance.serverUrl = envConfig['SERVER_URL'] ?? 'http://0.0.0.0:8080';

    // UI Settings
    _instance.maxGridSize = double.tryParse(envConfig['MAX_GRID_SIZE'] ?? '10000.0') ?? 10000.0;
    _instance.minGridSize = double.tryParse(envConfig['MIN_GRID_SIZE'] ?? '-10000.0') ?? -10000.0;
    _instance.majorGridlineSpacing = double.tryParse(envConfig['MAJOR_GRIDLINE_SPACING'] ?? '200') ?? 200.0;
    _instance.majorGridlineWidth = double.tryParse(envConfig['MAJOR_GRIDLINE_WIDTH'] ?? '1.0') ?? 1.0;
    _instance.minorGridlineSpacing = double.tryParse(envConfig['MINOR_GRIDLINE_SPACING'] ?? '10') ?? 10.0;
    _instance.minorGridlineWidth = double.tryParse(envConfig['MINOR_GRIDLINE_WIDTH'] ?? '0.5') ?? 0.5;
    _instance.originWidth = double.tryParse(envConfig['ORIGIN_WIDTH'] ?? '2.0') ?? 2.0;

    _instance.bubbleWidth = double.tryParse(envConfig['BUBBLE_WIDTH'] ?? '140') ?? 140.0;
    _instance.bubbleHeight = double.tryParse(envConfig['BUBBLE_HEIGHT'] ?? '44') ?? 44.0;
    _instance.bubblePadding = double.tryParse(envConfig['BUBBLE_PADDING'] ?? '12') ?? 12.0;
    _instance.bubbleOpacity = double.tryParse(envConfig['BUBBLE_OPACITY'] ?? '0.85') ?? 0.85;
    _instance.bubbleCornerRadius = double.tryParse(envConfig['BUBBLE_CORNER_RADIUS'] ?? '18') ?? 18.0;
    _instance.bubbleBorderWidth = double.tryParse(envConfig['BUBBLE_BORDER_WIDTH'] ?? '1.5') ?? 1.5;
    _instance.bubbleFontSize = double.tryParse(envConfig['BUBBLE_FONT_SIZE'] ?? '15') ?? 15.0;

    _instance.tailWidth = double.tryParse(envConfig['TAIL_WIDTH'] ?? '18') ?? 18.0;
    _instance.tailHeight = double.tryParse(envConfig['TAIL_HEIGHT'] ?? '14') ?? 14.0;
    _instance.tailShadowElevation = double.tryParse(envConfig['TAIL_SHADOW_ELEVATION'] ?? '6') ?? 6.0;

    _instance.userDotRadius = double.tryParse(envConfig['USER_DOT_RADIUS'] ?? '5') ?? 5.0;

    _instance.pathOpacity = double.tryParse(envConfig['PATH_OPACITY'] ?? '0.6') ?? 0.6;
    _instance.startPointOpacity = double.tryParse(envConfig['START_POINT_OPACITY'] ?? '0.4') ?? 0.4;

    _instance.usersListDisplayWidth = double.tryParse(envConfig['USERS_LIST_DISPLAY_WIDTH'] ?? '300.0') ?? 300.0;
    _instance.usersListButtonWidth = double.tryParse(envConfig['USERS_LIST_BUTTON_WIDTH'] ?? '75.0') ?? 75.0;
    _instance.usersListButtonHeight = double.tryParse(envConfig['USERS_LIST_BUTTON_HEIGHT'] ?? '25.0') ?? 25.0;
    _instance.usersListButtonFontSize = double.tryParse(envConfig['USERS_LIST_BUTTON_FONT_SIZE'] ?? '10.0') ?? 10.0;

    _instance.fontFamily = envConfig['FONT_FAMILY'] ?? 'RobotoMono';

    // GRPC Settings
    _instance.grpcHost = envConfig['GRPC_HOST'] ?? '0.0.0.0';
    _instance.grpcPort = int.tryParse(envConfig['GRPC_PORT'] ?? '50051') ?? 50051;
    _instance.grpcSecure = envConfig['GRPC_SECURE']?.toLowerCase() == 'true';
  }

  static Map<String, dynamic> toMap() {
    return {
    'appName': _instance.appName,
    'appVersion': _instance.appVersion,
    'appEnv': _instance.appEnv,
    'appPort': _instance.serverUrl,
    'maxGridSize': _instance.maxGridSize,
    'minGridSize': _instance.minGridSize,
    'majorGridlineSpacing': _instance.majorGridlineSpacing,
    'majorGridlineWidth': _instance.majorGridlineWidth,
    'minorGridlineSpacing': _instance.minorGridlineSpacing,
    'minorGridlineWidth': _instance.minorGridlineWidth,
    'originWidth': _instance.originWidth,
    'bubbleWidth': _instance.bubbleWidth,
    'bubbleHeight': _instance.bubbleHeight,
    'bubblePadding': _instance.bubblePadding,
    'bubbleOpacity': _instance.bubbleOpacity,
    'bubbleCornerRadius': _instance.bubbleCornerRadius,
    'bubbleBorderWidth': _instance.bubbleBorderWidth,
    'bubbleFontSize': _instance.bubbleFontSize,
    'tailWidth': _instance.tailWidth,
    'tailHeight': _instance.tailHeight,
    'tailShadowElevation': _instance.tailShadowElevation,
    'pathOpacity': _instance.pathOpacity,
    'startPointOpacity': _instance.startPointOpacity,
    'userDotRadius': _instance.userDotRadius,
    'usersListDisplayWidth': _instance.usersListDisplayWidth,
    'usersListButtonWidth': _instance.usersListButtonWidth,
    'usersListButtonHeight': _instance.usersListButtonHeight,
    'usersListButtonFontSize': _instance.usersListButtonFontSize,
    'fontFamily': _instance.fontFamily,
    'grpcHost': _instance.grpcHost,
    'grpcPort': _instance.grpcPort,
    'grpcSecure': _instance.grpcSecure,
    };
  }
}