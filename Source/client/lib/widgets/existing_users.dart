import 'package:flutter/material.dart';

import 'available_user.dart';
import '../classes/grpc_user.dart';
import '../singletons/app_config.dart';

class ExistingUsers extends StatelessWidget {
  final Map<String, GrpcUser> users;
  final Function(GrpcUser) onUserTap;

  const ExistingUsers({
    super.key,
    required this.users,
    required this.onUserTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
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
                user.color = AppConfig.userColors[index % AppConfig.userColors.length];
                return AvailableUser(
                  user: user,
                  onTap: () => onUserTap(user),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}