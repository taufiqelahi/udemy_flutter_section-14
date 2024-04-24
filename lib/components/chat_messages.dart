import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('chat').orderBy('createdAt').snapshots(),
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
        return ListView.builder(itemCount:data.length, itemBuilder: (BuildContext context, int index) { 
          return Text(data[index].data()['text']);
        }, );
      },
    );
  }
}
