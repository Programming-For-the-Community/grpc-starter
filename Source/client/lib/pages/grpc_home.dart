import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grpc_client/controllers/grid_interaction_controller.dart';

import '../singletons/logger.dart';
import '../classes/grpc_user.dart';
import '../proto/tracker.pbgrpc.dart';
import '../widgets/new_user_input.dart';
import '../singletons/grpc_client.dart';
import '../helpers/clamp_offset_and_zoom.dart';
import '../painters/coordinate_grid_painter.dart';
import '../widgets/existing_users.dart';
import '../singletons/app_config.dart';

class GrpcHomePage extends StatefulWidget {
  const GrpcHomePage({super.key, required this.title});

  final String title;

  @override
  State<GrpcHomePage> createState() => _GrpcHomePageState();
}

class _GrpcHomePageState extends State<GrpcHomePage> with WidgetsBindingObserver {
  final GridInteractionController _gridController = GridInteractionController();
  final Logger logger = Logger();
  final Map<String, GrpcUser> _users = {};
  GrpcUser? _selectedUser; // Track the selected user

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _gridController.setInitState(MediaQuery.of(context).size);
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
    setState(() {
      _gridController.clampOffsetAndZoom(MediaQuery.of(context).size);
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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final size = Size(constraints.maxWidth, constraints.maxHeight);
            setState(() {
              _gridController.clampOffsetAndZoom(size);
            });
          });
          return Scaffold(
            appBar: AppBar(title: Text(widget.title)),
            body: Listener(
              onPointerSignal: (event) {
                    _gridController.handlePointerSignal(event, MediaQuery.of(context).size);
              },
              child: GestureDetector(
                onPanUpdate: (details) {
                  _gridController.handleDragUpdate(details, MediaQuery.of(context).size);
                },
                child: Stack(
                  children: [
                    CustomPaint(
                      size: Size.infinite,
                      painter: CoordinateGridPainter(_users, _selectedUser),
                    ),
                    Positioned(
                      left: 16,
                      top: 16,
                      bottom: 16,
                      child: ExistingUsers(
                        users: _users,
                        onUserTap: (user) {
                          final size = MediaQuery.of(context).size;
                          setState(() {
                            _gridController.setZoom(1.0);
                            _gridController.setOffset(Offset(
                              size.width / 2 - user.currentX * _gridController.getZoom(),
                              size.height / 2 + user.currentY * _gridController.getZoom(),
                            ));
                            _gridController.clampOffsetAndZoom(size);
                            _selectedUser = user;
                          });
                        },
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