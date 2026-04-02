import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/providers/attendant_students_provider.dart';
import 'package:la_dinamica_app/providers/date_provider_new.dart';
import 'package:la_dinamica_app/providers/income_summary_provider.dart';
import 'package:la_dinamica_app/providers/user_provider.dart';

class SelectSchoolWidget extends ConsumerStatefulWidget {
  const SelectSchoolWidget({super.key});

  @override
  ConsumerState<SelectSchoolWidget> createState() => _SelectSchoolState();
}

class _SelectSchoolState extends ConsumerState<SelectSchoolWidget> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    return IconButton(
      onPressed: () {
        user.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(child: Text('Error: $error')),
          data:
              (user) => showCupertinoModalPopup(
                context: context,
                builder: (context) {
                  return CupertinoActionSheet(
                    title: const Text('Selecciona una escuela'),
                    actions: [
                      ...user.userAccess.map((access) {
                        final permissions = Map<String, bool>.from(
                          jsonDecode(access.permissions!),
                        ); 
                        return CupertinoActionSheetAction(
                          onPressed: () {
                            ref
                                .read(userProvider.notifier)
                                .updateUser(
                                  tenant: access.tenant!,
                                  schoolname: access.tenant!.name,
                                  permissions: permissions,
                                  plan: access.tenant!.plan!,
                                );
                            ref.read(studentsAttendanceProvider.notifier).setAttendanceToday(ref.read(dateProvider).today);
                            ref.read(incomeSummaryProvider.notifier).clear();
                            Navigator.pop(context);
                          },
                          child: Text(access.tenant!.name),
                        );
                      }),
                    ],
                    cancelButton: CupertinoActionSheetAction(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancelar'),
                    ),
                  );
                },
              ),
        );
      },
      icon: Icon(
        Icons.assignment_ind_outlined,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
