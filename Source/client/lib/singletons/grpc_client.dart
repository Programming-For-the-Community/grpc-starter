import '../services/tracker_api_service.dart';
import '../singletons/logger.dart';

class GrpcClient {
  static final GrpcClient _instance = GrpcClient._internal();
  late TrackerApiService _apiService;
  late Logger _logger;

  GrpcClient._internal();

  factory GrpcClient() => _instance;

  static Future<void> init() async {
    _instance._logger = Logger();
    _instance._apiService = TrackerApiService();

    try {
      await _instance._apiService.init();
      _instance._logger.info('[GRPC] gRPC client initialized (using HTTP API gateway)');
    } catch (e) {
      _instance._logger.error('[GRPC] Failed to initialize gRPC client: $e');
      rethrow;
    }
  }

  TrackerApiService get apiService => _apiService;

  Future<Map<String, dynamic>> createUser(String username) async {
    try {
      _logger.info('[GRPC] createUser called with username: $username');
      final result = await _apiService.createUser(username);
      _logger.info('[GRPC] createUser completed successfully');
      return result;
    } catch (e) {
      _logger.error('[GRPC] createUser failed: $e');
      throw Exception('Failed to create user: $e');
    }
  }

  Future<Map<String, dynamic>> moveUser(String username, double x, double y) async {
    try {
      return await _apiService.moveUser(username, x, y);
    } catch (e) {
      throw Exception('Failed to move user: $e');
    }
  }

  Future<Map<String, dynamic>> takeTrip(String username) async {
    try {
      return await _apiService.takeTrip(username);
    } catch (e) {
      throw Exception('Failed to take trip: $e');
    }
  }

  Future<Map<String, dynamic>> getUser(String username) async {
    try {
      return await _apiService.getUser(username);
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  // Return stream of users
  Stream<Map<String, dynamic>> getUsers() {
    return _apiService.getUsers();
  }

  // Get users via polling (fallback)
  Future<List<Map<String, dynamic>>> getUsersPolling() async {
    try {
      return await _apiService.getUsersPolling();
    } catch (e) {
      throw Exception('Failed to get users: $e');
    }
  }
}
