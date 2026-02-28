import 'package:flutter/material.dart';
import 'package:flutter_grpc_client/controllers/grid_interaction_controller.dart';

import '../classes/grpc_user.dart';
import '../helpers/zoom_to_user.dart';
import '../singletons/grpc_client.dart';
import '../singletons/logger.dart';

void onTakeTrip(BuildContext context, GridInteractionController gridController, GrpcUser user) async {
  final Logger logger = Logger();
  Size size = MediaQuery.of(context).size;

  try {
    final response = await GrpcClient().takeTrip(user.username);

    // Extract path from HTTP API response
    final pathData = response['pathsTraveled'] as List? ?? [];
    if (pathData.isNotEmpty) {
      final lastPath = pathData.last as Map<String, dynamic>;
      final pathTraveled = lastPath['pathTraveled'] as List? ?? [];

      List<List<double>> pathToAdd = [];
      for (var location in pathTraveled) {
        final x = (location['x'] ?? 0).toDouble();
        final y = (location['y'] ?? 0).toDouble();
        pathToAdd.add([x, y]);
      }

      if (pathToAdd.isNotEmpty) {
        user.addPath(pathToAdd);

        final currentLocation = response['currentLocation'] as Map<String, dynamic>?;
        final endX = currentLocation?['x'] ?? pathToAdd.last[0];
        final endY = currentLocation?['y'] ?? pathToAdd.last[1];

        GrpcUser pathEndpointUser = GrpcUser(
          username: user.username,
          currentX: (endX as num).toDouble(),
          currentY: (endY as num).toDouble(),
        );

        logger.info('Trip taken for user: ${user.username} to ($endX, $endY)');
        logger.info('Trip Details: ${user.pathToShow}');

        user.showPath = true;
        user.currentX = endX.toDouble();
        user.currentY = endY.toDouble();

        // Zoom to the final location
        zoomToUser(gridController, size, pathEndpointUser);
      }
    } else {
      logger.warning('No path data in response');
    }
  } catch (e) {
    logger.error('Error taking trip: $e');
  }
}