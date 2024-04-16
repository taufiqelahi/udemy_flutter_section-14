import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:udemy_flutter_section14/auth_screen.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('chat Screen'),
        actions: [
          IconButton(onPressed: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.push(context, MaterialPageRoute(builder: (_)=>AuthScreen()));
          }, icon: Icon(Icons.logout))
        ],

      ),
      body:const Center(
        child: Text('Chat ........',style: TextStyle(fontSize: 24),),
      ),
    );
  }
}
