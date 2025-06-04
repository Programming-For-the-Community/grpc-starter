import 'dart:developer';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Logger {
  static final Logger _instance = Logger._internal();
  late final String _appName;

  Logger._internal();

  factory Logger() => _instance;

  Future<void> init() async {
    final packageInfo = await PackageInfo.fromPlatform();
    _appName = '${packageInfo.appName}@${packageInfo.version}';
  }

  String _getTimestamp() {
    final now = DateTime.now();
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
  }

  String _getProcessor() {
    return Platform.localHostname;
  }

  String _getPlatform() {
    return '${Platform.operatingSystem}@${Platform.operatingSystemVersion}';
  }

  void _log(String level, String message) {
    final timestamp = _getTimestamp();
    final metadata = '[processor: ${_getProcessor()}, platform: ${_getPlatform()}, app: $_appName]';
    log('[$level] $timestamp: $metadata: $message', name: 'flutter-logger');
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
    _log('ERROR', message);
  }
}