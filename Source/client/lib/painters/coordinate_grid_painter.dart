import 'package:flutter/material.dart';
import 'package:flutter_grpc_client/helpers/draw_user_bubble.dart';

import '../controllers/grid_interaction_controller.dart';
import '../classes/grpc_user.dart';
import '../singletons/app_config.dart';
import '../helpers/draw_path.dart';

class CoordinateGridPainter extends CustomPainter {
  final Map<String, GrpcUser> users;
  final GrpcUser? selectedUser;
  final gridController = GridInteractionController();
  AppConfig appConfig = AppConfig();

  CoordinateGridPainter(this.users, this.selectedUser);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(gridController.getOffset().dx, gridController.getOffset().dy);
    canvas.scale(gridController.getZoom());

    // Paint for regular grid lines
    final minorGridlinePaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = appConfig.minorGridlineWidth;

    // Paint for darker grid lines every 200 units
    final majorGridlinePaint = Paint()

      ..color = Colors.grey[700]!
      ..strokeWidth = appConfig.majorGridlineWidth;

    // Paint for origin crosshairs
    final originPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = appConfig.originWidth;

    // Draw vertical grid lines
    for (double x = appConfig.minGridSize; x <= appConfig.maxGridSize; x += appConfig.minorGridlineSpacing) {
      final paint = (x % appConfig.majorGridlineSpacing == 0) ? majorGridlinePaint : minorGridlinePaint;
      canvas.drawLine(
        Offset(x, appConfig.minGridSize),
        Offset(x, appConfig.maxGridSize),
        paint,
      );
    }

    // Draw horizontal grid lines (invert y-axis)
    for (double y = appConfig.minGridSize; y <= appConfig.maxGridSize; y += appConfig.minorGridlineSpacing) {
      final paint = (y % appConfig.majorGridlineSpacing == 0) ? majorGridlinePaint : minorGridlinePaint;
      canvas.drawLine(
        Offset(appConfig.minGridSize, -y),
        Offset(appConfig.maxGridSize, -y),
        paint,
      );
    }

    // Draw origin crosshairs
    canvas.drawLine(
      Offset(0, appConfig.minGridSize),
      Offset(0, appConfig.maxGridSize),
      originPaint,
    );
    canvas.drawLine(
      Offset(appConfig.minGridSize, 0),
      Offset(appConfig.maxGridSize, 0),
      originPaint,
    );

    // Draw user locations
    users.values.forEach( (user) {
      if(selectedUser != null && user.username != selectedUser!.username && user.showPath) { user.showPath = false; }

      Offset userOffset = Offset(
        user.currentX,
        -user.currentY, // Invert y-axis
      );
      Paint userPaint = Paint()
        ..color = user.color
        ..style = PaintingStyle.fill;

      // Draw the path if showPath is true and user has paths
      if (user.showPath) {
        if (user.pathToShow.isNotEmpty) {
          drawPath(canvas, userOffset, user.username, user.pathToShow, user.color);
        }
      }

      canvas.drawCircle(userOffset, appConfig.userDotRadius, userPaint);

      if (selectedUser != null && user.username == selectedUser!.username && !user.showPath) {
        drawUserBubble(canvas, userOffset, user);
      }
    });

    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}