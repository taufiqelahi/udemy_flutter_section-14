import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:udemy_flutter_section14/model/user.dart';


class UserViewModel{
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<UserModel>> fetchUsers() async {
    QuerySnapshot snapshot = await _db.collection('users').get();
    return snapshot.docs.map((doc) => UserModel.fromFirestore(doc)).toList();
  }
}