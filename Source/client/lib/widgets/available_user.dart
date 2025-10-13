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

  const AvailableUser({
    super.key,
    required this.user,
    required this.onTap,
    required this.onTakeTrip,
  });

  @override
  Widget build(BuildContext context) {
    final Logger logger = Logger();
    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            user.username ?? 'Unknown',
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
                    onPressed: () =>{

                    },
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
      onTap: onTap,
    );
  }
}