class GrpcUser {
  String username;
  double currentX;
  double currentY;
  Map<int, List<List<double>>> pathsTraveled;

  GrpcUser({
    required this.username,
    required this.currentX,
    required this.currentY,
  }) : pathsTraveled = {};

  void addPath(int pathId, List<List<double>> coordinates) {
    pathsTraveled.putIfAbsent(pathId, () => coordinates);
  }
}