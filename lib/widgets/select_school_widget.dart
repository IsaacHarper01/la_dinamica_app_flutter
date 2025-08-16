import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
                        return CupertinoActionSheetAction(
                          onPressed: () {
                            ref
                                .read(userProvider.notifier)
                                .updateUser(
                                  tenantId: access.tenant!.tenant_id,
                                  schoolname: access.tenant!.name,
                                  permissions: access.permissions!,
                                  plan: access.tenant!.plan!,
                                );
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
