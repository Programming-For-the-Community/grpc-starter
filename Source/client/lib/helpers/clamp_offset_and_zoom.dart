import 'package:flutter/material.dart';

import '../singletons/app_config.dart';

Offset clampOffsetAndZoom(Offset gridOffset, Size size, double zoom) {
  final config = AppConfig();

  final gridMin = Offset(config.minGridSize, config.minGridSize);
  final gridMax = Offset(config.maxGridSize, config.maxGridSize);

  final gridWidth = (gridMax.dx - gridMin.dx) * zoom;
  final gridHeight = (gridMax.dy - gridMin.dy) * zoom;

  double offsetX, offsetY;

  if (size.width >= gridWidth) {
    offsetX = (size.width - gridWidth) / 2 - gridMin.dx * zoom;
  } else {
    final minOffsetX = size.width - gridMax.dx * zoom;
    final maxOffsetX = -gridMin.dx * zoom;
    offsetX = gridOffset.dx.clamp(minOffsetX, maxOffsetX);
  }

  if (size.height >= gridHeight) {
    offsetY = (size.height - gridHeight) / 2 - gridMin.dy * zoom;
  } else {
    final minOffsetY = size.height - gridMax.dy * zoom;
    final maxOffsetY = -gridMin.dy * zoom;
    offsetY = gridOffset.dy.clamp(minOffsetY, maxOffsetY);
  }

  return Offset(offsetX, offsetY);
}