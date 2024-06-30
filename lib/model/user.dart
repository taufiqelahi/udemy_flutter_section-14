import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String email;
  final String imageUrl;
  final String userName;

  UserModel( {required this.id,required this.email, required this.imageUrl, required this.userName});

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return UserModel(
      id: data['id'],
      email: data['email'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      userName: data['userName'] ?? '',
    );
  }
}