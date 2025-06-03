import 'package:flutter/material.dart';
import 'proto/tracker.pbgrpc.dart';
import 'package:grpc/grpc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter gRPC Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter gRPC Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _grpcResponse = 'No response yet'; // Display gRPC response

  // gRPC Client
  late final TrackerClient _client;
  late final ClientChannel _channel;

  @override
  void initState() {
    super.initState();
    // Initialize the gRPC channel and client
    _channel = ClientChannel(
      'localhost', // Replace with your server's address
      port: 50051, // Replace with your server's port
      options: const ChannelOptions(
        credentials: ChannelCredentials.insecure(),
      ),
    );
    _client = TrackerClient(_channel);
  }

  @override
  void dispose() {
    // Close the gRPC channel when the widget is disposed
    _channel.shutdown();
    super.dispose();
  }

  Future<void> _callGrpcMethod() async {
    try {
      // Replace 'YourRequest' and 'yourRpcMethod' with actual generated method and request
      final response = await _client.createUser(Username(name: 'Hello from Flutter!'));
      setState(() {
        _grpcResponse = response.message; // Update the response message
      });
    } catch (e) {
      setState(() {
        _grpcResponse = 'Error: $e'; // Handle errors
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'gRPC Response:',
            ),
            Text(
              _grpcResponse,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _callGrpcMethod, // Call the gRPC method when the button is pressed
        tooltip: 'Call gRPC',
        child: const Icon(Icons.add),
      ),
    );
  }
}
