import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.username,
    required this.message,
    required this.isMe,
  });

  final String? username;
  final String message;
  final bool isMe;

  void _deleteMessage() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
      final querySnapshot = await FirebaseFirestore.instance.collection('chat')
        .where('message', isEqualTo: message).where('userId', isEqualTo: user.uid).get();

    for(var doc in querySnapshot.docs) {
      await doc.reference.delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 46),
          child: Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (username != null || isMe)
                Padding(
                  padding: const EdgeInsets.only(
                    left: 13,
                    right: 13,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (username != null)
                        Text(
                          username!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      if (isMe)
                        IconButton(
                          onPressed: _deleteMessage,
                          icon: const Icon(
                            Icons.delete_outline_sharp,
                            size: 20,
                            color: Colors.red,
                          ),
                        ),
                    ],
                  ),
                ),
              Container(
                decoration: BoxDecoration(
                  color: isMe
                      ? Colors.grey[300]
                      : theme.colorScheme.secondary.withAlpha(200),
                  borderRadius: BorderRadius.only(
                    topLeft: !isMe
                        ? Radius.zero
                        : const Radius.circular(12),
                    topRight: isMe
                        ? Radius.zero
                        : const Radius.circular(12),
                    bottomLeft: const Radius.circular(12),
                    bottomRight: const Radius.circular(12),
                  ),
                ),
                constraints: const BoxConstraints(maxWidth: 200),
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 14,
                ),
                margin: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 12,
                ),
                child: Text(
                  message,
                  style: TextStyle(
                    height: 1.3,
                    color: isMe
                        ? Colors.black87
                        : theme.colorScheme.onSecondary,
                  ),
                  softWrap: true,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
