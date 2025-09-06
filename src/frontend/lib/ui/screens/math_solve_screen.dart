import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:frontend/assets/constants.dart';

class MathSolveScreen extends StatefulWidget {
  const MathSolveScreen({super.key});

  @override
  State<MathSolveScreen> createState() => _MathSolveScreenState();
}

class _MathSolveScreenState extends State<MathSolveScreen> {
  File? _image; 
  final _picker = ImagePicker();

  pickImage(PICKING_SOURCE srcType) async {
    XFile? pickedFile;

    switch (srcType) {
      case PICKING_SOURCE.camera:
        pickedFile = await _picker.pickImage(source: ImageSource.camera);
        break;
      case PICKING_SOURCE.gallery:
        pickedFile = await _picker.pickImage(source: ImageSource.gallery);
        break;
    }
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      setState(() {});
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(APP_TITLE),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Hiển thị ảnh hoặc text
          Center(
            child: _image == null
                ? const Text(NO_IMAGE)
                : Image.file(_image!),
          ),

          const SizedBox(height: 20),

          // Hàng chứa 2 nút: PhotoPicker & Camera
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  pickImage(PICKING_SOURCE.gallery);
                },
                icon: const Icon(Icons.photo_library),
                label: const Text(GALLERY_PICKING_OPTIONS),
              ),
              const SizedBox(width: 20),
              ElevatedButton.icon(
                onPressed: () {
                  pickImage(PICKING_SOURCE.camera);
                },
                icon: const Icon(Icons.camera_alt),
                label: const Text(CAMERA_CAPTURE),
              ),
            ],
          ),

          const SizedBox(height: 40),

          // Button Generate
          ElevatedButton(
            onPressed: () {
              //generateResult(); // hàm xử lý generate
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(200, 50),
            ),
            child: const Text(GENERATE_ANSWER),
          ),
        ],
      ),
    );
  }
}