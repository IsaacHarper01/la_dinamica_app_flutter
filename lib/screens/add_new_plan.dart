import 'package:flutter/material.dart';
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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo Plan'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey, // Asociar la clave global al formulario
          child: Column(
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                color: colorScheme.surface,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    spacing: 20,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Agregar nuevo Plan',
                        style: textTheme.headlineSmall?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      ...List.generate(labels.length, (i) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: TextFormField(
                            controller: _controllers[i],
                            style: TextStyle(color: colorScheme.onSurface),
                            decoration: InputDecoration(
                              labelText: labels[i],
                              labelStyle:
                                  TextStyle(color: colorScheme.onSurface),
                              filled: true,
                              fillColor: colorScheme.surfaceDim,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, ingrese ${labels[i].toLowerCase()}';
                              }
                              return null;
                            },
                          ),
                        );
                      }),
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        onPressed: _registerPlan,
                        icon: const Icon(Icons.save),
                        label: const Text('Registrar'),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                          textStyle: const TextStyle(fontSize: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
