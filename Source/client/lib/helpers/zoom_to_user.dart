import 'package:flutter/material.dart';
import 'package:flutter_grpc_client/controllers/grid_interaction_controller.dart';

import '../classes/grpc_user.dart';

void zoomToUser(GridInteractionController gridController, Size size, GrpcUser user){
  // Center the view on the user's current position
  gridController.setZoom(1.0);
  gridController.setOffset(Offset(
    size.width / 2 - user.currentX * gridController.getZoom(),
    size.height / 2 + user.currentY * gridController.getZoom(),
  ));
  gridController.clampOffsetAndZoom(size);
}