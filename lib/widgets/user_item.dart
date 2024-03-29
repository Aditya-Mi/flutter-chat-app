import 'package:chat_app/models/user.dart';
import 'package:flutter/material.dart';

class UserItem extends StatelessWidget {
  final User user;
  const UserItem({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey,
            foregroundImage: NetworkImage(
              user.imageUrl,
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Text(
            user.username,
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
