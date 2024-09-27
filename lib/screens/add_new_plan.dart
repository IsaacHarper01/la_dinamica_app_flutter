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

  final _formKey = GlobalKey<FormState>(); // Clave global para el formulario

  void _registerPlan() {
    // Verificar si el formulario es válido
    if (_formKey.currentState?.validate() ?? false) {
      // Recuperar texto de cada TextEditingController
      Map<String, dynamic> plan = {
        'type': _controllers[0].text,
        'clases': _controllers[1].text,
        'price': _controllers[2].text
      };
      DatabaseHelper db = DatabaseHelper();

      db.InsertPlanData(plan);

      // Mostrar un SnackBar de confirmación
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Plan registrado exitosamente'),
          backgroundColor: Colors.green,
        ),
      );

      // Regresar a ConfigScreen con true si se agregó el plan
      Navigator.pop(context, true);
    } else {
      // Mostrar un SnackBar si hay campos vacíos
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, complete todos los campos'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
              color: colorList[1],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey, // Asociar la clave global al formulario
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Agregar nuevo Plan',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                    const SizedBox(height: 20),
                    // Generar los TextFormField dinámicamente con validación
                    for (var i = 0; i < labels.length; i++) ...[
                      TextFormField(
                        style: const TextStyle(color: Colors.white),
                        controller: _controllers[i],
                        decoration: InputDecoration(
                          labelText: labels[i],
                          labelStyle: const TextStyle(color: Colors.white),
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, ingrese ${labels[i].toLowerCase()}';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                    const SizedBox(height: 20),
                    FilledButton(
                      onPressed:
                          _registerPlan, // Llamar a la función de registro
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(colorList[3]),
                      ),
                      child: const Text(
                        'Registrar',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
