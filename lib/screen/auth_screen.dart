import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:udemy_flutter_section14/screen/all_chat_screen.dart';
import 'package:udemy_flutter_section14/components/user_image_picker.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  final auth = FirebaseAuth.instance;
  var _isLogin = true;
  var _isAuthenticated = false;
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();

  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  File? selectedImage;
  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 30,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                width: 200,
                child: Image.asset('assets/images/chat.png'),
              ),
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!_isLogin)
                            UserImagePicker(
                              onSelectedImages: (File image) {
                                selectedImage = image;
                              },
                            ),
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                                labelText: 'Email Address'),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (v) {
                              if (v!.trim().isEmpty || !v.contains('@')) {
                                return 'please enter valid email';
                              }
                            },
                          ),
                          if(!_isLogin)
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(

                              labelText: 'Username'
                            ),
                            validator: (v){
                              if(v==null || v.trim().isEmpty||v.length<4){
                                return "Please enter 4 charcter";
                              }
                            },
                          ),
                          TextFormField(
                            controller: _passwordController,
                            decoration:
                                const InputDecoration(labelText: 'Password'),
                            obscureText: true,
                            validator: (v) {
                              if (v!.trim().isEmpty || v.length <= 5) {
                                return "please enter valid password";
                              }
                            },
                          ),
                          const SizedBox(height: 12),
                          if (_isAuthenticated) CircularProgressIndicator(),
                          if (!_isAuthenticated)
                            ElevatedButton(
                              onPressed: () {
                                submit();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                              ),
                              child: Text(_isLogin ? 'Login' : 'Signup'),
                            ),
                          if (!_isAuthenticated)
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _isLogin = !_isLogin;
                                });
                              },
                              child: Text(_isLogin
                                  ? 'Create an account'
                                  : 'I already have an account'),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> submit() async {
    final valid = _formKey.currentState!.validate();
    if (!valid || !_isLogin && selectedImage == null) {
      return;
    }
    _formKey.currentState!.save();

    try {
      setState(() {
        _isAuthenticated = true;
      });
      if (_isLogin) {
        final userCrendantial = await auth.signInWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text);
        // ScaffoldMessenger.of(context).clearSnackBars();
        // ScaffoldMessenger.of(context)
        //     .showSnackBar(const SnackBar(content: Text("welcome back")));
      } else {
        final userCredential = await auth.createUserWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text);
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${userCredential.user!.uid}.jpg');
        await storageRef.putFile(selectedImage!);
        final imageUrl = await storageRef.getDownloadURL();
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'userName': _nameController.text,
          'email': _emailController.text,
          'imageUrl': imageUrl,
          'id':userCredential.user!.uid
        });
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Authentication Failed')));

      setState(() {
        _isAuthenticated = false;
      });
    }
  }
}
