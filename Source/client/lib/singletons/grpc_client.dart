import 'package:grpc/grpc.dart';

import 'app_config.dart';
import '../proto/tracker.pbgrpc.dart';

class GrpcClient {
  static final GrpcClient _instance = GrpcClient._internal();

  late final ClientChannel _channel;
  late final TrackerClient trackerClient;

  GrpcClient._internal();

  factory GrpcClient() => _instance;

  static Future<void> init() async {
    final config = AppConfig();

    _instance._channel = ClientChannel(
      config.grpcHost,
      port: config.grpcPort,
      options: ChannelOptions(
        credentials: ChannelCredentials.insecure(),
      ),
    );
    _instance.trackerClient = TrackerClient(_instance._channel);
  }

  Future<void> shutdown() async {
    await _channel.shutdown();
  }

  Future<UserResponse> createUser(String username) async {
    final request = Username(name: username);

    try {
      final response = await trackerClient.createUser(request);

      return response;
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }

  }

  Future<UserResponse> moveUser(String username) async {
    final request = Username(name: username);

    try {
      final response = await trackerClient.moveUser(request);

      return response;
    } catch (e) {
      throw Exception('Failed to move user: $e');
    }
  }

  Future<UserResponse> takeTrip(String username) async {
    final request = Username(name: username);

    try {
      final response = await trackerClient.takeTrip(request);

      return response;
    } catch (e) {
      throw Exception('Failed to take trip: $e');
    }
  }

  Future<UserResponse> getUser(String username) async {
    final request = Username(name: username);

    try {
      final response = await trackerClient.getUser(request);

      return response;
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }
}
