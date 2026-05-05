import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/config/provider/theme_provider.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';
import 'package:la_dinamica_app/providers/default_plan_provider.dart';
import 'package:la_dinamica_app/providers/plan_provider.dart';
import 'package:la_dinamica_app/providers/user_provider.dart';
import 'package:la_dinamica_app/screens/add_new_plan.dart';
import 'package:la_dinamica_app/screens/profesors_screen.dart';
import 'package:la_dinamica_app/widgets/config_page.dart/section_card_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../widgets/config_page.dart/theme_selector_widget.dart';

class ConfigScreen extends ConsumerStatefulWidget {
  const ConfigScreen({super.key});

  @override
  ConsumerState<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends ConsumerState<ConfigScreen> {
  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    final bool isPortatil = orientation == Orientation.portrait;
    final screenWidth = isPortatil ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.width * 0.8;
    final plansState = ref.watch(planProvider);
    final themeMode = ref.watch(themeNotifierProvider);
    final userAsync = ref.watch(userProvider);
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
      body: userAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
        data: (userAsync) => plansState.when(
          loading:() =>  Center(child: CircularProgressIndicator(),),
          error: (error, stackTrace) => Center(child: Text("Error al cargar usuario $error"),),
          data: (planes) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
          child: ListView(
            children: [
              if(userAsync.permissions!["addProfesor"]!)...
              [
                ElevatedButton.icon(
                icon: const Icon(Icons.school_outlined),
                label: const Text('Permisos y Profesores'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProfesorsScreen(user: userAsync),
                    ),
                  );
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
              ],
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: const Icon(Icons.qr_code),
                  label: const Text('QR para nuevo acceso'),
                  onPressed: () async{
                      _showQrCodeDialog(context, '{"action":"newAccess","profID":"${userAsync.user}"}');
                  } ,
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
                  userAsync.permissions!["setPlans"]! ?
                  OutlinedButton.icon(
                      onPressed: () 
                      async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => AddNewPlan()),
                        );
                        if (result == true) {
                          ref.read(planProvider.notifier).loadPlans();
                        }
                      },
                      icon: const Icon(Icons.add_circle_outline),
                      label: Center(child: const Text('Nuevo Plan')),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colorScheme.onPrimaryContainer,
                        maximumSize: Size((screenWidth * 0.3), 40),
                      ),
                    ): Container(),
                ],
                child: Column(
                  children: planes
                      .map((plan) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: PlanCard(
                              plan: plan,
                              permission: userAsync.permissions!["setPlans"]!,
                              onSetDefault: () {
                                setPlanDefault(plan, ref);
                              },
                              unSetDefault: (){
                                unSetDefaultPlan(ref, plan);
                              },
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
        )
      ),
    );
  }
}

void setPlanDefault(LocalPlan plan, WidgetRef ref){
  final oldPlan = ref.read(defaultPlanProvider);
  ref.read(planProvider.notifier).updatePlanDefaultStatus(oldPlan, plan);
  ref.read(defaultPlanProvider.notifier).state = plan;
  safePrint('Plan predeterminado establecido: ${ref.read(defaultPlanProvider).type}');
}

Future<void> unSetDefaultPlan(WidgetRef ref, LocalPlan plan)async{
  final updatedPlan = plan.copyWith(defaultPlan: false);
  await Amplify.DataStore.save(updatedPlan);
  ref.read(planProvider.notifier).loadPlans();
}

void _showQrCodeDialog(BuildContext context, String dataToEncode){
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.all(24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Este código contiene tu identificador de profesor para solicitar nuevos accesos',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 250,
              height: 250,
              child: QrImageView(
                      data: dataToEncode, 
                      size: 200,
                      backgroundColor: Colors.white,
                      ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.close),
              label: const Text('Cerrar'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }

class PlanCard extends StatelessWidget {
  final LocalPlan plan;
  final VoidCallback onDelete;
  final VoidCallback onSetDefault;
  final VoidCallback unSetDefault;
  final bool permission;

  const PlanCard({
    super.key, 
    required this.plan, 
    required this.onDelete,
    required this.onSetDefault,
    required this.unSetDefault,
    required this.permission,
    });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final colorScheme = ColorScheme.of(context);
    final textTheme = TextTheme.of(context);

    return Card(
      elevation: 10,
      color: plan.defaultPlan == true ? colorScheme.surface.withGreen(70) : colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                    plan.type!,
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
                        plan.price!.toStringAsFixed(2),
                        style: textTheme.labelLarge,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if(permission)...[
            PopupMenuButton<String>(
              onSelected: (value) async {
                if (value == 'delete') {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder:
                        (_) => AlertDialog(
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
              if (value == 'default') {
                  onSetDefault();
                }
              if (value == 'undefault'){
                unSetDefault();
              }
              if(value == 'update'){
                Navigator.push(context, 
                  MaterialPageRoute(builder: (_)=> 
                    AddNewPlan(edit:true, oldPlan: plan,)));
              }
              },
              itemBuilder:
                  (context) => [
                    const PopupMenuItem<String>(
                      value: 'update',
                      child: Row(
                        children: [
                          Icon(Icons.edit, color: Colors.blueAccent),
                          SizedBox(width: 8),
                          Text('Editar'),
                        ],
                      ),
                    ),
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
                    plan.defaultPlan == true ?
                    const PopupMenuItem<String>(
                      value: 'undefault',
                      child: Row(
                        children: [
                          Icon(Icons.bookmark_add_outlined, color: Colors.redAccent),
                          SizedBox(width: 8),
                          Text('quitar predeterminado'),
                        ],
                      ),
                    ): 
                    const PopupMenuItem<String>(
                      value: 'default',
                      child: Row(
                        children: [
                          Icon(Icons.bookmark_add_outlined, color: Colors.green),
                          SizedBox(width: 8),
                          Text('predeterminado'),
                        ],
                      ),
                    ),
                  ],
            ),]
          ],
        ),
      ),
    );
  }
}
