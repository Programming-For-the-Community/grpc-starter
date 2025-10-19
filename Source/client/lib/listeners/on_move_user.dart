import 'package:flutter/material.dart';

import '../singletons/logger.dart';
import '../proto/tracker.pbgrpc.dart';
import '../singletons/grpc_client.dart';
import '../classes/grpc_user.dart';
import '../controllers/grid_interaction_controller.dart';
import '../helpers/zoom_to_user.dart';

void onMoveUser(BuildContext context, GridInteractionController gridController, ValueNotifier<Map<String, GrpcUser>> users, void Function(GrpcUser) onStateChanged, GrpcUser user) async {
  final Logger logger = Logger();

  try {
    final size = MediaQuery.of(context).size;
    final UserResponse response = await GrpcClient().moveUser(user.username);
    if (response.status == TrackerStatus.OK) {

      // Extract coordinates from message format containing {"x":123, "y":456}
      final RegExp coordsPattern = RegExp(r':\s*(-?\d+)');
      final match = coordsPattern.allMatches(response.message);

      // Extract all matched numbers and convert to integers
      List<double> numbers = match
          .map((m) => m.group(1)!)
          .map((s) => double.parse(s))
          .toList();

      final newX = numbers[0];
      final newY = numbers[1];

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
      users.value = updatedUsers;  // This will trigger the ValueListenable

      logger.info('Moved user ${user.username} to ($newX, $newY)');

      // Update the selected user and zoom
      zoomToUser(gridController, size, movedUser);
      onStateChanged(movedUser);
    } else {
      logger.error('Failed to move user -> $response');
    }
  } catch (e) {
    logger.error('Error moving user: $e');
  }
}