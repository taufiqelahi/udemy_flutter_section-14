import 'package:cloud_firestore/cloud_firestore.dart';

class MessageViewModel{


  Stream<QuerySnapshot> getChatMessages(String userId) {
    return FirebaseFirestore.instance
        .collection('chat')
        .where('userId', isEqualTo: userId)

        .snapshots();
  }
}