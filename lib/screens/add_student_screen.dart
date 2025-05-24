import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:la_dinamica_app/backend/image_capture.dart';
import 'package:la_dinamica_app/config/theme/app_theme.dart';
import 'package:la_dinamica_app/backend/database.dart';
import 'package:la_dinamica_app/backend/create_credential.dart';
import 'package:la_dinamica_app/providers/create_queries_aws.dart';
import 'package:logger/logger.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  _AddStudentScreenState createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  final logger = Logger();

  // Crear un controlador para cada campo de texto
  final List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());

  // Lista de nombres personalizados para cada campo
  final List<String> _fieldNames = [
    'Nombre',
    'Localidad',
    'Teléfono',
    'Edad',
    'Fecha de nacimiento',
    'Correo Electrónico'
  ];
  //La lista de las etiquetas y los nombres en la base de datos difieren por lo que hice otra variable
  final List<String> _namesdb = [
    'name',
    'address',
    'phone',
    'age',
    'birthday',
    'email'
  ];
  @override
  void dispose() {
    // Liberar los controladores cuando no se necesiten más
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _submitForm(BuildContext context) async {
    // Verifica si el formulario es válido
    if (_formKey.currentState?.validate() ?? false) {
      final db = DatabaseHelper();
      final aws_db = DataStoreService();

      Map<String, dynamic> data = {};

      // Recopilar los datos de los controladores
      for (var i = 0; i < _controllers.length; i++) {
        data[_namesdb[i]] = _controllers[i].text;
      }

      logger.i('Datos del formulario: $data');

      // Insertar los valores en la base de datos y generar el archivo PDF
      final image = await pickAndSaveImage(data['name']);
      data['image'] = image;
      
      final id = await aws_db.saveGeneral(
          name: data['name'],
          address: data['address'],
          phone: data['phone'],
          age: int.parse(data['age']),
          birthday: data['birthday'],
          email: data['email'],
          image: image);

      await db.InsertGeneralData(data); //This is an insertion in the local database
      generateCredentialandSend(
          id, 
          data['name'], 
          data['address'], 
          data['phone'], 
          data['age'], 
          image);

      // Mostrar SnackBar confirmando el registro
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registro exitoso'),
          backgroundColor: Colors.green,
        ),
      );

      // Volver a la pantalla anterior
      Navigator.pop(context);
    } else {
      // Si hay campos vacíos, mostrar un mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, complete todos los campos.'),
          backgroundColor: Colors.red,
        ),
      );
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
                                style: const TextStyle(color: Colors.black),
                                controller: _controllers[index],
                                decoration: InputDecoration(
                                  labelStyle:
                                      const TextStyle(color: Colors.black),
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
                  onPressed: () {
                    _submitForm(context);
                  },
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
