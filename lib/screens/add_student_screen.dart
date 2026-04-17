import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/backend/create_credential.dart';
import 'package:la_dinamica_app/backend/image_capture.dart';
import 'package:la_dinamica_app/config/theme/app_theme.dart';
import 'package:la_dinamica_app/providers/create_queries_aws.dart';
import 'package:la_dinamica_app/providers/user_provider.dart';

class AddStudentScreen extends ConsumerStatefulWidget {
  const AddStudentScreen({super.key});

  @override
  ConsumerState<AddStudentScreen> createState() => AddStudentScreenState();
}

class AddStudentScreenState extends ConsumerState<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final List<TextEditingController> _controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );

  final List<String> _fieldNames = [
    'Nombre',
    'Localidad',
    'Teléfono',
    'Edad',
    'Fecha de nacimiento(yyyy-mm-dd)',
    'Correo Electrónico',
  ];

  final List<String> _namesdb = [
    'name',
    'address',
    'phone',
    'age',
    'birthday',
    'email',
  ];

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  bool checkDateFormat(String date) {
        final regex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
        if (!regex.hasMatch(date)) return false;
        try {
          DateTime.parse(date);
          return true;
        } catch (e) {
          return false;
        }
      }

  void _submitForm(BuildContext context) async {
    // Verifica si el formulario es válido
    if (_formKey.currentState?.validate() ?? false) {
      final awsDb = DataStoreService();
      final user = await ref.watch(userProvider.future);
      final gymId = user.tenant.tenant_id; 

      final data = {
        for (var i = 0; i < _controllers.length; i++)
          _namesdb[i]: _controllers[i].text,
      };

      if(checkDateFormat(data['birthday']!) == false){
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Formato de fecha incorrecto. Use yyyy-mm-dd'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Insertar los valores en la base de datos y generar el archivo PDF
      final image = await pickAndSaveImage(data['name']!, gymId, false, false);
      data['image'] = image!;

      final id = await awsDb.saveStudent(
        name: data['name']!,
        address: data['address']!,
        phone: data['phone']!,
        age: int.parse(data['age']!),
        birthday: data['birthday']!,
        email: data['email']!,
        image: image,
        gymId: gymId, 
      );

      generateCredentialandSend(
        id,
        data['name']!,
        data['address']!,
        data['phone']!,
        data['age']!,
        image,
        gymId,
      );

      if (!mounted) return;
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
      appBar: AppBar(title: const Text('Add Student')),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [colorList[2], colorList[4]],
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
                    color: Colors.white.withAlpha(204),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          'assets/images/f_ma18.png',
                          width: 150,
                          fit: BoxFit.cover,
                          )
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(_fieldNames.length, (index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                              ),
                              child: SizedBox(
                                width: double.maxFinite,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                      style: const TextStyle(color: Colors.black),
                                      controller: _controllers[index],
                                      decoration: InputDecoration(
                                        labelStyle: const TextStyle(
                                          color: Colors.black,
                                        ),
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
                                    ),
                                  if(_namesdb[index]=='birthday')...[
                                    const SizedBox(width: 8),
                                    IconButton(
                                      icon: const Icon(Icons.calendar_today, color: Colors.black),
                                      onPressed: ()async{
                                        final DateTime? pickDate = await showDatePicker(
                                          context: context, 
                                          firstDate: DateTime(1990), 
                                          lastDate: DateTime(2050));
                                          if(pickDate != null){
                                            _controllers[index].text = pickDate.toIso8601String().split('T').first;
                                          }
                                      },
                                
                                    )
                                  ]
                                  ]
                                ),
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
