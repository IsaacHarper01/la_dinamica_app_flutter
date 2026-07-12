import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/config/theme/app_theme.dart';
import 'package:la_dinamica_app/model/UserLocal.dart';
import 'package:la_dinamica_app/providers/income_plan_provider.dart';
import 'package:la_dinamica_app/providers/plan_provider.dart';
import 'package:la_dinamica_app/providers/attendant_students_provider.dart';
import 'package:la_dinamica_app/providers/image_fromS3_provider.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';

Widget _buildStudentPhoto(WidgetRef ref, Student student) {
  final imageKey = student.image;

  if (imageKey == null || imageKey.isEmpty) {
    return Image.asset(
      'assets/images/default_profile.jpg',
      fit: BoxFit.cover,
    );
  }

  final imageUrl = ref.watch(imageProvider(imageKey));

  return imageUrl.when(
    data: (url) => Image.network(
      url ?? '',
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          'assets/images/default_profile.jpg',
          fit: BoxFit.cover,
        );
      },
    ),
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (_, __) => Image.asset(
      'assets/images/default_profile.jpg',
      fit: BoxFit.cover,
    ),
  );
}

Future<void> showPaymentDialog(
  BuildContext context,
  WidgetRef ref, {
  required Student student,
  required String name,
  required String date,
  required UserLocal user,
}) async {
  // Get the current plan state
  final planState = ref.read(planProvider);

  if (planState.isLoading) {

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AlertDialog(
        title: Text('Loading'),
        content: SizedBox(
          height: 80,
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }

  // Ensure data is fetched before continuing
  final plans = ref.read(planProvider).value ?? [];

  if (plans.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No plans available')),
    );
    return;
  }

  // Show the plan selection dialog
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Center(child: const Text('Selecciona un plan')),
      content: SizedBox(
        width: double.maxFinite,
        height: 420,
        child: Column(
          children: [
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: SizedBox(
                width: 90,
                height: 90,
                child: _buildStudentPhoto(ref, student),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              student.name ?? name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Center(child: 
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon(
                  onPressed: () async{
                    await ref
                      .read(studentsAttendanceProvider.notifier)
                      .insertAttendance(student, date);
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Asistencia registrada'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.person_add),
                  label: const Text('Marcar Asistencia'),
                  style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: Colors.green
              ),
            ),
          ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
              itemCount: plans.length,
              itemBuilder: (context, index) {
                final plan = plans[index];
                return Column(
                  children: 
                  [ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    tileColor: colorList[1],
                    title: Text(plan.type ?? 'Unnamed plan'),
                    subtitle: Text(
                      'Price: \$${plan.price?.toStringAsFixed(2)} - Classes: ${plan.clases ?? 0}',
                    ),
                    onTap: () async {
                      try {
                        ref.read(incomePlanProvider.notifier).addPay(
                          student, 
                          plan, 
                          date, 
                          user);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Payment saved for ${plan.type}')),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error saving payment: $e')),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  ]
                );
              },
                        ),
            ),
            SizedBox(height: 20)
          ]
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    ),
  );
}
