import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../helpers/clamp_offset_and_zoom.dart';

void onPointerSignal(PointerSignalEvent event, BuildContext context, double zoom, Offset gridOffset, Function setState) {
  if (event is PointerScrollEvent) {
    final size = MediaQuery.of(context).size;
    setState(() {
      zoom = (zoom * (event.scrollDelta.dy > 0 ? 0.99 : 1.01)).clamp(0.2, 5.0);
      gridOffset = clampOffsetAndZoom(gridOffset, size, zoom);
    });
  }
}