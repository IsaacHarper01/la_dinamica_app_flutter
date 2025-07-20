import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/providers/create_queries_aws.dart';
import 'package:la_dinamica_app/providers/user_provider.dart';

class AddNewMetric extends ConsumerStatefulWidget {
  const AddNewMetric({super.key});

  @override
  ConsumerState<AddNewMetric> createState() => _AddNewMetricState();
}

class _AddNewMetricState extends ConsumerState<AddNewMetric> {

  final List<String> labels = ['Nombre', 'Valor minimo', 'Valor máximo', 'Categoría'];
  final List<TextEditingController> _controllers = 
      List.generate(4, (index) => TextEditingController());
  
  final _formKey = GlobalKey<FormState>();
  final awsDB = DataStoreService();

  void _registerMetric() async {
    // Verificar si el formulario es válido
    if (_formKey.currentState?.validate() ?? false) {
      // Recuperar texto de cada TextEditingController
      final user = await ref.watch(userProvider.future);
      final gymId = user.tenantId; 
      final Map<String, dynamic> metric = {
        'name': _controllers[0].text,
        'minValue': double.parse(_controllers[1].text),
        'maxValue': double.parse(_controllers[2].text),
        'category': _controllers[3].text.isNotEmpty ? _controllers[3].text : null,
      };

      try{
        await awsDB.saveMetricsType(
          name: metric['name'], 
          minValue: metric['minValue'], 
          maxValue: metric['maxValue'], 
          category: metric['category'], 
          gymId: gymId, 
          );
          Navigator.pop(context!, true);
      } catch (e) {
        safePrint('❌ Error al guardar la métrica: $e');
      }
    }}

  @override
  Widget build(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Métrica'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey, // Asociar la clave global al formulario
          child: Column(
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                color: colorScheme.surface,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    spacing: 20,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Agregar nueva Métrica',
                        style: textTheme.headlineSmall?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      ...List.generate(labels.length, (i) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: TextFormField(
                            controller: _controllers[i],
                            style: TextStyle(color: colorScheme.onSurface),
                            decoration: InputDecoration(
                              labelText: labels[i],
                              labelStyle:
                                  TextStyle(color: colorScheme.onSurface),
                              filled: true,
                              fillColor: colorScheme.surfaceDim,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, ingrese ${labels[i].toLowerCase()}';
                              }
                              return null;
                            },
                            keyboardType: i == 1
                                ? TextInputType.number
                                : i == 2
                                    ? const TextInputType.numberWithOptions(
                                        decimal: true)
                                    : TextInputType.text,
                          ),
                        );
                      }),
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        onPressed: () {
                          _registerMetric();
                          },
                        icon: const Icon(Icons.save),
                        label: const Text('Registrar'),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                          textStyle: const TextStyle(fontSize: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
