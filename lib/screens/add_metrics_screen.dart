import 'package:flutter/material.dart';
import 'package:la_dinamica_app/config/theme/app_theme.dart';
import 'package:la_dinamica_app/screens/add_students_evaluation.dart';

class NewMetricsPage extends StatefulWidget {
  const NewMetricsPage({super.key});

  @override
  State<NewMetricsPage> createState() => _MetricsPageState();
}

class _MetricsPageState extends State<NewMetricsPage> {
  final List<_MetricForm> _metrics = [];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Metrics Builder')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
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
              decoration: isSubmetric ? InputDecoration(labelText: 'SubPrueba'): InputDecoration(labelText: 'Prueba'),
            ),
          ),
          Flexible(
            flex: 5,
            child: TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Descripción'),
            ),
          ),
          Flexible(
            flex: 1,
            child: DropdownButtonFormField<String>(
              focusColor: colorList[4],
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
