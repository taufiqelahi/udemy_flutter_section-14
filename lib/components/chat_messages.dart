import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:udemy_flutter_section14/components/message_bubble.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser!;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt',descending: true)
          .snapshots(),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData) {
          return const Center(
            child: Text('No Messages Found'),
          );
        }
        if (snapshot.hasError) {
          return const Center(child: Text("something went wong...."));
        }
        final data = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.only(
            bottom: 40,
            left: 13,
            right: 13,
          ),
          reverse: true,
          itemCount: data.length,
          itemBuilder: (BuildContext context, int index) {
            final chatMessage = data[index].data();



            final nextChatMessage =
                index + 1 < data.length ? data[index + 1].data() : null;

            final currentMessageUserId = chatMessage['userId'];

            final isMe = currentUser.uid == currentMessageUserId;

            final nextMessageUserId =
                nextChatMessage != null ? nextChatMessage['userId'] : null;
            final nextUserIsSame = nextMessageUserId == currentMessageUserId;

            if (nextUserIsSame) {


             return MessageBubble.next(message: chatMessage['text'], isMe: isMe);
            } else {

             return MessageBubble.first(

                  userImage: chatMessage['imageUrl'],
                  username: chatMessage['userName'],
                  message: chatMessage['text'],
                  isMe: isMe);
            }
          },
        );
      },
    );
  }
}
