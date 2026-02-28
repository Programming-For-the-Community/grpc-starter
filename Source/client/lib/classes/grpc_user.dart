import 'package:flutter/material.dart';

class GrpcUser {
  String username;
  double currentX;
  double currentY;
  List<List<double>> pathToShow;
  late Color color;
  bool showPath = false;

  GrpcUser({
    required this.username,
    required this.currentX,
    required this.currentY,
  }) : pathToShow = [];

  void addPath(List<List<double>> coordinates) {
    pathToShow = coordinates;
  }
}