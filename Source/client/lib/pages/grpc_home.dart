import 'package:flutter/gestures.dart';
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

class _GrpcHomePageState extends State<GrpcHomePage> with WidgetsBindingObserver {
  Offset _gridOffset = Offset.zero;
  final Logger logger = Logger();
  final Map<String, GrpcUser> _users = {};
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

  // In _GrpcHomePageState
  double _zoom = 1.0;

  void _onScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      _zoom = (_zoom * details.scale).clamp(0.2, 5.0);
    });
  }

  // Update your clamp function to accept a size
  void _clampOffsetAndZoom(Size size) {
    const gridMin = Offset(-10000, -10000);
    const gridMax = Offset(10000, 10000);

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

  void _onPointerSignal(PointerSignalEvent event) {
    if (event is PointerScrollEvent) {
      final size = MediaQuery.of(context).size;
      setState(() {
        final oldZoom = _zoom;
        _zoom = (_zoom * (event.scrollDelta.dy > 0 ? 0.99 : 1.01)).clamp(0.2, 5.0);
        // Optionally, adjust offset to zoom around the mouse pointer
        _clampOffsetAndZoom(size);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      setState(() {
        // Center (0,0) on the screen
        _gridOffset = Offset(size.width / 2, size.height / 2);
      });
    });

    startUserStream();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final size = MediaQuery.of(context).size;
    setState(() {
      _clampOffsetAndZoom(size);
    });
  }

  void startUserStream() async {
    while (true) {
      try {
        await for (RealTimeUserResponse userResponse in GrpcClient().trackerClient.getUsers(Empty())) {
          if (userResponse.status == TrackerStatus.OK) {
            GrpcUser returnedUser = GrpcUser(
              username: userResponse.userName,
              currentX: userResponse.currentLocation.x,
              currentY: userResponse.currentLocation.y,
            );

            setState(() {
              // Insert new user
              if (userResponse.eventType == DynamoDBEvent.INSERT) {
                _users[userResponse.userName] = returnedUser;

                // if existing, check if user already exists and update if it does, otherwise insert
              } else if (userResponse.eventType == DynamoDBEvent.EXISTING || userResponse.eventType == DynamoDBEvent.MODIFY) {
                _users.update(userResponse.userName, (existing) => returnedUser, ifAbsent: () => returnedUser);

                // Delete user
              } else if(userResponse.eventType == DynamoDBEvent.REMOVE) {
                _users.remove(userResponse.userName);
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

  void _onDragUpdate(DragUpdateDetails details) {
    final size = MediaQuery.of(context).size;
    setState(() {
      _gridOffset += details.delta;
      _clampOffsetAndZoom(size);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final size = Size(constraints.maxWidth, constraints.maxHeight);
            setState(() {
              _clampOffsetAndZoom(size);
            });
          });
          return Scaffold(
            appBar: AppBar(title: Text(widget.title)),
            body: Listener(
              onPointerSignal: _onPointerSignal,
              child: GestureDetector(
                onPanUpdate: _onDragUpdate,
                child: Stack(
                  children: [
                    CustomPaint(
                      size: Size.infinite,
                      painter: CoordinateGridPainter(
                          _gridOffset, _users, _userColors, _selectedUser,
                          _zoom),
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
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .titleMedium,
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: _users.length,
                                  itemBuilder: (context, index) {
                                    final user = _users.values.elementAt(index);
                                    final color = _userColors[index % _userColors.length];
                                    return ListTile(
                                      title: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            user.username ?? 'Unknown',
                                            style: TextStyle(color: color),
                                          ),
                                          Text(
                                            'Location: (${user.currentX}, ${user.currentY})',
                                            style: Theme.of(context).textTheme.bodySmall,
                                          ),
                                          SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    // TODO: Implement Take Trip action
                                                  },
                                                  child: Text('Take Trip'),
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              Expanded(
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    // TODO: Implement Show Last Trip action
                                                  },
                                                  child: Text('Show Last Trip'),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      trailing: IconButton(
                                        icon: Icon(Icons.directions),
                                        tooltip: 'Move User',
                                        onPressed: () async {
                                          try {
                                            final response = await GrpcClient().moveUser(user.username);
                                            if (response.status == TrackerStatus.OK) {
                                              logger.info(response.message);
                                            } else {
                                              logger.error('Failed to move user -> $response}');
                                            }
                                          } catch (e) {
                                            logger.error('Error moving user: $e');
                                          }
                                        },
                                      ),
                                      onTap: () {
                                        final size = MediaQuery.of(context).size;
                                        setState(() {
                                          _zoom = 1.0;
                                          _gridOffset = Offset(
                                            size.width / 2 - user.currentX * _zoom,
                                            size.height / 2 + user.currentY * _zoom,
                                          );
                                          _clampOffsetAndZoom(size);
                                          _selectedUser = user;
                                        });
                                      },
                                    );
                                  }
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
            ),
          );
        });
  }
}