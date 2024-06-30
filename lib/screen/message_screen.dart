import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:udemy_flutter_section14/components/message_bubble.dart';
import 'package:udemy_flutter_section14/viewmodel/user_view_model/message_view_model.dart';

class MessageScreen extends StatelessWidget {
  final String userId;
  final String userName;

  const MessageScreen({super.key, required this.userId, required this.userName});

  @override
  Widget build(BuildContext context) {
    final currentUser=FirebaseAuth.instance.currentUser!;
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Chat with $userName'),
      // ),
      body:StreamBuilder<QuerySnapshot>(
        stream: MessageViewModel().getChatMessages(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No messages found.'));
          } else {
            final data = snapshot.data!.docs;
            return  ListView.builder(
              padding: const EdgeInsets.only(
                bottom: 40,
                left: 13,
                right: 13,
              ),
              reverse: true,
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                final chatMessage = data[index];



                final nextChatMessage =
                index + 1 < data.length ? data[index + 1] : null;

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
          }
        },
      ),


    );
  }
}
