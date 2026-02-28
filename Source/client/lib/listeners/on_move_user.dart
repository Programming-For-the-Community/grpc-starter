import 'package:flutter/material.dart';

import '../singletons/logger.dart';
import '../singletons/grpc_client.dart';
import '../classes/grpc_user.dart';
import '../controllers/grid_interaction_controller.dart';
import '../helpers/zoom_to_user.dart';

void onMoveUser(BuildContext context, GridInteractionController gridController, ValueNotifier<Map<String, GrpcUser>> users, void Function(GrpcUser) onStateChanged, GrpcUser user) async {
  final Logger logger = Logger();

  try {
    final size = MediaQuery.of(context).size;
    final response = await GrpcClient().moveUser(user.username, user.currentX, user.currentY);

    // Extract coordinates from response
    final newX = (response['location']?['x'] ?? response['x'] ?? user.currentX).toDouble();
    final newY = (response['location']?['y'] ?? response['y'] ?? user.currentY).toDouble();

    // Create a temporary user with the new position
    final movedUser = GrpcUser(
      username: user.username,
      currentX: newX,
      currentY: newY,
    );
    movedUser.color = user.color;
    movedUser.showPath = false;

    // Update the existing users map
    final updatedUsers = Map<String, GrpcUser>.from(users.value);
    updatedUsers[user.username] = movedUser;
    users.value = updatedUsers;

    logger.info('Moved user ${user.username} to ($newX, $newY)');

    // Update the selected user and zoom
    zoomToUser(gridController, size, movedUser);
    onStateChanged(movedUser);
  } catch (e) {
    logger.error('Error moving user: $e');
  }
}