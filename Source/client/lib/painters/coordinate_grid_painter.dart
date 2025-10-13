import 'package:flutter/material.dart';
import 'package:flutter_grpc_client/helpers/draw_user_bubble.dart';

import '../controllers/grid_interaction_controller.dart';
import '../classes/grpc_user.dart';
import '../singletons/app_config.dart';
import '../helpers/zoom_to_user.dart';

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
      if(selectedUser != null && user.username != selectedUser!.username && user.showPath) { user.showPath = false; } // Ensure that we are only going to show the path for the selected user

      Offset userOffset = Offset(
        user.currentX,
        -user.currentY, // Invert y-axis
      );
      Paint userPaint = Paint()
        ..color = user.color
        ..style = PaintingStyle.fill;

      // Draw the path if showPath is true and user has paths
      if (user.showPath && user.pathsTraveled.isNotEmpty) {
        final lastPath = user.pathsTraveled[user.pathsTraveled.length - 1];

        if (lastPath != null && lastPath.isNotEmpty) {
          // Draw the smooth path
          Paint pathPaint = Paint()
            ..color = user.color.withOpacity(0.6)
            ..strokeWidth = 2.0
            ..style = PaintingStyle.stroke;

          // Create a smooth path using cubic bezier curves
          Path tripPath = Path();
          if (lastPath.length >= 2) {
            List<Offset> points = lastPath
                .where((point) => point.length >= 2)
                .map((point) => Offset(point[0], -point[1]))
                .toList();

            // Start at the first point
            tripPath.moveTo(points.first.dx, points.first.dy);

            // If we only have 2 points, draw a straight line
            if (points.length == 2) {
              tripPath.lineTo(points.last.dx, points.last.dy);
            } else {
              // For more than 2 points, create a smooth curve
              for (int i = 0; i < points.length - 2; i++) {
                final p0 = points[i];
                final p1 = points[i + 1];
                final p2 = points[i + 2];

                // Calculate control points for smooth curve
                final controlPoint1 = Offset(
                  p0.dx + (p1.dx - p0.dx) * 0.5,
                  p0.dy + (p1.dy - p0.dy) * 0.5,
                );
                final controlPoint2 = Offset(
                  p1.dx + (p2.dx - p1.dx) * 0.5,
                  p1.dy + (p2.dy - p1.dy) * 0.5,
                );

                tripPath.cubicTo(
                  controlPoint1.dx, controlPoint1.dy,
                  controlPoint2.dx, controlPoint2.dy,
                  p1.dx, p1.dy,
                );

                // If this is the second-to-last iteration, connect to the final point
                if (i == points.length - 3) {
                  tripPath.lineTo(points.last.dx, points.last.dy);
                }
              }
            }

            // Draw the path
            canvas.drawPath(tripPath, pathPaint);

            // Draw start and end point dots
            Paint endPointPaint = Paint()
              ..color = user.color
              ..style = PaintingStyle.fill;

            // Start point (larger, more transparent)
            canvas.drawCircle(
              points.first,
              appConfig.userDotRadius * 1.5,
              endPointPaint..color = user.color.withOpacity(0.4)
            );

            // End point (normal size, solid)
            canvas.drawCircle(
              points.last,
              appConfig.userDotRadius,
              endPointPaint..color = user.color
            );

            // If this is the selected user, zoom to the final location
            if (selectedUser != null && user.username == selectedUser!.username) {
              final lastPoint = lastPath.last;
              if (lastPoint.length >= 2) {
                zoomToUser(gridController, size, user);
              }
            }
          }
        }
      }

      canvas.drawCircle(userOffset, appConfig.userDotRadius, userPaint);

      if (selectedUser != null && user.username == selectedUser!.username) {
        drawUserBubble(canvas, userOffset, user);
      }
    });

    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}