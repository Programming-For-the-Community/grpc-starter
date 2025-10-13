import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import '../singletons/app_config.dart';

class GridInteractionController extends ChangeNotifier {
  static final GridInteractionController _instance = GridInteractionController._internal();

  GridInteractionController._internal();

  factory GridInteractionController() => _instance;

  Offset _gridOffset = Offset.zero;
  double _zoom = 1.0;
  final config = AppConfig();

  double getZoom() => _zoom;
  Offset getOffset() => _gridOffset;

  void setZoom(double zoom) => _zoom = zoom;
  void setOffset(Offset offset) => _gridOffset = offset;

  void handlePointerSignal(PointerSignalEvent event, Size screenSize) {
    if (event is PointerScrollEvent) {
      // Convert vertical scroll to zoom
      double zoomDelta = event.scrollDelta.dy < 0 ? 1.1 : 0.9;

      // Calculate zoom center point
      Offset zoomCenter = event.position;
      Offset oldOffset = zoomCenter - _gridOffset;
      Offset newOffset = oldOffset * zoomDelta;

      _zoom = (_zoom * zoomDelta).clamp(0.2, 5.0);
      _gridOffset += oldOffset - newOffset;

      clampOffsetAndZoom(screenSize);
      notifyListeners();
    }
  }

  void handleDragUpdate(DragUpdateDetails details, Size screenSize) {
    _gridOffset += details.delta;
    clampOffsetAndZoom(screenSize);
    notifyListeners();
  }

  void setInitState(Size screenSize) {
    _gridOffset = Offset(screenSize.width / 2, screenSize.height / 2);
    notifyListeners();
  }

  void clampOffsetAndZoom(Size size) {
    final config = AppConfig();

    final gridMin = Offset(config.minGridSize, config.minGridSize);
    final gridMax = Offset(config.maxGridSize, config.maxGridSize);

    final gridWidth = (gridMax.dx - gridMin.dx) * _zoom;
    final gridHeight = (gridMax.dy - gridMin.dy) * _zoom;

    double offsetX, offsetY;

    if (size.width >= gridWidth) {
      offsetX = (size.width - gridWidth) / 2 - gridMin.dx * _zoom;
    } else {
      final minOffsetX = size.width - gridMax.dx * _zoom;
      final maxOffsetX = -gridMin.dx * _zoom;
      offsetX = _gridOffset.dx.clamp(minOffsetX, maxOffsetX);
    }

    if (size.height >= gridHeight) {
      offsetY = (size.height - gridHeight) / 2 - gridMin.dy * _zoom;
    } else {
      final minOffsetY = size.height - gridMax.dy * _zoom;
      final maxOffsetY = -gridMin.dy * _zoom;
      offsetY = _gridOffset.dy.clamp(minOffsetY, maxOffsetY);
    }

    _gridOffset = Offset(offsetX, offsetY);
  }
}