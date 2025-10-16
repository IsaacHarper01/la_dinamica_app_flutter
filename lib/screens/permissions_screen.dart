import 'package:flutter/material.dart';

class PermissionsScreen extends StatefulWidget{
  const PermissionsScreen({super.key});

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  
  bool deleteStudents = false;
  bool watchIncome = false;
  bool setPlans = false;
  bool setEvaluations = false;
  bool deletePayments = false;
  bool addProfesor = false;
  bool editPast = false;
  
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
                    final permissions = {
                      'deleteStudents': deleteStudents,
                      'watchIncome': watchIncome,
                      'setPlans': setPlans,
                      'setEvaluations': setEvaluations,
                      'deletePayments': deletePayments,
                      'addProfesor' : addProfesor,
                      'editPast': editPast,
                    };
                    Navigator.pop(context, permissions);
                  },
                  label: const Text('Agregar profesor'),
                  icon: const Icon(Icons.person_add_outlined),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}