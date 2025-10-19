import 'package:flutter/material.dart';
import 'package:flutter_grpc_client/controllers/grid_interaction_controller.dart';

import '../classes/grpc_user.dart';
import '../helpers/zoom_to_user.dart';
import '../proto/tracker.pb.dart';
import '../singletons/grpc_client.dart';
import '../singletons/logger.dart';

void onTakeTrip(BuildContext context, GridInteractionController gridController, GrpcUser user) async {
  final Logger logger = Logger();
  Size size = MediaQuery.of(context).size;
  UserResponse response = await GrpcClient().takeTrip(user.username);

  if (response.status == TrackerStatus.OK) {
    var path = response.user.pathsTraveled[response.user.pathsTraveled.length - 1];

    List<List<double>> pathToAdd = [];

    for (var location in path!.pathTraveled) {
      pathToAdd.add([location.x, location.y]);
    }

    user.addPath(pathToAdd);

    GrpcUser pathEndpointUser = GrpcUser(
      username: user.username,
      currentX: pathToAdd.last[0],
      currentY: pathToAdd.last[1],
    );

    logger.info('Trip taken for user: ${user.username} to (${response.user.currentLocation.x}, ${response.user.currentLocation.y})');
    logger.info('Trip Details: ${user.pathToShow}');

    user.showPath = true;

    // Update user's current position to the end of the path
    user.currentX = pathToAdd.last[0];
    user.currentY = pathToAdd.last[1];

    user.showPath = true;

    // Update user's current position to the end of the path
    user.currentX = pathToAdd.last[0];
    user.currentY = pathToAdd.last[1];

    // Zoom to the final location
    zoomToUser(gridController, size, pathEndpointUser);

  } else {
    logger.warning('Response Status: ${response.status} - ${response.message}');
  }
}