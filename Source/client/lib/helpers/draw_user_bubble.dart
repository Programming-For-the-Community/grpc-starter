import 'package:flutter/material.dart';

import '../classes/grpc_user.dart';
import '../singletons/app_config.dart';

void drawUserBubble(Canvas canvas, Offset userOffset, GrpcUser user) {
  AppConfig appConfig = AppConfig();

  // Convert the 0-1.0 opacity to 0-255 range
  int bubbleOpacity = (appConfig.bubbleOpacity * 255.0).round().clamp(0, 255).toInt();

  Rect bubbleRect = Rect.fromLTWH(
    userOffset.dx - appConfig.bubbleWidth / 2,
    userOffset.dy - appConfig.bubbleHeight - appConfig.tailHeight - 8,
    appConfig.bubbleWidth,
    appConfig.bubbleHeight,
  );

  // Use the user color as the base for the bubble gradient
  LinearGradient bubbleGradient = LinearGradient(
    colors: [Colors.white, user.color.withAlpha(bubbleOpacity)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Tail points
  Offset tailTip = Offset(userOffset.dx, userOffset.dy - 5);
  Offset tailLeft = Offset(userOffset.dx - appConfig.tailWidth / 2, bubbleRect.bottom);
  Offset tailRight = Offset(userOffset.dx + appConfig.tailWidth / 2, bubbleRect.bottom);

  // Draw tail (filled, no border)
  Path tailPath = Path()
    ..moveTo(tailTip.dx, tailTip.dy)
    ..lineTo(tailLeft.dx, tailLeft.dy)
    ..lineTo(tailRight.dx, tailRight.dy)
    ..close();

  Paint tailPaint = Paint()..shader = bubbleGradient.createShader(bubbleRect);
  canvas.drawShadow(tailPath, Colors.black26, 6, false);
  canvas.drawPath(tailPath, tailPaint);

  // Draw bubble (filled)
  RRect rrect = RRect.fromRectAndRadius(bubbleRect, Radius.circular(18));

  Paint bubblePaint = Paint()..shader = bubbleGradient.createShader(bubbleRect);

  canvas.drawShadow(Path()..addRRect(rrect), Colors.black26, 6, false);
  canvas.drawRRect(rrect, bubblePaint);

  // Border paint
  Paint borderPaint = Paint()
    ..color = user.color
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.5;

  // 1. Draw the border for the rounded rectangle, skipping the bottom edge between tailLeft and tailRight
  Path borderPath = Path();
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
  Path tailBorderPath = Path()
    ..moveTo(tailLeft.dx, tailLeft.dy)
    ..lineTo(tailTip.dx, tailTip.dy)
    ..lineTo(tailRight.dx, tailRight.dy);
  canvas.drawPath(tailBorderPath, borderPaint);

  // Draw text (coordinates)
  TextSpan textSpan = TextSpan(
    text: '(${user.currentX.toStringAsFixed(2)}, ${user.currentY.toStringAsFixed(2)})',
    style: TextStyle(
      color: Colors.blueGrey[900],
      fontSize: 15,
      fontWeight: FontWeight.w600,
      fontFamily: 'RobotoMono',
    ),
  );
  TextPainter tp = TextPainter(
    text: textSpan,
    textAlign: TextAlign.center,
    textDirection: TextDirection.ltr,
  );
  tp.layout(maxWidth: appConfig.bubbleWidth - 2 * appConfig.bubblePadding);
  tp.paint(
    canvas,
    Offset(
      bubbleRect.left + (appConfig.bubbleWidth - tp.width) / 2,
      bubbleRect.top + (appConfig.bubbleHeight - tp.height) / 2,
    ),
  );
}