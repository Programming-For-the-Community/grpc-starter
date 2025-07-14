import 'package:flutter/material.dart';
import '../widgets/new_user_input.dart';
import '../singletons/grpc_client.dart';
import '../proto/tracker.pbgrpc.dart';
import '../singletons/logger.dart';
import '../classes/grpc_user.dart';

class CoordinateGridPainter extends CustomPainter {
  final Offset offset;
  final List<GrpcUser> users;
  final List<Color> userColors;

  CoordinateGridPainter(this.offset, this.users, this.userColors);

  @override
  void paint(Canvas canvas, Size size) {
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

    // Draw vertical lines
    for (double x = -10000; x <= 10000; x += 10) {
      final paint = (x % 200 == 0) ? darkerGridPaint : gridPaint;
      canvas.drawLine(
        Offset(x + offset.dx, -10000 + offset.dy),
        Offset(x + offset.dx, 10000 + offset.dy),
        paint,
      );
    }

    // Draw horizontal lines (invert y-axis for positive values to move up)
    for (double y = -10000; y <= 10000; y += 10) {
      final paint = (y % 200 == 0) ? darkerGridPaint : gridPaint;
      canvas.drawLine(
        Offset(-10000 + offset.dx, -y + offset.dy),
        Offset(10000 + offset.dx, -y + offset.dy),
        paint,
      );
    }

    // Draw origin crosshairs
    canvas.drawLine(
      Offset(offset.dx, -10000 + offset.dy),
      Offset(offset.dx, 10000 + offset.dy),
      originPaint,
    );
    canvas.drawLine(
      Offset(-10000 + offset.dx, offset.dy),
      Offset(10000 + offset.dx, offset.dy),
      originPaint,
    );

    // Draw user locations with their assigned colors
    for (int i = 0; i < users.length; i++) {
      final user = users[i];
      final userOffset = Offset(
        user.currentX + offset.dx,
        -user.currentY + offset.dy, // Invert y-axis
      );
      final userPaint = Paint()
        ..color = userColors[i % userColors.length]
        ..style = PaintingStyle.fill;

      canvas.drawCircle(userOffset, 5, userPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}