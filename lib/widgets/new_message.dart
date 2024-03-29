import 'package:chat_app/repository/firestore_methods.dart';
import 'package:chat_app/models/user.dart' as models;

import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  final models.User user;
  const NewMessage({super.key, required this.user});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _messageController = TextEditingController();

  String getGroupChatId(String currentId, String otherId) {
    List<String> ids = [currentId, otherId];
    ids.sort(); // Sort the IDs to ensure consistent group chat ID
    return ids.join('-');
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _submitMessage() async {
    final enteredMessage = _messageController.text;
    if (enteredMessage.trim().isEmpty) {
      return;
    }
    FocusScope.of(context).unfocus();
    _messageController.clear();
    FirestoreMethods()
        .newMessage(message: enteredMessage, peerUserID: widget.user.uid);
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 1, bottom: 14),
      color: Colors.grey.withOpacity(0.2),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: const InputDecoration(hintText: 'Send a message...'),
            ),
          ),
          IconButton(
            color: Theme.of(context).colorScheme.primary,
            onPressed: _submitMessage,
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
