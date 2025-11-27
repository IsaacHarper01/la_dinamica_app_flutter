import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';

class EditPermissionsScreen extends StatefulWidget{
  final UserAccess access;

  const EditPermissionsScreen({
    super.key,
    required this.access,
    });

  @override
  State<EditPermissionsScreen> createState() => _EditPermissionsScreenState();
}

class _EditPermissionsScreenState extends State<EditPermissionsScreen> {

  bool deleteStudents = false;
  bool watchIncome = false;
  bool setPlans = false;
  bool setEvaluations = false;
  bool deletePayments = false;
  bool addProfesor = false;
  bool editPast = false;
  bool editProducts = false;
  bool sellProducts = false;

  @override
  void initState() {
    super.initState();
    decodePermissions(widget.access.permissions!);
  }

  void decodePermissions(String access){
    final decodedPermissions = jsonDecode(access) as Map<String, dynamic>;
    setState(() {
      deleteStudents = decodedPermissions['deleteStudents'] ?? false;
      watchIncome = decodedPermissions['watchIncome'] ?? false;
      setPlans = decodedPermissions['setPlans'] ?? false;
      setEvaluations = decodedPermissions['setEvaluations'] ?? false;
      deletePayments = decodedPermissions['deletePayments'] ?? false;
      addProfesor = decodedPermissions['addProfesor'] ?? false;
      editPast = decodedPermissions['editPast'] ?? false;
      editProducts = decodedPermissions['editProducts'] ?? false;
      sellProducts = decodedPermissions['sellProducts'] ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Permisos")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Selecciona los permisos que deseas otorgar:', style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 50),
            SwitchListTile(
              title: const Text('Eliminar alumnos'),
              value: deleteStudents,
              onChanged: (value) => setState(() => deleteStudents = value),
            ),
            SwitchListTile(
              title: const Text('Ver ingresos'),
              value: watchIncome,
              onChanged: (value) => setState(() => watchIncome = value),
            ),
            SwitchListTile(
              title: const Text('Establecer planes'),
              value: setPlans,
              onChanged: (value) => setState(() => setPlans = value),
            ),
            SwitchListTile(
              title: const Text('Añadir Evaluaciones'),
              value: setEvaluations,
              onChanged: (value) => setState(() => setEvaluations = value),
            ),
            SwitchListTile(
              title: const Text('Eliminar pagos'),
              value: deletePayments,
              onChanged: (value) => setState(() => deletePayments = value),
            ),
            SwitchListTile(
              title: const Text('Agregar profesores'),
              value: addProfesor,
              onChanged: (value) => setState(() => addProfesor = value),
            ),
            SwitchListTile(
              title: const Text('Editar registros pasados'),
              value: editPast,
              onChanged: (value) => setState(() => editPast = value),
            ),
            SwitchListTile(
              title: const Text('Editar productos'),
              value: editProducts,
              onChanged: (value) => setState(() => editProducts = value),
            ),
            SwitchListTile(
              title: const Text('Vender productos'),
              value: sellProducts,
              onChanged: (value) => setState(() => sellProducts = value),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    final access = {
                      'deleteStudents': deleteStudents,
                      'watchIncome': watchIncome,
                      'setPlans': setPlans,
                      'setEvaluations': setEvaluations,
                      'deletePayments': deletePayments,
                      'addProfesor' : addProfesor,
                      'editPast': editPast,
                      'editProducts': editProducts,
                      'sellProducts': sellProducts,
                    };
                    final newAccess = widget.access.copyWith(
                      permissions: jsonEncode(access),
                    );
                    Amplify.DataStore.save(newAccess);
                    Navigator.pop(context);
                  },
                  label: const Text('Guardar Cambios'),
                  icon: const Icon(Icons.save),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}