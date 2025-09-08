import 'package:flutter/material.dart';
import 'package:flutter_grpc_client/helpers/draw_user_bubble.dart';

import '../controllers/grid_interaction_controller.dart';
import '../classes/grpc_user.dart';
import '../singletons/app_config.dart';

class CoordinateGridPainter extends CustomPainter {
  final Map<String, GrpcUser> users;
  final GrpcUser? selectedUser;
  final gridController = GridInteractionController();

  CoordinateGridPainter(this.users, this.selectedUser);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(gridController.getOffset().dx, gridController.getOffset().dy);
    canvas.scale(gridController.getZoom());

    // Paint for regular grid lines
    final gridPaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 0.5;

    // Paint for darker grid lines every 200 units
    final darkerGridPaint = Paint()
      ..color = Colors.grey[700]!
      ..strokeWidth = 1.0;

    // Paint for origin crosshairs
    final originPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0;

    // Draw vertical grid lines
    for (double x = -10000; x <= 10000; x += 10) {
      final paint = (x % 200 == 0) ? darkerGridPaint : gridPaint;
      canvas.drawLine(
        Offset(x, -10000),
        Offset(x, 10000),
        paint,
      );
    }

    // Draw horizontal grid lines (invert y-axis)
    for (double y = -10000; y <= 10000; y += 10) {
      final paint = (y % 200 == 0) ? darkerGridPaint : gridPaint;
      canvas.drawLine(
        Offset(-10000, -y),
        Offset(10000, -y),
        paint,
      );
    }

    // Draw origin crosshairs
    canvas.drawLine(
      Offset(0, -10000),
      Offset(0, 10000),
      originPaint,
    );
    canvas.drawLine(
      Offset(-10000, 0),
      Offset(10000, 0),
      originPaint,
    );

    // Draw user locations
    for (int i = 0; i < users.length; i++) {
      final user = users.values.elementAt(i);
      final userOffset = Offset(
        user.currentX,
        -user.currentY, // Invert y-axis
      );
      final userPaint = Paint()
        ..color = user.color
        ..style = PaintingStyle.fill;

      canvas.drawCircle(userOffset, 5, userPaint);

      if (selectedUser != null && user.username == selectedUser!.username) {
        drawUserBubble(canvas, userOffset, user);
      }
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}