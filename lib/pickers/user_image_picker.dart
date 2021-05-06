import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final Function(File pickedImage) uploadImage;

  UserImagePicker(this.uploadImage);

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickedImage;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: source, imageQuality: 50, maxWidth: 150,);

    try {
      setState(() {
        _pickedImage = File(pickedImage.path);
      });
      widget.uploadImage(_pickedImage);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('No image was selected'),
        backgroundColor: Theme.of(context).errorColor,
      ));
    }
  }

  Future<void> photoDialog() async {
    final response = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('How do you want to choose your image?'),
        actions: [
          TextButton.icon(
              onPressed: () {
                Navigator.pop(context, ImageSource.gallery);
              },
              icon: Icon(Icons.image),
              label: Text('Gallery')),
          TextButton.icon(
              onPressed: () {
                Navigator.pop(context, ImageSource.camera);
              },
              icon: Icon(Icons.camera_alt),
              label: Text('Camera')),
        ],
      ),
    );
    _pickImage(response);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: _pickedImage == null
              ? AssetImage('images/person_placeholder.jpg')
              : FileImage(_pickedImage),
        ),
        TextButton.icon(
          onPressed: photoDialog,
          icon: Icon(Icons.image),
          label: Text(
            'Add Image',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
      ],
    );
  }
}
