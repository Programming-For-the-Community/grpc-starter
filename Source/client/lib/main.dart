import 'package:flutter/material.dart';

import 'pages/grpc_home.dart';
import 'singletons/grpc_client.dart';
import 'singletons/logger.dart';// Import the gRPC client singleton

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures async before runApp

  await GrpcClient.init(); // Initialize gRPC client

  final logger = Logger(); // Initialize the logger
  await logger.init(); // Initialize the logger with app info

  logger.info('Application started');

  runApp(const GrpcApp());
}

class GrpcApp extends StatelessWidget {
  const GrpcApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter gRPC Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const GrpcHomePage(title: 'Flutter gRPC Home Page'),
    );
  }
}
