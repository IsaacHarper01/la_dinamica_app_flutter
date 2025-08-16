import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:la_dinamica_app/config/theme/app_theme.dart';
import 'package:la_dinamica_app/model/UserLocal.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';
import 'package:la_dinamica_app/providers/create_queries_aws.dart';
import 'package:la_dinamica_app/providers/user_provider.dart';
import 'package:la_dinamica_app/screens/add_students_evaluation.dart';

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
    _metrics.add(_MetricForm(isSubmetric: false));
  }

  void _addMetric() {
    setState(() {
      _metrics.add(_MetricForm(isSubmetric: false));
    });
  }

  void _addSubmetric() {
    setState(() {
      _metrics.add(_MetricForm(isSubmetric: true));
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

  // Save evaluation first
  final evaluation = await awsDb.saveEvaluation(
    name: examName,
    gymId: user.tenantId,
  );

  // Save metrics and join them
  for (var metric in _metrics) {
    final metricObject = await awsDb.saveMetric(
      name: metric._metricController.text,
      tenantId: user.tenantId,
      description: metric._descriptionController.text,
      type: metric._selectedOption,
    );
    await awsDb.saveJoinedMetric(
      metric: metricObject,
      evaluation: evaluation,
      tenantId: user.tenantId,
    );
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _addMetric,
                  icon: const Icon(Icons.add),
                  label: const Text('Nueva Prueba'),
                ),
                ElevatedButton.icon(
                  onPressed: _addSubmetric,
                  icon: const Icon(Icons.subdirectory_arrow_right),
                  label: const Text('Nueva SubPrueba'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    saveData(userAsync);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExamStudentSelectionPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Aplicar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
        });
  }
}

// 🧱 Reusable form widget
class _MetricForm extends StatelessWidget {
  final bool isSubmetric;

  _MetricForm({required this.isSubmetric});

  final TextEditingController _metricController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final List<String> _dropdownOptions = ['Base10', 'Tiempo'];
  String _selectedOption = 'Base10';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: isSubmetric ? 32.0 : 0,
        bottom: 16.0,
      ),
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: TextField(
              controller: _metricController,
              decoration: 
                isSubmetric ? InputDecoration(labelText: 'SubPrueba',border: OutlineInputBorder()): InputDecoration(labelText: 'Prueba',border: OutlineInputBorder()),
            ),
          ),
          Flexible(
            flex: 3,
            child: TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Descripción', border: OutlineInputBorder()),
            ),
          ),
          Flexible(
            flex: 1,
            child: DropdownButtonFormField<String>(
              focusColor: colorList[4],
              decoration: const InputDecoration(border: OutlineInputBorder()),
              value: _selectedOption,
              items: _dropdownOptions
                  .map((option) =>
                      DropdownMenuItem(value: option, child: Text(option)))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  _selectedOption = value;
                }
              },
            ),
          )
        ],

      ),
    );
  }
}
