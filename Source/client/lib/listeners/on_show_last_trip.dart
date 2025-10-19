import 'package:flutter/material.dart';
import 'package:flutter_grpc_client/controllers/grid_interaction_controller.dart';

import '../classes/grpc_user.dart';
import '../helpers/zoom_to_user.dart';
import '../proto/tracker.pb.dart';
import '../singletons/grpc_client.dart';
import '../singletons/logger.dart';

void onShowLastTrip(BuildContext context, GridInteractionController gridController, GrpcUser user) async {
  final Logger logger = Logger();
  Size size = MediaQuery.of(context).size;
  UserResponse response = await GrpcClient().getUser(user.username);

  if (response.status == TrackerStatus.OK) {
    if (response.user.pathsTraveled.isNotEmpty) {
      var path = response.user.pathsTraveled[response.user.pathsTraveled.length - 1];

      List<List<double>> pathToShow = [];

      for (var location in path!.pathTraveled) {
        pathToShow.add([location.x, location.y]);
      }

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

    } else {
      logger.info('No trips found for user: ${user.username}');
    }
  } else {
    logger.warning('Response Status: ${response.status} - ${response.message}');
  }
}