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
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final permissions = {
                      'deleteStudents': deleteStudents,
                      'watchIncome': watchIncome,
                      'setPlans': setPlans,
                    };
                    Navigator.pop(context, permissions);
                  },
                  child: const Text('Aceptar'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}