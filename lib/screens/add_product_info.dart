import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/backend/image_capture.dart';
import 'package:la_dinamica_app/config/theme/app_theme.dart';
import 'package:la_dinamica_app/providers/product_provider.dart';
import 'package:la_dinamica_app/providers/user_provider.dart';
import 'package:la_dinamica_app/screens/scanner.dart';
import 'package:logger/logger.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class AddProductInfo extends ConsumerStatefulWidget {
  
  const AddProductInfo({
    super.key,
    });

  @override
  ConsumerState<AddProductInfo> createState() => AddStudentScreenState();
}

class AddStudentScreenState extends ConsumerState<AddProductInfo> {
  final _formKey = GlobalKey<FormState>();
  final logger = Logger();
  bool isUploading = false;
  
  final List<TextEditingController> _controllers = List.generate(
    5,
    (index) => TextEditingController(),
  );

  final List<String> _fieldNames = [
    'Nombre del Producto',
    'Precio',
    'Numero de Unidades',
    'Categoria',
    'Codigo del producto'
  ];

  final List<String> _namesdb = [
    'name',
    'price',
    'stock',
    'category',
    'code',
  ];

  Future<void> _submitForm(BuildContext context) async {
    // Verifica si el formulario es válido
    if (_formKey.currentState?.validate() ?? false) {
      final user = await ref.watch(userProvider.future);
      final gymId = user.tenant!.tenant_id; 

      final data = {
        for (var i = 0; i < _controllers.length; i++)
          _namesdb[i]: _controllers[i].text,
      };
      logger.i('Datos del formulario: $data');

      // Insertar los valores en la base de datos y generar el archivo PDF
      final image = await pickAndSaveImage(data['name']!, gymId, false, true);

      await ref.read(productProvider.notifier).addProducts(
        data['name']!,
        image,
        data['code']!,
        user.tenant!.tenant_id,
        int.parse(data['stock']!),
        double.parse(data['price']!),
        data['category']!,
      );

      if (!mounted) return;
      
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
      appBar: AppBar(title: const Text('Agregar Producto')),
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
                                  if(_namesdb[index]=='code')...[
                                    const SizedBox(width: 8),
                                    IconButton(
                                      icon: const Icon(Icons.barcode_reader, color: Colors.black),
                                      onPressed: ()async{
                                        final Barcode? data = await scannerQR(context);
                                         if(data!=null){
                                          safePrint("CODE: ${data.format}");
                                          if(data.rawValue != null){
                                            _controllers[index].text = data.rawValue!;
                                          }
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
                  onPressed: isUploading ? 
                  null : 
                  () async{
                  try {
                    setState(() {
                      isUploading = true;
                    });
                    await _submitForm(context);
                  }catch(e){
                    safePrint("Error al subir el producto");
                  }finally{
                    setState(() {
                      isUploading = false;
                    });
                  }
                  },
                  child: isUploading ? 
                  CircularProgressIndicator():
                  const Text('Registrar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
