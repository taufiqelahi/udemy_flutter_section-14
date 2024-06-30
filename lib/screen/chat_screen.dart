import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:udemy_flutter_section14/screen/auth_screen.dart';
import 'package:udemy_flutter_section14/components/chat_messages.dart';
import 'package:udemy_flutter_section14/components/new_messages.dart';
import 'package:udemy_flutter_section14/screen/payment_screen.dart';
import 'package:udemy_flutter_section14/services/notfication_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
NotificationService service=NotificationService();
  @override
  void initState() {
    // TODO: implement initState
service.requestPermission();
service.getDeviceToken();
service.isTokenRefresh();
service.firbaseInit(context);
service.setupInteraction(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
          title: InkWell(onTap:(){
            Navigator.push(context, MaterialPageRoute(builder: (_)=>PaymentScreen()));
          },child: const Text('chat Screen')),
          actions: [
            IconButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();

                },
                icon: const Icon(Icons.logout)) ,
            IconButton(
                onPressed: () async {
                  final  currentFCMToken = await FirebaseMessaging.instance.getToken();

                  Map<String,dynamic>data={
                    'message': {
                      'token': currentFCMToken, // Token of the device you want to send the message to
                      'notification': {
                        'body': 'This is an FCM notification message!',
                        'title': 'FCM Message'
                      },
                      'data': {
                  'id':'12345',
                        'type':'message', // Include the current user's FCM token in data payload

                      },
                    }

                  };
await service.sendNotification(data);
                },
                icon: const Icon(Icons.send))
          ],
        ),
        body: const Column(
          children: [Expanded(child: ChatMessages()), NewMessages()],
        ));
  }
}
