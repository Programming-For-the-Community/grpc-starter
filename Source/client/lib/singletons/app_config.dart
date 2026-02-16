import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
    // App Settings
    _instance.appName = const String.fromEnvironment('APP_NAME',
        defaultValue: 'flutter-grpc-client');
    _instance.appVersion =
        const String.fromEnvironment('APP_VERSION', defaultValue: '1.0.0');
    _instance.appEnv =
        const String.fromEnvironment('APP_ENV', defaultValue: 'localhost');
    // SERVER_URL can be set via build-time environment variable
    // Default to 0.0.0.0:8080 for local development (servers listen on 0.0.0.0 but clients connect to 0.0.0.0)
    _instance.serverUrl = const String.fromEnvironment('SERVER_URL',
        defaultValue: 'http://localhost:8081');

    // UI Settings
    _instance.maxGridSize = 10000.0;
    _instance.minGridSize = -10000.0;
    _instance.majorGridlineSpacing = 200.0;
    _instance.majorGridlineWidth = 1.0;
    _instance.minorGridlineSpacing = 10.0;
    _instance.minorGridlineWidth = 0.5;
    _instance.originWidth = 2.0;

    _instance.bubbleWidth = 140.0;
    _instance.bubbleHeight = 44.0;
    _instance.bubblePadding = 12.0;
    _instance.bubbleOpacity = 0.85;
    _instance.bubbleCornerRadius = 18.0;
    _instance.bubbleBorderWidth = 1.5;
    _instance.bubbleFontSize = 15.0;

    _instance.tailWidth = 18.0;
    _instance.tailHeight = 14.0;
    _instance.tailShadowElevation = 6.0;

    _instance.userDotRadius = 5.0;

    _instance.pathOpacity = 0.6;
    _instance.startPointOpacity = 0.4;

    _instance.usersListDisplayWidth = 300.0;
    _instance.usersListButtonWidth = 75.0;
    _instance.usersListButtonHeight = 25.0;
    _instance.usersListButtonFontSize = 10.0;

    _instance.fontFamily = 'RobotoMono';
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
    };
  }
}
