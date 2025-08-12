import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/screens/add_metrics_screen.dart';

class NewEvaluationScreen extends ConsumerStatefulWidget{
  const NewEvaluationScreen({super.key});

  @override
  ConsumerState<NewEvaluationScreen> createState() => _NewEvaluationScreenState();
}

class _NewEvaluationScreenState extends ConsumerState<NewEvaluationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Evaluación'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const NewMetricsPage()),);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // ⬅️ Big rounded corners
                  ),
                  minimumSize: const Size(400, 200), // ⬅️ Square shape
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  padding: EdgeInsets.zero, // remove internal padding
                ),
                child: const Icon(
                  Icons.add,
                  size: 40, // 
                  color: Colors.white,
                ),
              ),
            Text("Crear nueva prueba"),
            SizedBox(height: 40),
            SizedBox(
              width: 400,
              height: 400,
              child: DecoratedBox(decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              )),
            ) 
              ]
        ),
      ),  
    );
  }
}