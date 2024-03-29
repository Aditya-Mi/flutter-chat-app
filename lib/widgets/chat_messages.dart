import 'package:chat_app/repository/firestore_methods.dart';
import 'package:chat_app/widgets/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app/models/user.dart' as models;
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  final models.User user;
  const ChatMessages({super.key, required this.user});

  @override
  Widget build(context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;
    return StreamBuilder(
      stream: FirestoreMethods().getMessages(
          currentUserId: authenticatedUser.uid, peerUserId: user.uid),
      builder: (ctx, chatSnapshots) {
        if (chatSnapshots.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty) {
          return const Center(
            child: Text('No messages found'),
          );
        }
        if (chatSnapshots.hasError) {
          return const Center(
            child: Text('Something went wrong.'),
          );
        }

        final loadMessages = chatSnapshots.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 40, right: 13, left: 13),
          reverse: true,
          itemCount: loadMessages.length,
          itemBuilder: (ctx, index) {
            final chatMessage = loadMessages[index].data();
            final nextChatMessage = index + 1 < loadMessages.length
                ? loadMessages[index + 1].data()
                : null;
            final currentMessageUserId = chatMessage['userId'];
            final nextMessageUserId =
                nextChatMessage != null ? nextChatMessage['userId'] : null;
            final nextUserIsSame = currentMessageUserId == nextMessageUserId;
            if (nextUserIsSame) {
              return MessageBubble.next(
                  message: chatMessage['text'],
                  isMe: authenticatedUser.uid == currentMessageUserId);
            } else {
              return MessageBubble.first(
                  userImage: chatMessage['userImage'],
                  username: chatMessage['username'],
                  message: chatMessage['text'],
                  isMe: authenticatedUser.uid == currentMessageUserId);
            }
          },
        );
      },
    );
  }
}
