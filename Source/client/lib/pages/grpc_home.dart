import 'package:flutter/gestures.dart';
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

            // Set User Paths Traveled if available
            if (userResponse.user.pathsTraveled.isNotEmpty) {

            }

            if (userResponse.eventType == DynamoDBEvent.INSERT) {
              _users.value[userResponse.userName] = returnedUser;
              colorIndex++;
              logger.info('New user added: ${userResponse.userName} at (${returnedUser.currentX}, ${returnedUser.currentY})');
            } else if (userResponse.eventType == DynamoDBEvent.EXISTING || userResponse.eventType == DynamoDBEvent.MODIFY) {
              _users.value.update(
                userResponse.userName,
                (existing) {
                  logger.info('Updating user ${userResponse.userName} from (${existing.currentX}, ${existing.currentY}]) to (${returnedUser.currentX}, ${returnedUser.currentY})');
                  returnedUser.color = existing.color; // Preserve existing color
                  return returnedUser;
                },
                ifAbsent: () {
                  logger.info('Adding existing user: ${userResponse.userName}] at (${returnedUser.currentX}], ${returnedUser.currentY})');
                  colorIndex++;
                  return returnedUser;
                },
              );
            } else if(userResponse.eventType == DynamoDBEvent.REMOVE) {
              _users.value.remove(userResponse.userName);
              logger.info('Removed user: ${userResponse.userName}');
            }
            logger.debug('Current user count: ${_users.value.length}');
            _users.notifyListeners();
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
                          UserResponse response = await GrpcClient().takeTrip(user.username);

                          if (response.status == TrackerStatus.OK) {
                            logger.info('Trip taken for user: ${user.username} to (${response.user.currentLocation.x}, ${response.user.currentLocation.y})');
                            logger.info('Trip Details: ${response.user.pathsTraveled[response.user.pathsTraveled.length - 1]}');

                            setState(() {
                              _selectedUser = user;
                              user.showPath = true;
                            });

                          } else {
                            logger.warning('Response Status: ${response.status} - ${response.message}');
                          }
                        },
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