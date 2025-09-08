import 'package:flutter/material.dart';

import 'pages/grpc_home.dart';
import 'singletons/grpc_client.dart';
import 'singletons/logger.dart';
import 'singletons/app_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures async before runApp

  await AppConfig.load(); // Get AppConfig instance

  await Logger.init(); // Initialize the logger with app info

  await GrpcClient.init(); // Initialize gRPC client

  Logger().info('Application started');

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
