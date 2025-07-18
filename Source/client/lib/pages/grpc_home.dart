import 'package:flutter/material.dart';
import '../widgets/new_user_input.dart';
import '../singletons/grpc_client.dart';
import '../proto/tracker.pbgrpc.dart';
import '../singletons/logger.dart';
import '../painters/coordinate_grid_painter.dart';
import '../classes/grpc_user.dart';

class GrpcHomePage extends StatefulWidget {
  const GrpcHomePage({super.key, required this.title});

  final String title;

  @override
  State<GrpcHomePage> createState() => _GrpcHomePageState();
}

class _GrpcHomePageState extends State<GrpcHomePage> {
  Offset _gridOffset = Offset.zero;
  final List<GrpcUser> _users = [];
  GrpcUser? _selectedUser; // Track the selected user
  final List<Color> _userColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.yellow,
    Colors.cyan,
    Colors.pink,
    Colors.teal,
    Colors.lime,
  ];

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

    void startUserStream() async {
      while (true) {
        try {
          await for (RealTimeUserResponse userResponse in GrpcClient().trackerClient.getUsers(Empty())) {
            if (userResponse.status == TrackerStatus.OK) {
              setState(() {
                // Insert new user
                if (userResponse.eventType == DynamoDBEvent.EXISTING) {
                  _users.add(GrpcUser(
                    username: userResponse.userName,
                    currentX: userResponse.currentLocation.x,
                    currentY: userResponse.currentLocation.y,
                  ));

                // if existing, check if user already exists and update if it does, otherwise insert
                } else if (userResponse.eventType == DynamoDBEvent.EXISTING) {
                  final index = _users.indexWhere((user) => user.username == userResponse.userName);
                  if (index != -1) {
                    _users[index] = GrpcUser(
                      username: userResponse.userName,
                      currentX: userResponse.currentLocation.x,
                      currentY: userResponse.currentLocation.y,
                    );
                  } else {
                    _users.add(GrpcUser(
                      username: userResponse.userName,
                      currentX: userResponse.currentLocation.x,
                      currentY: userResponse.currentLocation.y,
                    ));
                  }

                // Update existing user
                } else if(userResponse.eventType == DynamoDBEvent.MODIFY) {
                  final index = _users.indexWhere((user) => user.username == userResponse.userName);
                  if (index != -1) {
                    _users[index] = GrpcUser(
                      username: userResponse.userName,
                      currentX: userResponse.currentLocation.x,
                      currentY: userResponse.currentLocation.y,
                    );
                  }

                // Delete user
                } else if(userResponse.eventType == DynamoDBEvent.REMOVE) {
                  _users.removeWhere((user) => user.username == userResponse.userName);
                }
              });
            }
          }
        } catch (e) {
          Logger().warning('Connection lost: $e. Retrying in 5 seconds...');
          await Future.delayed(Duration(seconds: 5));
        }
      }
    }

    startUserStream();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    setState(() {
      _gridOffset = Offset(
        (_gridOffset.dx + details.delta.dx).clamp(-10000.0, 10000.0),
        (_gridOffset.dy + details.delta.dy).clamp(-10000.0, 10000.0),
      );
    });
  }

  void _centerUser(GrpcUser user) {
    setState(() {
      _gridOffset = Offset(-user.currentX, user.currentY); // Center the grid on the user's location
      _selectedUser = user; // Set the selected user
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
            CustomPaint(
              size: Size.infinite,
              painter: CoordinateGridPainter(_gridOffset, _users, _userColors),
            ),
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
                          final color = _userColors[index % _userColors.length];
                          return ListTile(
                            title: Text(
                              user.username ?? 'Unknown',
                              style: TextStyle(color: color),
                            ),
                            subtitle: Text(
                              'Location: (${user.currentX}, ${user.currentY})',
                            ),
                            onTap: () => _centerUser(user), // Center the user on tap
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
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