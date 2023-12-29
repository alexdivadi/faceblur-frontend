import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ImagePicker _picker = ImagePicker();
  Image? image;
  Set<int> unBlur = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FaceBlur"),
      ),
      body: Center(
        child: Column(
          children: [
            (image == null)
                ? const Text("You have not selected an image yet.")
                : image!,
            ElevatedButton(
                onPressed: pickImage,
                child: const Text("Pick an image from gallery"))
          ],
        ),
      ),
    );
  }

  Future pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile == null) return;
      final File image = File(pickedFile.path);
      setState(() {
        this.image = Image.file(image);
        //imageBlurred = Image.memory(Uint8List.view(blurredImage!.buffer));
      });
    } on PlatformException catch (e) {
      log('Failed to pick image: $e');
    }
  }
}
