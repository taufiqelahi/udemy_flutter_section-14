import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:udemy_flutter_section14/model/user.dart';
import 'package:udemy_flutter_section14/screen/message_screen.dart';
import 'package:udemy_flutter_section14/screen/user_chat_screen.dart';
import 'package:udemy_flutter_section14/viewmodel/user_view_model/user_view_model.dart';

class UserListScreen extends StatelessWidget {
  final UserViewModel userData = UserViewModel();

  UserListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser=FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Text('Users List'),
      ),
      body: FutureBuilder<List<UserModel>>(
        future: userData.fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final users = snapshot.data ?? [];
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                if(currentUser?.uid!=user.id){
                  return ListTile(

                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_)=> UserChatScreen(
                        userId: user.id,
                        userName: user.userName,
                      )));
                    },
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(user.imageUrl),
                    ),
                    title: Text(user.userName),
                    subtitle: Text(user.email),
                  );
                }

              },
            );
          }
        },
      ),
    );
  }
}
