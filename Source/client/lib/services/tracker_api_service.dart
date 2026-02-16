import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import '../singletons/app_config.dart';
import '../singletons/logger.dart';

class TrackerApiService {
  static final TrackerApiService _instance = TrackerApiService._internal();
  late String _baseUrl;
  late Logger _logger;

  TrackerApiService._internal();

  factory TrackerApiService() => _instance;

  Future<void> init() async {
    _logger = Logger();
    _baseUrl = '${AppConfig().serverUrl}/api/tracker';
    _logger.info('[API] Tracker API initialized at: $_baseUrl');
  }

  // Get users - returns a stream of user updates via SSE
  Stream<Map<String, dynamic>> getUsers() async* {
    try {
      _logger.info('[API] Starting user stream subscription');

      final client = http.Client();
      final request = http.Request('GET', Uri.parse('${_baseUrl.replaceAll('/api/tracker', '')}/api/tracker/subscribe-users'));
      request.headers['Accept'] = 'text/event-stream';
      request.headers['Connection'] = 'keep-alive';
      request.headers['Cache-Control'] = 'no-cache';

      try {
        final response = await client.send(request);

        if (response.statusCode != 200) {
          final errorBody = await response.stream.bytesToString();
          throw Exception('Failed to subscribe to users: ${response.statusCode} - $errorBody');
        }

        _logger.info('[API] SSE stream connected, listening for updates');

        // Buffer to accumulate partial chunks
        String buffer = '';

        // Listen to the streaming response
        await for (var chunk in response.stream.transform(utf8.decoder)) {
          // Add new chunk to buffer
          buffer += chunk;

          // Process complete lines (ending with \n)
          final lines = buffer.split('\n');

          // Keep the last incomplete line in the buffer
          buffer = lines.last;

          // Process all complete lines
          for (var i = 0; i < lines.length - 1; i++) {
            final line = lines[i].trim();

            // Skip empty lines and comments (keepalive)
            if (line.isEmpty || line.startsWith(':')) {
              continue;
            }

            if (line.startsWith('data: ')) {
              final jsonStr = line.substring(6).trim();
              if (jsonStr.isNotEmpty && jsonStr != '{}') {
                try {
                  final data = jsonDecode(jsonStr);
                  _logger.debug('[API] Received user update: ${data['userName'] ?? data['username'] ?? 'unknown'}');
                  yield data;
                } catch (e) {
                  _logger.error('[API] Error parsing user data: $e - Raw: $jsonStr');
                }
              }
            } else if (line.startsWith('event: ')) {
              final eventType = line.substring(7).trim();
              if (eventType == 'error') {
                _logger.error('[API] Received error event from server');
              }
            }
          }
        }

        _logger.info('[API] SSE stream ended normally');
      } finally {
        client.close();
      }
    } catch (e) {
      _logger.error('[API] User stream error: $e');
      rethrow;
    }
  }

  // Get users (polling fallback)
  Future<List<Map<String, dynamic>>> getUsersPolling() async {
    try {
      final response = await http.post(
        Uri.parse('${_baseUrl}/get-users'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({}),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final users = data['users'] as List? ?? [];
        return users.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to get users: ${response.statusCode}');
      }
    } catch (e) {
      _logger.error('[API] Get users error: $e');
      rethrow;
    }
  }

  // Create user
  Future<Map<String, dynamic>> createUser(String username) async {
    try {
      _logger.info('[API] Creating user: $username');
      _logger.info('[API] Using base URL: $_baseUrl');
      final endpoint = '$_baseUrl/create-user';
      _logger.info('[API] Full endpoint: $endpoint');

      final response = await http.post(
        Uri.parse(endpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username}),
      ).timeout(const Duration(seconds: 10));

      _logger.info('[API] Response status code: ${response.statusCode}');
      _logger.info('[API] Response body: ${response.body}');

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        _logger.info('[API] User created successfully: $result');
        return result;
      } else {
        final errorMsg = 'Failed to create user: ${response.statusCode} - ${response.body}';
        _logger.error('[API] $errorMsg');
        throw Exception(errorMsg);
      }
    } catch (e) {
      _logger.error('[API] Create user error: $e');
      rethrow;
    }
  }

  // Move user
  Future<Map<String, dynamic>> moveUser(String username, double x, double y) async {
    try {
      _logger.info('[API] Moving user $username to ($x, $y)');

      final response = await http.post(
        Uri.parse('$_baseUrl/move-user'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'x': x, 'y': y}),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to move user: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      _logger.error('[API] Move user error: $e');
      rethrow;
    }
  }

  // Take trip
  Future<Map<String, dynamic>> takeTrip(String username) async {
    try {
      _logger.info('[API] Taking trip for user: $username');

      final response = await http.post(
        Uri.parse('$_baseUrl/take-trip'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username}),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to take trip: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      _logger.error('[API] Take trip error: $e');
      rethrow;
    }
  }

  // Get user
  Future<Map<String, dynamic>> getUser(String username) async {
    try {
      _logger.info('[API] Getting user: $username');

      final response = await http.post(
        Uri.parse('$_baseUrl/get-user'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username}),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get user: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      _logger.error('[API] Get user error: $e');
      rethrow;
    }
  }

  // Generic gRPC proxy call
  Future<Map<String, dynamic>> callGrpcMethod({
    required String service,
    required String method,
    required Map<String, dynamic> body,
  }) async {
    try {
      _logger.info('[API] Calling $service.$method');

      final response = await http.post(
        Uri.parse('${_baseUrl.replaceAll('/api/tracker', '')}/api/grpc/$service/$method'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('gRPC call failed: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      _logger.error('[API] gRPC call error: $e');
      rethrow;
    }
  }
}