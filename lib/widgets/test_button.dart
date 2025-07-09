import 'package:flutter/material.dart';
import 'package:la_dinamica_app/backend/image_capture.dart';

class TestButton extends StatelessWidget {
  const TestButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        final image = pickAndSaveImage('test_image1', 'test_gym_id');
      },
      child: const Text('Test Button'),
    );
  }
}