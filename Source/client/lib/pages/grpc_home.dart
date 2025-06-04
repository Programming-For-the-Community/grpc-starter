import 'package:flutter/material.dart';
import '../widgets/new_user_input.dart';

class GrpcHomePage extends StatefulWidget {
  const GrpcHomePage({super.key, required this.title});

  final String title;

  @override
  State<GrpcHomePage> createState() => _GrpcHomePageState();
}

class _GrpcHomePageState extends State<GrpcHomePage> {
  Offset _gridOffset = Offset.zero;

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
            // Overlay layout
            Row(
              children: [
                // Left column for listing users
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'Users',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: 10, // Replace with actual user count
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text('User $index'), // Replace with actual user data
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
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