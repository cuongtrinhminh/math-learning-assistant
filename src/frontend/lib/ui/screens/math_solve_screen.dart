import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/models/math_answer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:frontend/assets/constants.dart';
import 'package:frontend/services/math_service.dart';
import 'package:frontend/ui/screens/math_answer_detail_screen.dart';

class MathSolveScreen extends StatefulWidget {
  const MathSolveScreen({super.key});

  @override
  State<MathSolveScreen> createState() => _MathSolveScreenState();
}

class _MathSolveScreenState extends State<MathSolveScreen> {
  File? _image;
  final _picker = ImagePicker();
  final mathService = MathService();
  bool _isLoading = false;

  _pickImage(PICKING_SOURCE srcType) async {
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

  _onGeneratePressed() async {
    if(_image == null) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await mathService.getAnswer(_image!);

      if (result.success && result.data != null) {
        _navigateToAnswerDetailScreen(result.data!);
      } else {
        _showErrorDialog(context, result.error?.errorMessage ?? "Error");
      }
    }
    finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
         });
      }
    }

  }

  _showErrorDialog(BuildContext context, String errorDescription) {
      return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text(errorDescription),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(textStyle: Theme.of(context).textTheme.labelLarge),
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
  }

  _navigateToAnswerDetailScreen(List<MathAnswer> answers) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AnswerDetailScreen(answers: answers),
      ),
    );
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
          Center(
            child: _isLoading
            ? const CircularProgressIndicator()   // spinner
                : const SizedBox.shrink(), // trống khi không loading
          ),

          const SizedBox(height: 20),

          // Hàng chứa 2 nút: PhotoPicker & Camera
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  _pickImage(PICKING_SOURCE.gallery);
                },
                icon: const Icon(Icons.photo_library),
                label: const Text(GALLERY_PICKING_OPTIONS),
              ),
              const SizedBox(width: 20),
              ElevatedButton.icon(
                onPressed: () {
                  _pickImage(PICKING_SOURCE.camera);
                },
                icon: const Icon(Icons.camera_alt),
                label: const Text(CAMERA_CAPTURE),
              ),
            ],
          ),

          const SizedBox(height: 40),

          // Button Generate
          ElevatedButton(
            onPressed: _onGeneratePressed,
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