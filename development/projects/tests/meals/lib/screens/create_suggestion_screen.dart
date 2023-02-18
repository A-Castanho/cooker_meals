import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meals/domain/meal.dart';

class CreateSuggestionScreen extends StatefulWidget {
  CreateSuggestionScreen({super.key});

  @override
  State<CreateSuggestionScreen> createState() => _CreateSuggestionScreenState();
}

class _CreateSuggestionScreenState extends State<CreateSuggestionScreen> {
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _descriptionController = TextEditingController();

  File? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(hintText: 'name'),
              controller: _nameController,
            ),
            TextFormField(
              decoration: InputDecoration(hintText: 'description'),
              controller: _descriptionController,
            ),
            if (_image != null) Image.file(_image!, height: 200),
            ElevatedButton(
                onPressed: _getFromGallery, child: Text('Pick image')),
            ElevatedButton(onPressed: _submit, child: Text('Submit'))
          ],
        ));
  }

  _getFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  _submit() async {
    Meal(null, name: _nameController.text, description: _descriptionController.text);
  }
}
