import 'package:flutter/material.dart';

class StudentDetailScreen extends StatelessWidget {
  final String name;

  const StudentDetailScreen({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: const Center(
        child: Text('Aqui van los detalles'),
      ),
    );
  }
}
