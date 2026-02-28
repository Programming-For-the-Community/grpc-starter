import 'package:flutter/material.dart';

import '../singletons/app_config.dart';
import '../classes/grpc_user.dart';
import 'draw_user_bubble.dart';

void drawPath(Canvas canvas, Offset userOffset, String username, List<List<double>> path, Color color) {
  // Convert the 0-1.0 opacity to 0-255 range
  int pathOpacity = (AppConfig().pathOpacity * 255.0).round().clamp(0, 255);
  int startPointOpacity = (AppConfig().startPointOpacity * 255.0)
      .round()
      .clamp(0, 255);

  // Draw the smooth path
  Paint pathPaint = Paint()
    ..color = color.withAlpha(pathOpacity)
    ..strokeWidth = 2.0
    ..style = PaintingStyle.stroke;

  // Create a smooth path using cubic bezier curves
  Path tripPath = Path();
  if (path.length >= 2) {
    List<Offset> points = path
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

    // Create a temporary user object for the start point bubble
    GrpcUser startPointUser = GrpcUser(
      username: "$username - Path Start",
      currentX: points.first.dx,
      currentY: -points.first
          .dy, // Invert y back since the point was already inverted
    );
    startPointUser.color = color.withAlpha(startPointOpacity);

    // Create a temporary user object for the end point bubble
    GrpcUser endPointUser = GrpcUser(
      username: "$username - Path End",
      currentX: points.last.dx,
      currentY: -points.last.dy, // Invert y back
    );
    endPointUser.color = color;

    // Draw start point dot with lower opacity
    canvas.drawCircle(
        points.first,
        AppConfig().userDotRadius,
        Paint()
          ..color = color.withAlpha(startPointOpacity)
          ..style = PaintingStyle.fill
    );

    // Draw user bubble at start point with lower opacity
    drawUserBubble(canvas, points.first, startPointUser);

    // Draw user bubble at end point (normal opacity)
    drawUserBubble(canvas, points.last, endPointUser);

    // Draw end point (normal size, full opacity)
    canvas.drawCircle(
        points.last,
        AppConfig().userDotRadius,
        Paint()
          ..color = color
          ..style = PaintingStyle.fill
    );
  }
}