import 'package:flutter/material.dart';

class PaysScreen extends StatelessWidget {
  const PaysScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagos'),
      ),
      body: const Center(
        child: Text('Pagos'),
      ),
    );
  }
}
