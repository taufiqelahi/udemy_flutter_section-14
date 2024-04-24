import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NewMessages extends StatefulWidget {
  const NewMessages({super.key});

  @override
  State<NewMessages> createState() => _NewMessagesState();
}

class _NewMessagesState extends State<NewMessages> {
  final _messageController = TextEditingController();
  @override
  void dispose() {
    _messageController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 1, bottom: 34),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _messageController,
              autocorrect: true,
              enableSuggestions: true,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(labelText: 'Send messasge......'),
            ),
          ),
          IconButton(
              onPressed: onSubmit,
              icon: Icon(
                Icons.send,
                color: Theme.of(context).primaryColor,
              ))
        ],
      ),
    );
  }

  Future<void> onSubmit() async {
    final message=_messageController.text;
    if (message.trim().isEmpty) {
      return;
    }
    FocusScope.of(context).unfocus();
    _messageController.clear();

    final user=FirebaseAuth.instance.currentUser!;
    final userData=await FirebaseFirestore.instance.collection('users').doc(user.uid).get();


    FirebaseFirestore.instance.collection('chat').add({
      'text':message,
      'createdAt':Timestamp.now(),
      'userId':user.uid,
      'userName':userData.data()!['userName'],
      'imageUrl':userData.data()!['imageUrl']
      
    });
  }
}
