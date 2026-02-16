import 'package:flutter/material.dart';
import 'package:flutter_grpc_client/controllers/grid_interaction_controller.dart';

import '../singletons/logger.dart';
import '../classes/grpc_user.dart';
import '../widgets/new_user_input.dart';
import '../singletons/grpc_client.dart';
import '../painters/coordinate_grid_painter.dart';
import '../widgets/existing_users.dart';
import '../singletons/app_config.dart';
import '../helpers/zoom_to_user.dart';
import '../listeners/on_move_user.dart';
import '../listeners/on_take_trip.dart';
import '../listeners/on_show_last_trip.dart';

class GrpcHomePage extends StatefulWidget {
  const GrpcHomePage({super.key, required this.title});

  final String title;

  @override
  State<GrpcHomePage> createState() => _GrpcHomePageState();
}

class _GrpcHomePageState extends State<GrpcHomePage> with WidgetsBindingObserver {
  final GridInteractionController _gridController = GridInteractionController();
  final Logger logger = Logger();
  final ValueNotifier<Map<String, GrpcUser>> _users = ValueNotifier({});
  GrpcUser? _selectedUser;

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
    _users.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    setState(() {
      _gridController.clampOffsetAndZoom(MediaQuery.of(context).size);
    });
  }

  void startUserStream() async {
    var colorIndex = 0;
    try {
      await for (Map<String, dynamic> userResponse in GrpcClient().getUsers()) {
        try {
          // Parse the user response from HTTP API
          final userName = userResponse['userName'] ?? userResponse['username'] ?? '';
          final currentX = (userResponse['currentLocation']?['x'] ?? userResponse['x'] ?? 0).toDouble();
          final currentY = (userResponse['currentLocation']?['y'] ?? userResponse['y'] ?? 0).toDouble();
          final eventType = userResponse['eventType'] ?? 'MODIFY';
          final statusCode = userResponse['status'] ?? 'OK';

          if (statusCode == 'OK') {
            final GrpcUser returnedUser = GrpcUser(
              username: userName,
              currentX: currentX,
              currentY: currentY,
            );
            returnedUser.color = AppConfig.userColors[colorIndex % AppConfig.userColors.length];

            // Handle different event types
            if (eventType == 'INSERT' || eventType == 'EXISTING' || eventType == 'MODIFY') {
              final updatedUsers = Map<String, GrpcUser>.from(_users.value);
              updatedUsers.update(
                userName,
                (existing) {
                  logger.info('Updating user $userName from (${existing.currentX}, ${existing.currentY}) to ($currentX, $currentY)');
                  returnedUser.color = existing.color;
                  returnedUser.showPath = existing.showPath;
                  returnedUser.pathToShow = existing.pathToShow;
                  return returnedUser;
                },
                ifAbsent: () {
                  logger.info('Adding existing user: $userName at ($currentX, $currentY)');
                  colorIndex++;
                  return returnedUser;
                },
              );
              _users.value = updatedUsers;
            } else if (eventType == 'REMOVE') {
              final updatedUsers = Map<String, GrpcUser>.from(_users.value);
              updatedUsers.remove(userName);
              _users.value = updatedUsers;
              logger.info('Removed user: $userName');
            }

            logger.debug('Current user count: ${_users.value.length}');
          } else {
            logger.warning('Response Status: $statusCode - ${userResponse['message']}');
          }
        } catch (e) {
          logger.error('Error processing user update: $e');
        }
      }
    } catch (e) {
      logger.error('Stream error: $e');
      // Retry stream after delay
      Future.delayed(const Duration(seconds: 5), () {
        if (mounted) {
          startUserStream();
        }
      });
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
            body: Stack(
              children: [
                // Only the grid area is wrapped with Listener for pointer signals
                Listener(
                  onPointerSignal: (event) {
                    setState(() {
                      _gridController.handlePointerSignal(event, MediaQuery.of(context).size);
                    });
                  },
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      setState(() {
                        _gridController.handleDragUpdate(details, MediaQuery.of(context).size);
                      });
                    },
                    child: ValueListenableBuilder<Map<String, GrpcUser>>(
                      valueListenable: _users,
                      builder: (context, users, _) {
                        return CustomPaint(
                          size: Size.infinite,
                          painter: CoordinateGridPainter(users, _selectedUser),
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  top: 16,
                  bottom: 16,
                  child: ValueListenableBuilder<Map<String, GrpcUser>>(
                    valueListenable: _users,
                    builder: (context, users, _) {
                      return ExistingUsers(
                        users: users,
                        onUserTap: (user) {
                          final size = MediaQuery.of(context).size;
                          setState(() {
                            zoomToUser(_gridController, size, user);
                            _selectedUser = user;
                          });
                        },
                        onTakeTrip: (user) async {
                          onTakeTrip(
                            context,
                            _gridController,
                            user
                          );

                          setState(() {
                            _selectedUser = user;
                          });
                        },
                        onShowLastTrip: (user) async {
                          onShowLastTrip(
                              context,
                              _gridController,
                              user
                          );

                          setState(() {
                            _selectedUser = user;
                          });
                        },
                        onMoveUser: (user) => onMoveUser(
                          context,
                          _gridController,
                          _users,
                          (movedUser) => setState(() {
                            _selectedUser = movedUser;
                          }),
                          user
                        ),
                      );
                    },
                  ),
                ),
                const Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: NewUserInput(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}