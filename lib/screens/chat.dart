import 'package:chat_app/widgets/chat_messages.dart';
import 'package:chat_app/widgets/new_message.dart';
import 'package:chat_app/models/user.dart' as models;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final models.User user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  void setupPushNotifications() async {
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();
    fcm.subscribeToTopic('chat');
  }

  @override
  void initState() {
    super.initState();
    setupPushNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              foregroundImage: NetworkImage(widget.user.imageUrl),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(widget.user.username),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
              child: ChatMessages(
            user: widget.user,
          )),
          NewMessage(
            user: widget.user,
          ),
        ],
      ),
    );
  }
}
