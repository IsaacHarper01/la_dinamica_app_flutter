import 'package:flutter/material.dart';
import 'package:la_dinamica_app/config/theme/app_theme.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  _AddStudentScreenState createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>();

  // Crear un controlador para cada campo de texto
  final List<TextEditingController> _controllers =
      List.generate(9, (index) => TextEditingController());

  // Lista de nombres personalizados para cada campo
  final List<String> _fieldNames = [
    'Nombre',
    'Apellido',
    'Correo Electrónico',
    'Teléfono',
    'Dirección',
    'Ciudad',
    'Estado',
    'Código Postal',
    'País'
  ];

  @override
  void dispose() {
    // Liberar los controladores cuando no se necesiten más
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      // Aquí puedes acceder a los valores de los TextFields
      for (var i = 0; i < _controllers.length; i++) {
        print('${_fieldNames[i]}: ${_controllers[i].text}');
      }

      // Aquí puedes enviar los datos, o realizar cualquier otra acción
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Student'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              colorList[2],
              colorList[4],
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            'https://i.pinimg.com/originals/fb/6d/16/fb6d16c4321ab45dad1c6290f2740f7a.jpg',
                            width: 100,
                            fit: BoxFit.cover,
                          )),
                      Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(_fieldNames.length, (index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: TextFormField(
                                controller: _controllers[index],
                                decoration: InputDecoration(
                                  labelText: _fieldNames[index],
                                  hintText:
                                      'Ingrese ${_fieldNames[index].toLowerCase()}',
                                  border: const OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, ingrese ${_fieldNames[index].toLowerCase()}';
                                  }
                                  return null;
                                },
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Registrar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
