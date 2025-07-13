import 'package:flutter/material.dart';
import '../widgets/new_user_input.dart';
import '../singletons/grpc_client.dart';
import '../proto/tracker.pbgrpc.dart';

class GrpcHomePage extends StatefulWidget {
  const GrpcHomePage({super.key, required this.title});

  final String title;

  @override
  State<GrpcHomePage> createState() => _GrpcHomePageState();
}

class _GrpcHomePageState extends State<GrpcHomePage> {
  Offset _gridOffset = Offset.zero;
  final List<RealTimeUserResponse> _users = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      setState(() {
        // Center (0,0) on the screen
        _gridOffset = Offset(size.width / 2, size.height / 2);
      });
    });

    // Start listening to the real-time user stream
    GrpcClient().trackerClient.getUsers(Empty()).listen((userResponse) {
      if (userResponse.status == TrackerStatus.OK) {
        setState(() {
          _users.add(userResponse);
        });
      }
    });
  }

  void _onDragUpdate(DragUpdateDetails details) {
    setState(() {
      // Update offset while clamping within ±10,000 pixels
      _gridOffset = Offset(
        (_gridOffset.dx + details.delta.dx).clamp(-10000.0, 10000.0),
        (_gridOffset.dy + details.delta.dy).clamp(-10000.0, 10000.0),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: GestureDetector(
        onPanUpdate: _onDragUpdate,
        child: Stack(
          children: [
            // Draggable grid background
            CustomPaint(
              size: Size.infinite,
              painter: CoordinateGridPainter(_gridOffset),
            ),
            // Floating scrollable box for users
            Positioned(
              left: 16,
              top: 16,
              bottom: 16,
              child: Container(
                width: 250,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Available Users',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _users.length,
                        itemBuilder: (context, index) {
                          final user = _users[index];
                          return ListTile(
                            title: Text(user.userName ?? 'Unknown'),
                            subtitle: Text(
                              'Location: (${user.currentLocation?.x ?? 0}, ${user.currentLocation?.y ?? 0})',
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Overlay layout
            Row(
              children: [
                // Right section for NewUserInput
                Expanded(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: NewUserInput(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CoordinateGridPainter extends CustomPainter {
  final Offset offset;

  CoordinateGridPainter(this.offset);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 0.5;

    // Draw vertical lines
    for (double x = -10000; x <= 10000; x += 10) {
      canvas.drawLine(
        Offset(x + offset.dx, -10000 + offset.dy),
        Offset(x + offset.dx, 10000 + offset.dy),
        paint,
      );
    }

    // Draw horizontal lines
    for (double y = -10000; y <= 10000; y += 10) {
      canvas.drawLine(
        Offset(-10000 + offset.dx, y + offset.dy),
        Offset(10000 + offset.dx, y + offset.dy),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}