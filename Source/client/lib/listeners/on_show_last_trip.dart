import 'package:flutter/material.dart';
import 'package:flutter_grpc_client/controllers/grid_interaction_controller.dart';

import '../classes/grpc_user.dart';
import '../helpers/zoom_to_user.dart';
import '../singletons/grpc_client.dart';
import '../singletons/logger.dart';

void onShowLastTrip(BuildContext context, GridInteractionController gridController, GrpcUser user) async {
  final Logger logger = Logger();
  Size size = MediaQuery.of(context).size;

  try {
    final response = await GrpcClient().getUser(user.username);

    final pathsTraveled = response['pathsTraveled'] as List? ?? [];
    if (pathsTraveled.isNotEmpty) {
      final lastPath = pathsTraveled.last as Map<String, dynamic>;
      final pathTraveled = lastPath['pathTraveled'] as List? ?? [];

      List<List<double>> pathToShow = [];
      for (var location in pathTraveled) {
        final x = (location['x'] ?? 0).toDouble();
        final y = (location['y'] ?? 0).toDouble();
        pathToShow.add([x, y]);
      }

      if (pathToShow.isNotEmpty) {
        user.pathToShow = pathToShow;

        GrpcUser pathEndpointUser = GrpcUser(
          username: user.username,
          currentX: pathToShow.last[0],
          currentY: pathToShow.last[1],
        );

        logger.info('Showing last trip for user: ${user.username}');
        logger.info('Trip Details: ${user.pathToShow}');

        user.showPath = true;

        // Zoom to the final location
        zoomToUser(gridController, size, pathEndpointUser);
      }
    } else {
      logger.info('No trips found for user: ${user.username}');
    }
  } catch (e) {
    logger.error('Error showing last trip: $e');
  }
}