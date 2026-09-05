import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/providers/attendant_students_provider.dart';
import 'package:la_dinamica_app/providers/create_queries_aws.dart';
import 'package:la_dinamica_app/providers/date_provider_new.dart';
import 'package:la_dinamica_app/providers/income_summary_provider.dart';
import 'package:la_dinamica_app/providers/user_provider.dart';

class SelectSchoolWidget extends ConsumerStatefulWidget {
  const SelectSchoolWidget({super.key});

  @override
  ConsumerState<SelectSchoolWidget> createState() => _SelectSchoolState();
}

class _SelectSchoolState extends ConsumerState<SelectSchoolWidget> {
  Future<void> _editSchoolName(BuildContext context, access) async {
    final name = await showDialog<String>(
      context: context,
      builder: (_) => EditSchoolNameDialog(initialName: access.tenant!.name),
    );

    if (name == null || name == access.tenant!.name) return;
    await DataStoreService().changeTenantName(
      tenant: access.tenant!,
      name: name,
    );
    ref.invalidate(userProvider);
  }

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
                      ...user.userAccess!.map((access) {
                        final permissions = Map<String, bool>.from(
                          jsonDecode(access.permissions!),
                        );
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            children: [
                              Expanded(
                                child: CupertinoButton(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 8,
                                  ),
                                  onPressed: () {
                                    ref
                                        .read(userProvider.notifier)
                                        .updateUser(
                                          tenant: access.tenant!,
                                          schoolname: access.tenant!.name,
                                          permissions: permissions,
                                          plan: access.tenant!.plan!,
                                        );
                                    ref
                                        .read(
                                          studentsAttendanceProvider.notifier,
                                        )
                                        .setAttendanceToday(
                                          ref.read(dateProvider).today,
                                        );
                                    ref
                                        .read(incomeSummaryProvider.notifier)
                                        .clear();
                                    Navigator.pop(context);
                                  },
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(access.tenant!.name),
                                  ),
                                ),
                              ),
                              PopupMenuButton<String>(
                                tooltip: 'Opciones de escuela',
                                onSelected: (value) {
                                  if (value == 'edit') {
                                    _editSchoolName(context, access);
                                  }
                                },
                                itemBuilder:
                                    (context) => const [
                                      PopupMenuItem<String>(
                                        value: 'edit',
                                        child: Text('Editar nombre'),
                                      ),
                                    ],
                              ),
                            ],
                          ),
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

class EditSchoolNameDialog extends StatefulWidget {
  const EditSchoolNameDialog({required this.initialName, super.key});

  final String initialName;

  @override
  State<EditSchoolNameDialog> createState() => _EditSchoolNameDialogState();
}

class _EditSchoolNameDialogState extends State<EditSchoolNameDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar nombre de la escuela'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        textCapitalization: TextCapitalization.words,
        decoration: const InputDecoration(labelText: 'Nombre'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () {
            final name = _controller.text.trim();
            if (name.isNotEmpty) {
              Navigator.pop(context, name);
            }
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
