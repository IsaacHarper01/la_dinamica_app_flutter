import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/config/provider/theme_provider.dart';
import 'package:la_dinamica_app/providers/plan_provider.dart';
import 'package:la_dinamica_app/screens/add_new_plan.dart';
import 'package:la_dinamica_app/widgets/section_card_widget.dart';

import '../model/plan.dart';
import '../widgets/theme_selector_widget.dart';

class ConfigScreen extends ConsumerStatefulWidget {
  const ConfigScreen({super.key});

  @override
  ConsumerState<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends ConsumerState<ConfigScreen> {
  @override
  Widget build(BuildContext context) {
    final plansState = ref.watch(planProvider);
    final themeMode = ref.watch(themeNotifierProvider);
    final colorScheme = ColorScheme.of(context);
    final textTheme = TextTheme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes'),
        centerTitle: true,
        actions: [
          ThemeSelector(
            themeMode: themeMode,
            onChanged: (mode) {
              ref.read(themeNotifierProvider.notifier).setTheme(mode);
            },
          ),
        ],
      ),
      body: plansState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
        data: (planes) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
          child: ListView(
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.lock_clock),
                label: const Text('Habilitar vencimiento'),
                onPressed: () {
                  // TODO: Implementar funcionalidad de habilitar vencimiento
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  textStyle: textTheme.titleMedium,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SectionCard(
                title: 'Planes disponibles',
                actions: [
                  OutlinedButton.icon(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AddNewPlan()),
                      );
                      if (result == true) {
                        ref.read(planProvider.notifier).loadPlans();
                      }
                    },
                    icon: const Icon(Icons.add_circle_outline),
                    label: const Text('Nuevo Plan'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
                child: Column(
                  children: planes
                      .map((plan) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: PlanCard(
                              plan: plan,
                              onDelete: () {
                                ref
                                    .read(planProvider.notifier)
                                    .deletePlan(plan.id);
                              },
                            ),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlanCard extends StatelessWidget {
  final Plan plan;
  final VoidCallback onDelete;

  const PlanCard({
    super.key,
    required this.plan,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final colorScheme = ColorScheme.of(context);
    final textTheme = TextTheme.of(context);

    return Card(
      elevation: 2,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          spacing: 12,
          children: [
            Icon(Icons.fitness_center, color: colorScheme.primary),
            Expanded(
              child: Column(
                spacing: 6,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plan.type,
                    style: textTheme.bodyLarge!.copyWith(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    spacing: 4,
                    children: [
                      Icon(
                        Icons.class_,
                        size: 18,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      Text(
                        '${plan.clases} clases',
                        style: textTheme.labelLarge,
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.attach_money,
                        size: 18,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      Text(
                        '\$${plan.price.toStringAsFixed(2)}',
                        style: textTheme.labelLarge,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (value) async {
                if (value == 'delete') {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('¿Eliminar Plan?'),
                      content: const Text(
                        'Esta acción no se puede deshacer. ¿Estás seguro?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancelar'),
                        ),
                        FilledButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Eliminar'),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    onDelete();
                  }
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem<String>(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.redAccent),
                      SizedBox(width: 8),
                      Text('Eliminar'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
