import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;
import 'package:web/web.dart' as web;
import 'dart:js_interop';

import 'app_config.dart';

class Logger {
  static final Logger _instance = Logger._internal();
  late final String _appName;
  String? _serverUrl;

  Logger._internal();

  factory Logger() => _instance;

  static Future<void> init() async {
    final config = AppConfig();
    _instance._appName = '${config.appName}@${config.appVersion}';
    _instance._serverUrl = '${config.serverUrl}/logs' ?? '/api/logs';
  }

  String _getTimestamp() {
    final now = DateTime.now();
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
  }

  /// Get processor info:
  /// - Desktop/Mobile: CPU hostname
  /// - Web: 'web-client' (actual IP will be logged by server)
  String _getProcessor() {
    if (kIsWeb) {
      return 'web-client';
    } else {
      try {
        return Platform.localHostname;
      } catch (e) {
        return 'unknown-processor';
      }
    }
  }

  /// Get platform info:
  /// - Desktop/Mobile: OS name and version
  /// - Web: Browser name and version
  String _getPlatform() {
    if (kIsWeb) {
      return _getBrowserInfo();
    } else {
      try {
        return '${Platform.operatingSystem}@${Platform.operatingSystemVersion}';
      } catch (e) {
        return 'unknown-platform';
      }
    }
  }

  /// Get browser name and version for web
  String _getBrowserInfo() {
    if (!kIsWeb) return 'not-web';

    try {
      // Import window from package:web dynamically
      final userAgent = _getWebUserAgent();

      // Parse user agent to get browser info
      if (userAgent.contains('Edg/')) {
        final match = RegExp(r'Edg/([\d.]+)').firstMatch(userAgent);
        return 'Edge@${match?.group(1) ?? 'unknown'}';
      } else if (userAgent.contains('Chrome/')) {
        final match = RegExp(r'Chrome/([\d.]+)').firstMatch(userAgent);
        return 'Chrome@${match?.group(1) ?? 'unknown'}';
      } else if (userAgent.contains('Firefox/')) {
        final match = RegExp(r'Firefox/(\d+\.\d+)').firstMatch(userAgent);
        return 'Firefox@${match?.group(1) ?? 'unknown'}';
      } else if (userAgent.contains('Safari/') && !userAgent.contains('Chrome')) {
        final match = RegExp(r'Version/(\d+\.\d+)').firstMatch(userAgent);
        return 'Safari@${match?.group(1) ?? 'unknown'}';
      } else {
        return 'Unknown@0.0';
      }
    } catch (e) {
      return 'Unknown@0.0';
    }
  }

  /// Get user agent string from web platform
  String _getWebUserAgent() {
    // This will be implemented differently for web vs non-web
    return (web.window.navigator.userAgent as JSString).toDart;
  }

  void _log(String level, String message, [Object? error, StackTrace? stackTrace]) {
    final timestamp = _getTimestamp();
    final processor = _getProcessor();
    final platform = _getPlatform();
    final metadata = '[processor: $processor, platform: $platform, app: $_appName]';
    final fullMessage = '[$level] $timestamp: $metadata: $message';

    final logData = {
      'timestamp': DateTime.now().toIso8601String(),
      'level': level,
      'message': message,
      'processor': processor,
      'platform': platform,
      'app': _appName,
      'formattedMessage': fullMessage,
    };

    if (error != null) {
      logData['error'] = error.toString();
    }
    if (stackTrace != null) {
      logData['stackTrace'] = stackTrace.toString();
    }

    if (kIsWeb && _serverUrl != null) {
      // On web, send logs to server
      _sendLogToServer(logData);
      // Also log locally for debugging
      developer.log(fullMessage, name: 'flutter-logger');
    } else {
      // On desktop/mobile, log locally
      developer.log(fullMessage, name: 'flutter-logger');
      if (error != null) {
        developer.log('Error: $error', name: 'flutter-logger');
      }
      if (stackTrace != null) {
        developer.log('Stack trace: $stackTrace', name: 'flutter-logger');
      }
    }
  }

  Future<void> _sendLogToServer(Map<String, dynamic> logData) async {
    try {
      await http.post(
        Uri.parse(_serverUrl!),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(logData),
      ).timeout(const Duration(seconds: 2));
    } catch (e) {
      // Silently fail
    }
  }

  void info(String message) {
    _log('INFO', message);
  }

  void debug(String message) {
    _log('DEBUG', message);
  }

  void warning(String message) {
    _log('WARNING', message);
  }

  void error(String message, [Object? error, StackTrace? stackTrace]) {
    _log('ERROR', message, error, stackTrace);
  }
}