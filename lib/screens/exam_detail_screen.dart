import 'package:flutter/material.dart';
import 'package:la_dinamica_app/models/Evaluations.dart';
import 'package:la_dinamica_app/models/JointMetric.dart';

class ExamDetailScreen extends StatefulWidget{
  final Evaluations exam;
  final List<JointMetric>? metrics;

  const ExamDetailScreen({
    super.key,
    required this.exam,
    this.metrics,
  });

  @override
  _ExamDetailScreenState createState() => _ExamDetailScreenState();
}

class _ExamDetailScreenState extends State<ExamDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exam.name!),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Detalles del Examen: ${widget.exam.name}"),
            if (widget.metrics != null && widget.metrics!.isNotEmpty)
              ...widget.metrics!.map((metric) => Text("Métrica: ${metric.metric!.name}")),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Volver"),
            ),
          ],
        ),
      ),
    );
  }
}