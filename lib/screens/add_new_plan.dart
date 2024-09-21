import 'package:flutter/material.dart';
import 'package:la_dinamica_app/config/theme/app_theme.dart';
import 'package:la_dinamica_app/backend/database.dart';

class AddNewPlan extends StatefulWidget {
  const AddNewPlan({super.key});

  @override
  State<AddNewPlan> createState() => _AddNewPlanState();
}

class _AddNewPlanState extends State<AddNewPlan> {
  final List<String> labels = ['Tipo de plan', 'Clases', 'Precio'];
  final List<TextEditingController> _controllers =
      List.generate(3, (index) => TextEditingController());

  void _registerPlan() {
    // Retrieve text from each TextEditingController
    Map<String, dynamic> plan = {
      'type': _controllers[0].text,
      'clases': _controllers[1].text,
      'price': _controllers[2].text
    };
    DatabaseHelper db = DatabaseHelper();

    db.InsertPlanData(plan);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
                color: colorList[1], borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Agregar nuevo Plan',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                  const SizedBox(height: 20),
                  // Generar los TextField dinámicamente
                  for (var i = 0; i < labels.length; i++) ...[
                    TextField(
                      style: const TextStyle(color: Colors.white),
                      controller: _controllers[i],
                      decoration: InputDecoration(
                        labelText: labels[i],
                        labelStyle: const TextStyle(color: Colors.white),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                  const SizedBox(height: 20),
                  FilledButton(
                      onPressed: () {
                        _registerPlan();
                        // Regresar a ConfigScreen con true si se agregó el plan
                        Navigator.pop(context, true);
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              WidgetStatePropertyAll(colorList[3])),
                      child: const Text(
                        'Registrar',
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
