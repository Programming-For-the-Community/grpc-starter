import 'package:flutter/material.dart';
import '../singletons/logger.dart';

import 'available_user.dart';
import '../classes/grpc_user.dart';
import '../singletons/app_config.dart';

class ExistingUsers extends StatelessWidget {
  final Map<String, GrpcUser> users;
  final Function(GrpcUser) onUserTap;
  final Function(GrpcUser) onTakeTrip;
  final _logger = Logger();

  ExistingUsers({
    super.key,
    required this.users,
    required this.onUserTap,
    required this.onTakeTrip,
  });

  @override
  Widget build(BuildContext context) {
    _logger.debug('ExistingUsers rebuilding with ${users.length} users');

    return Container(
      width: AppConfig().usersListDisplayWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
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
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users.values.elementAt(index);
                return AvailableUser(
                  key: ValueKey(user.username),
                  user: user,
                  onTap: () => onUserTap(user),
                  onTakeTrip: () => onTakeTrip(user),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}