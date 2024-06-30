import 'package:flutter/material.dart';
import 'package:udemy_flutter_section14/components/new_messages.dart';
import 'package:udemy_flutter_section14/screen/message_screen.dart';

class UserChatScreen extends StatelessWidget {
  const UserChatScreen({super.key, required this.userId, required this.userName});
  final String userId;
  final String userName;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text('Chat with $userName'),

      ),
      body: Column(children: [
        Expanded(child: MessageScreen(userId: userId, userName: userName,),),
        NewMessages()
      ],),
    );
  }
}
