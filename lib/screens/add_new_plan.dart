import 'package:flutter/material.dart';
import 'package:la_dinamica_app/config/theme/app_theme.dart';

class AddNewPlan extends StatelessWidget {
  const AddNewPlan({super.key});

  @override
  Widget build(BuildContext context) {
    // Lista de labels para los TextField
    final List<String> labels = [
      'Tipo de plan',
      'Clases',
      'Precio',
    ];

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
                mainAxisAlignment:
                    MainAxisAlignment.start, // Cambiado de spaceBetween a start
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Agregar nuevo Plan',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                  const SizedBox(height: 20),
                  // Generar los TextField dinámicamente
                  for (var label in labels) ...[
                    TextField(
                      style: const TextStyle(color: Colors.white),
                      //controller: _controllers[index],
                      decoration: InputDecoration(
                        labelText: label,
                        labelStyle: const TextStyle(color: Colors.white),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                  const SizedBox(height: 20),
                  FilledButton(
                      onPressed: () {
                        Navigator.pop(context);
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
