import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;

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
    _instance._serverUrl = '${config.serverUrl}/logs' ?? '/logs';

    // Log the configured server URL for debugging
    developer.log('[Logger] Server URL configured: ${config.serverUrl}', name: 'flutter-logger');
    developer.log('[Logger] Logs endpoint: ${_instance._serverUrl}', name: 'flutter-logger');
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
      // For web builds, return a generic identifier
      // Browser info is not critical for logging
      return 'web-browser@unknown';
    } catch (e) {
      return 'unknown-platform';
    }
  }

  /// Get user agent string from web platform (fallback for non-web)
  String _getWebUserAgent() {
    // This method is kept for compatibility but not used
    // since we removed the web package dependency
    return 'unknown';
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