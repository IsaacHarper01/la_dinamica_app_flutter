import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:la_dinamica_app/model/UserLocal.dart';
import 'package:la_dinamica_app/providers/create_queries_aws.dart';
import 'package:la_dinamica_app/providers/user_provider.dart';

class NewMetricsPage extends ConsumerStatefulWidget {
  const NewMetricsPage({super.key});

  @override
  MetricsPageState createState() => MetricsPageState();
}

class MetricsPageState extends ConsumerState<NewMetricsPage> {
  final List<_MetricForm> _metrics = [];
  final TextEditingController _examNameController = TextEditingController();
  final awsDb = DataStoreService();

  @override
  void initState() {
    super.initState();
    _metrics.add(_MetricForm());
  }

  void _addMetric() {
    setState(() {
      _metrics.add(_MetricForm());
    });
  }

  Future<void> saveData(UserLocal user) async {
  final examName = _examNameController.text;

  if (examName.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('⚠️ El nombre del examen no puede estar vacío')),
    );
    return;
  }

  if (_metrics.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('⚠️ Debes agregar al menos una métrica')),
    );
    return;
  }

  final evaluation = await awsDb.saveEvaluation(
    name: examName,
    gymId: user.tenant.tenant_id,
  );

  for (var metric in _metrics) {
    
      final metricObject = await awsDb.saveMetric(
        name: metric._metricController.text,
        tenantId: user.tenant.tenant_id,
        description: metric._descriptionController.text,
        type: metric._selectedOption,
        higgerBetter: metric.higgerBetter,
      );

      await awsDb.saveJoinedMetric(
        metric: metricObject,
        evaluation: evaluation,
        tenantId: user.tenant.tenant_id,
      );

      safePrint('✅ Métrica guardada: ${metricObject.name}');
  }
}

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProvider);
    return userAsync.when(
        loading:() => Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (error, stack) => Scaffold(body: Center(child: Text('Error: $error'))),
        data: (userAsync) {
          return Scaffold(
      appBar: AppBar(title: const Text('Diseñar Examen')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  Text(
                    'Nombre del Examen',
                    style: GoogleFonts.michroma(fontSize: 15),
                  ),
                  const SizedBox(height: 10),
                  TextField(controller: _examNameController,
                      decoration: InputDecoration(labelText: 'Nombre del Examen',border: OutlineInputBorder(),),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: ListView.builder(
                itemCount: _metrics.length,
                itemBuilder: (context, index) => _metrics[index],
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child: ElevatedButton.icon(
                      onPressed: _addMetric,
                      icon: const Icon(Icons.add),
                      label: const Text('Nueva Prueba'),
                    ),
                  ),
                  Flexible(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        saveData(userAsync);
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Registrar'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
        });
  }
}

// 🧱 Reusable form widget
class _MetricForm extends StatefulWidget {

  final TextEditingController _metricController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final List<String> _dropdownOptions = ['Base10', 'Tiempo','Repeticiones','Distancia'];
  String _selectedOption = 'Base10';
  bool higgerBetter = true;

  _MetricForm({super.key});

  @override
  State<_MetricForm> createState() => _MetricFormState();
}

class _MetricFormState extends State<_MetricForm>{
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: 16.0,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Checkbox(
                value: widget.higgerBetter, 
                onChanged: (value){
                  setState(() {
                    widget.higgerBetter = value!;
                  });
                }) 
              ),
            Expanded(
              flex: 2,
              child: TextField(
                controller: widget._metricController,
                decoration: InputDecoration(
                  labelText: 'Prueba',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: TextField(
                controller: widget._descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                value: widget._selectedOption,
                items: widget._dropdownOptions
                    .map((option) =>
                        DropdownMenuItem(value: option, child: Text(option)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) widget._selectedOption = value;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
