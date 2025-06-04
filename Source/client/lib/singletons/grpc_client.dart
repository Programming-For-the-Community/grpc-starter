import 'package:grpc/grpc.dart';
import '../proto/tracker.pbgrpc.dart';

class GrpcClient {
  static final GrpcClient _instance = GrpcClient._internal();

  late final ClientChannel _channel;
  late final TrackerClient trackerClient;

  GrpcClient._internal();

  factory GrpcClient() => _instance;

  static Future<void> init() async {
    _instance._channel = ClientChannel(
      'localhost',
      port: 50051,
      options: const ChannelOptions(
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
}
