import 'package:flutter/material.dart';
import 'package:flutter_grpc_client/controllers/grid_interaction_controller.dart';

import '../singletons/logger.dart';
import '../classes/grpc_user.dart';
import '../proto/tracker.pbgrpc.dart';
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
    while (true) {
      try {
        await for (RealTimeUserResponse userResponse in GrpcClient().trackerClient.getUsers(Empty())) {
          if (userResponse.status == TrackerStatus.OK) {
            final GrpcUser returnedUser = GrpcUser(
              username: userResponse.userName,
              currentX: userResponse.currentLocation.x,
              currentY: userResponse.currentLocation.y,
            );
            returnedUser.color = AppConfig.userColors[colorIndex % AppConfig.userColors.length];

            if (userResponse.eventType == DynamoDBEvent.INSERT || userResponse.eventType == DynamoDBEvent.EXISTING || userResponse.eventType == DynamoDBEvent.MODIFY) {
              final updatedUsers = Map<String, GrpcUser>.from(_users.value);
              updatedUsers.update(
                userResponse.userName,
                (existing) {
                  logger.info('Updating user ${userResponse.userName} from (${existing.currentX}, ${existing.currentY}]) to (${returnedUser.currentX}, ${returnedUser.currentY})');
                  returnedUser.color = existing.color; // Preserve existing color
                  returnedUser.showPath = existing.showPath; // Preserve path visibility
                  returnedUser.pathToShow = existing.pathToShow; // Preserve path data
                  return returnedUser;
                },
                ifAbsent: () {
                  logger.info('Adding existing user: ${userResponse.userName}] at (${returnedUser.currentX}], ${returnedUser.currentY})');
                  colorIndex++;
                  return returnedUser;
                },
              );
              _users.value = updatedUsers;  // This will trigger the ValueListenable
            } else if(userResponse.eventType == DynamoDBEvent.REMOVE) {
              final updatedUsers = Map<String, GrpcUser>.from(_users.value);
              updatedUsers.remove(userResponse.userName);
              _users.value = updatedUsers;  // This will trigger the ValueListenable
              logger.info('Removed user: ${userResponse.userName}');
            }

            logger.debug('Current user count: ${_users.value.length}');
          } else {
            logger.warning('Response Status: ${userResponse.status} - ${userResponse.message}');
          }
        }
      } catch (e) {
        logger.error('Stream error: $e');
        await Future.delayed(const Duration(seconds: 5));
        logger.info('Attempting to reconnect to user stream...');
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