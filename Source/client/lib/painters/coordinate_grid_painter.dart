import 'package:flutter/material.dart';
import '../widgets/new_user_input.dart';
import '../singletons/grpc_client.dart';
import '../singletons/logger.dart';
import '../classes/grpc_user.dart';
import 'dart:math';

class CoordinateGridPainter extends CustomPainter {
  final Offset offset;
  final Map<String, GrpcUser> users;
  final List<Color> userColors;
  final GrpcUser? selectedUser;
  final double zoom;

  CoordinateGridPainter(this.offset, this.users, this.userColors, this.selectedUser, this.zoom);

  @override
  void paint(Canvas canvas, Size size) {
    final scale = 1 / pow(zoom, 1);
    canvas.save();
    canvas.translate(offset.dx, offset.dy);
    canvas.scale(zoom);

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
        ..color = userColors[i % userColors.length]
        ..style = PaintingStyle.fill;

      canvas.drawCircle(userOffset, 5, userPaint);

      if (selectedUser != null && user.username == selectedUser!.username) {
        _drawChatBubble(canvas, userOffset, user, userColors[i % userColors.length], scale);
      }
    }

    canvas.restore();
  }

  void _drawChatBubble(Canvas canvas, Offset userOffset, GrpcUser user, Color color, num scale) {
    final bubbleWidth = 140.0 * scale;
    final bubbleHeight = 44.0 * scale;
    final bubblePadding = 12.0 * scale;
    final tailWidth = 18.0 * scale;
    final tailHeight = 14.0 * scale;

    final bubbleRect = Rect.fromLTWH(
      userOffset.dx - bubbleWidth / 2,
      userOffset.dy - bubbleHeight - tailHeight - 8,
      bubbleWidth,
      bubbleHeight,
    );

    // Use the user color as the base for the gradient
    final gradient = LinearGradient(
      colors: [Colors.white, color.withOpacity(0.85)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    // Tail points
    final tailTip = Offset(userOffset.dx, userOffset.dy - 5);
    final tailLeft = Offset(userOffset.dx - tailWidth / 2, bubbleRect.bottom);
    final tailRight = Offset(userOffset.dx + tailWidth / 2, bubbleRect.bottom);

    // Draw tail (filled, no border)
    final tailPath = Path()
      ..moveTo(tailTip.dx, tailTip.dy)
      ..lineTo(tailLeft.dx, tailLeft.dy)
      ..lineTo(tailRight.dx, tailRight.dy)
      ..close();
    final tailPaint = Paint()..shader = gradient.createShader(bubbleRect);
    canvas.drawShadow(tailPath, Colors.black26, 6, false);
    canvas.drawPath(tailPath, tailPaint);

    // Draw bubble (filled)
    final rrect = RRect.fromRectAndRadius(bubbleRect, Radius.circular(18));
    final bubblePaint = Paint()..shader = gradient.createShader(bubbleRect);
    canvas.drawShadow(Path()..addRRect(rrect), Colors.black26, 6, false);
    canvas.drawRRect(rrect, bubblePaint);

    // Border paint
    final borderPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // 1. Draw the border for the rounded rectangle, skipping the bottom edge between tailLeft and tailRight
    final borderPath = Path();
    borderPath.moveTo(bubbleRect.left + 0, bubbleRect.top + 18);
    borderPath.arcToPoint(
      Offset(bubbleRect.left + 18, bubbleRect.top),
      radius: Radius.circular(18),
      clockwise: true,
    );
    borderPath.lineTo(bubbleRect.right - 18, bubbleRect.top);
    borderPath.arcToPoint(
      Offset(bubbleRect.right, bubbleRect.top + 18),
      radius: Radius.circular(18),
      clockwise: true,
    );
    borderPath.lineTo(bubbleRect.right, bubbleRect.bottom - 18);
    borderPath.arcToPoint(
      Offset(bubbleRect.right - 18, bubbleRect.bottom),
      radius: Radius.circular(18),
      clockwise: true,
    );
    borderPath.lineTo(tailRight.dx, tailRight.dy);
    borderPath.moveTo(tailLeft.dx, tailLeft.dy);
    borderPath.lineTo(bubbleRect.left + 18, bubbleRect.bottom);
    borderPath.arcToPoint(
      Offset(bubbleRect.left, bubbleRect.bottom - 18),
      radius: Radius.circular(18),
      clockwise: true,
    );
    borderPath.lineTo(bubbleRect.left, bubbleRect.top + 18);

    canvas.drawPath(borderPath, borderPaint);

    // 2. Draw the border for the two sides of the tail (not the base)
    final tailBorderPath = Path()
      ..moveTo(tailLeft.dx, tailLeft.dy)
      ..lineTo(tailTip.dx, tailTip.dy)
      ..lineTo(tailRight.dx, tailRight.dy);
    canvas.drawPath(tailBorderPath, borderPaint);

    // Draw text (coordinates)
    final textSpan = TextSpan(
      text: '(${user.currentX.toStringAsFixed(2)}, ${user.currentY.toStringAsFixed(2)})',
      style: TextStyle(
        color: Colors.blueGrey[900],
        fontSize: 15,
        fontWeight: FontWeight.w600,
        fontFamily: 'RobotoMono',
      ),
    );
    final tp = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    tp.layout(maxWidth: bubbleWidth - 2 * bubblePadding);
    tp.paint(
      canvas,
      Offset(
        bubbleRect.left + (bubbleWidth - tp.width) / 2,
        bubbleRect.top + (bubbleHeight - tp.height) / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}