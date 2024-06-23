import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:udemy_flutter_section14/auth_screen.dart';
import 'package:udemy_flutter_section14/components/chat_messages.dart';
import 'package:udemy_flutter_section14/components/new_messages.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  void setupNotification()async{
    final fcm=FirebaseMessaging.instance;
    await fcm.requestPermission();
    final token= await fcm.getToken();
    print(token);
    fcm.subscribeToTopic('chat');
  }
  @override
  void initState() {
    // TODO: implement initState
setupNotification();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
          title: const Text('chat Screen'),
          actions: [
            IconButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();

                },
                icon: const Icon(Icons.logout))
          ],
        ),
        body: const Column(
          children: [Expanded(child: ChatMessages()), NewMessages()],
        ));
  }
}
