import 'package:flutter/material.dart';

import '../classes/grpc_user.dart';
import '../singletons/grpc_client.dart';
import '../singletons/logger.dart';
import '../proto/tracker.pbgrpc.dart';
import '../singletons/app_config.dart';

class AvailableUser extends StatelessWidget {
  final GrpcUser user;
  final VoidCallback onTap;
  final VoidCallback onTakeTrip;
  final VoidCallback onShowLastTrip;
  final VoidCallback onMoveUser;

  const AvailableUser({
    super.key,
    required this.user,
    required this.onTap,
    required this.onTakeTrip,
    required this.onShowLastTrip,
    required this.onMoveUser
  });

  @override
  Widget build(BuildContext context) {
    final Logger logger = Logger();
    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            user.username!!,
            style: TextStyle(color: user.color),
          ),
          Text(
            'Location: (${user.currentX}, ${user.currentY})',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  width: AppConfig().usersListButtonWidth,
                  height: AppConfig().usersListButtonHeight,
                  child: ElevatedButton(
                    onPressed: onTakeTrip,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero, // Remove default padding
                    ),
                    child: Center(
                      child: Text(
                        'Take Trip',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: AppConfig().usersListButtonFontSize,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SizedBox(
                  width: AppConfig().usersListButtonWidth,
                  height: AppConfig().usersListButtonHeight,
                  child: ElevatedButton(
                    onPressed: onShowLastTrip,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero, // Remove default padding
                    ),
                    child: Center(
                      child: Text(
                        'Show Last Trip',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: AppConfig().usersListButtonFontSize,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      trailing: IconButton(
        icon: const Icon(Icons.directions),
        tooltip: 'Move User',
        onPressed: onMoveUser,
      ),
      onTap: onTap,
    );
  }
}