import 'package:flutter/material.dart';

import '../classes/grpc_user.dart';
import '../singletons/app_config.dart';

void drawUserBubble(Canvas canvas, Offset userOffset, GrpcUser user) {
  AppConfig appConfig = AppConfig();

  // Convert the 0-1.0 opacity to 0-255 range
  int bubbleOpacity = (appConfig.bubbleOpacity * 255.0).round().clamp(0, 255).toInt();
  int offsetFromUser = 18;
  double tailTipUserOffset = 5;

  // Bubble rectangle (above the user position)
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
  Offset tailTip = Offset(userOffset.dx, userOffset.dy - tailTipUserOffset);
  Offset tailLeft = Offset(userOffset.dx - appConfig.tailWidth / 2, bubbleRect.bottom);
  Offset tailRight = Offset(userOffset.dx + appConfig.tailWidth / 2, bubbleRect.bottom);

  // Draw tail (filled, no border)
  Path tailPath = Path()
    ..moveTo(tailTip.dx, tailTip.dy)
    ..lineTo(tailLeft.dx, tailLeft.dy)
    ..lineTo(tailRight.dx, tailRight.dy)
    ..close();

  Paint tailPaint = Paint()..shader = bubbleGradient.createShader(bubbleRect);

  canvas.drawShadow(tailPath, Colors.black26, appConfig.tailShadowElevation, false);
  canvas.drawPath(tailPath, tailPaint);

  // Draw bubble as rounded rectangle (filled)
  Radius bubbleRadius = Radius.circular(appConfig.bubbleCornerRadius);
  RRect roundedRect = RRect.fromRectAndRadius(bubbleRect, bubbleRadius);

  Paint bubblePaint = Paint()..shader = bubbleGradient.createShader(bubbleRect);

  canvas.drawShadow(Path()..addRRect(roundedRect), Colors.black26, 6, false);
  canvas.drawRRect(roundedRect, bubblePaint);

  // Border paint
  Paint borderPaint = Paint()
    ..color = user.color
    ..style = PaintingStyle.stroke
    ..strokeWidth = appConfig.bubbleBorderWidth;

  // 1. Draw the border for the rounded rectangle, skipping the bottom edge between tailLeft and tailRight
  Path borderPath = Path();
  borderPath.moveTo(bubbleRect.left + 0, bubbleRect.top + offsetFromUser);
  borderPath.arcToPoint(
    Offset(bubbleRect.left + offsetFromUser, bubbleRect.top),
    radius: bubbleRadius,
    clockwise: true,
  );
  borderPath.lineTo(bubbleRect.right - offsetFromUser, bubbleRect.top);
  borderPath.arcToPoint(
    Offset(bubbleRect.right, bubbleRect.top + offsetFromUser),
    radius: bubbleRadius,
    clockwise: true,
  );
  borderPath.lineTo(bubbleRect.right, bubbleRect.bottom - offsetFromUser);
  borderPath.arcToPoint(
    Offset(bubbleRect.right - offsetFromUser, bubbleRect.bottom),
    radius: bubbleRadius,
    clockwise: true,
  );
  borderPath.lineTo(tailRight.dx, tailRight.dy);
  borderPath.moveTo(tailLeft.dx, tailLeft.dy);
  borderPath.lineTo(bubbleRect.left + offsetFromUser, bubbleRect.bottom);
  borderPath.arcToPoint(
    Offset(bubbleRect.left, bubbleRect.bottom - offsetFromUser),
    radius: bubbleRadius,
    clockwise: true,
  );
  borderPath.lineTo(bubbleRect.left, bubbleRect.top + offsetFromUser);

  canvas.drawPath(borderPath, borderPaint);

  // 2. Draw the border for the two sides of the tail (not the base)
  Path tailBorderPath = Path()
    ..moveTo(tailLeft.dx, tailLeft.dy)
    ..lineTo(tailTip.dx, tailTip.dy)
    ..lineTo(tailRight.dx, tailRight.dy);
  canvas.drawPath(tailBorderPath, borderPaint);

  // Draw text (coordinates)
  TextSpan textSpan = TextSpan(
    text: '${user.username}\n(${user.currentX.toStringAsFixed(2)}, ${user.currentY.toStringAsFixed(2)})',
    style: TextStyle(
      color: Colors.black,
      fontSize: appConfig.bubbleFontSize,
      fontWeight: FontWeight.w600,
      fontFamily: appConfig.fontFamily,
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