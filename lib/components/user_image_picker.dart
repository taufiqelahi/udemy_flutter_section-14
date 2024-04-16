import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key});

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File ? seletedImage;
  Future<void> pickImages() async {
  final pickedImage=await  ImagePicker().pickImage(source: ImageSource.gallery,maxWidth:150,imageQuality: 50 );
  if(pickedImage==null){
    return;
  }
  setState(() {
    seletedImage=File(pickedImage.path);
  });
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          foregroundImage: seletedImage!=null?FileImage(seletedImage!):null,
        ),
        TextButton.icon(onPressed:pickImages, icon: Icon(Icons.image),
        label: Text('Add Image',style: TextStyle(
          color: Theme.of(context).primaryColor
        ),),
       )
      ],
    );
  }
}
