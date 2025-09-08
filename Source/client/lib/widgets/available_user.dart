import 'package:flutter/material.dart';

import '../classes/grpc_user.dart';
import '../singletons/grpc_client.dart';
import '../singletons/logger.dart';
import '../proto/tracker.pbgrpc.dart';

class AvailableUser extends StatelessWidget {
  final GrpcUser user;
  final VoidCallback onTap;

  const AvailableUser({
    super.key,
    required this.user,
    required this.onTap,
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
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Implement Take Trip action
                  },
                  child: Text('Take Trip'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Implement Show Last Trip action
                  },
                  child: const Text('Show Last Trip'),
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