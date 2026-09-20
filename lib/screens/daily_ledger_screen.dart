import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/model/UserLocal.dart';
import 'package:la_dinamica_app/models/ExtraPay.dart';
import 'package:la_dinamica_app/providers/date_provider_new.dart';
import 'package:la_dinamica_app/providers/extra_pay_provider.dart';
import 'package:la_dinamica_app/providers/income_plan_provider.dart';
import 'package:la_dinamica_app/providers/sales_provider.dart';

class DailyLedgerScreen extends ConsumerStatefulWidget {
  final UserLocal user;

  const DailyLedgerScreen({super.key, required this.user});

  @override
  ConsumerState<DailyLedgerScreen> createState() => _DailyLedgerScreenState();
}

class _DailyLedgerScreenState extends ConsumerState<DailyLedgerScreen> {
  String selectedPerson = 'Todos';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(salesProvider.notifier).setTodaySales();
      ref.read(incomePlanProvider.notifier).setTodayPayments();
      ref.read(extraPayProvider.notifier).setTodayExtraPays();
    });
  }

  @override
  Widget build(BuildContext context) {
    final date = ref.watch(dateProvider).today;
    final paymentsAsync = ref.watch(incomePlanProvider);
    final salesAsync = ref.watch(salesProvider);
    final extraPaysAsync = ref.watch(extraPayProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Resumen del día')),
      body: paymentsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
        data: (paymentsModel) {
          final paymentEntries = paymentsModel.dayList;
          return salesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Center(child: Text('Error: $error')),
            data: (salesModel) {
              final saleEntries = salesModel.dayList;
              return extraPaysAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error:
                    (error, stackTrace) => Center(child: Text('Error: $error')),
                data: (extraPaysModel) {
                  final extraPayEntries = extraPaysModel.dayList;
                  final allEntries = <_DailyLedgerEntry>[];

                  for (final payment in paymentEntries) {
                    allEntries.add(
                      _DailyLedgerEntry(
                        label: payment.plan?.type ?? 'Pago',
                        person: payment.prof_id ?? 'Sin registro',
                        amount: payment.amount ?? 0,
                        date: payment.date?.format() ?? date,
                        type: 'Pago',
                      ),
                    );
                  }

                  for (final sale in saleEntries) {
                    allEntries.add(
                      _DailyLedgerEntry(
                        label: sale.product.name ?? 'Venta',
                        person: sale.profname ?? 'Sin registro',
                        amount: sale.price ?? 0,
                        date: sale.date?.format() ?? date,
                        type: 'Venta',
                      ),
                    );
                  }

                  for (final extraPay in extraPayEntries) {
                    allEntries.add(
                      _DailyLedgerEntry(
                        label: extraPay.category ?? 'Ingreso extra',
                        person: extraPay.prof_id ?? 'Sin registro',
                        amount: extraPay.amount ?? 0,
                        date: extraPay.date?.format() ?? date,
                        type: 'Ingreso extra',
                        extraPay: extraPay,
                      ),
                    );
                  }

                  final isAdmin =
                      widget.user.userAccess?.any(
                        (access) => access.isAdmin == true,
                      ) ??
                      false;
                  final currentUserName = widget.user.name;
                  final List<_DailyLedgerEntry> visibleEntries =
                      isAdmin
                          ? allEntries
                          : allEntries
                              .where((entry) => entry.person == currentUserName)
                              .toList();

                  final people = <String>{'Todos'};
                  if (isAdmin) {
                    for (final entry in allEntries) {
                      people.add(entry.person);
                    }
                  }

                  final filteredEntries =
                      isAdmin
                          ? (selectedPerson == 'Todos'
                              ? allEntries
                              : allEntries
                                  .where(
                                    (entry) => entry.person == selectedPerson,
                                  )
                                  .toList())
                          : visibleEntries;

                  final total = filteredEntries.fold<double>(
                    0,
                    (sum, entry) => sum + entry.amount,
                  );

                  return SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (isAdmin) ...[
                                    const Text(
                                      'Filtrar por persona',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    DropdownButtonFormField<String>(
                                      value: selectedPerson,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        prefixIcon: Icon(Icons.person),
                                      ),
                                      items:
                                          people
                                              .map(
                                                (person) => DropdownMenuItem(
                                                  value: person,
                                                  child: Text(person),
                                                ),
                                              )
                                              .toList(),
                                      onChanged: (value) {
                                        if (value != null) {
                                          setState(
                                            () => selectedPerson = value,
                                          );
                                        }
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                  ] else ...[
                                    const Text(
                                      'Registros del usuario',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                  ],
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _SummaryTile(
                                          title: 'Registros',
                                          value: '${filteredEntries.length}',
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: _SummaryTile(
                                          title: 'Total',
                                          value:
                                              '\$${total.toStringAsFixed(2)}',
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child:
                                filteredEntries.isEmpty
                                    ? const Center(
                                      child: Text(
                                        'No hay registros para este filtro.',
                                      ),
                                    )
                                    : ListView.separated(
                                      itemCount: filteredEntries.length,
                                      separatorBuilder:
                                          (_, __) => const Divider(height: 1),
                                      itemBuilder: (context, index) {
                                        final entry = filteredEntries[index];
                                        return ListTile(
                                          leading: CircleAvatar(
                                            backgroundColor:
                                                entry.type == 'Pago'
                                                    ? Colors.green.shade100
                                                    : entry.type ==
                                                        'Ingreso extra'
                                                    ? Colors.orange.shade100
                                                    : Colors.blue.shade100,
                                            child: Icon(
                                              entry.type == 'Venta'
                                                  ? Icons.shopping_bag_outlined
                                                  : Icons.attach_money,
                                              color:
                                                  entry.type == 'Pago'
                                                      ? Colors.green.shade800
                                                      : entry.type ==
                                                          'Ingreso extra'
                                                      ? Colors.orange.shade800
                                                      : Colors.blue.shade800,
                                            ),
                                          ),
                                          title: Text(entry.label),
                                          subtitle: Text(
                                            '${entry.type} • ${entry.person} • ${entry.date}',
                                          ),
                                          trailing:
                                              entry.extraPay == null
                                                  ? Text(
                                                    '\$${entry.amount.toStringAsFixed(2)}',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  )
                                                  : Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        '\$${entry.amount.toStringAsFixed(2)}',
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      IconButton(
                                                        tooltip:
                                                            'Editar ingreso extra',
                                                        icon: const Icon(
                                                          Icons.edit_outlined,
                                                        ),
                                                        onPressed:
                                                            () =>
                                                                _showEditExtraPayDialog(
                                                                  entry
                                                                      .extraPay!,
                                                                ),
                                                      ),
                                                    ],
                                                  ),
                                        );
                                      },
                                    ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddExtraPayDialog,
        tooltip: 'Agregar ingreso extra',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showAddExtraPayDialog() async {
    final saved = await showDialog<bool>(
      context: context,
      builder: (_) => _AddExtraPayDialog(profId: widget.user.name),
    );
    if (saved == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingreso extra registrado.')),
      );
    }
  }

  Future<void> _showEditExtraPayDialog(ExtraPay extraPay) async {
    final updated = await showDialog<bool>(
      context: context,
      builder:
          (_) =>
              _AddExtraPayDialog(profId: widget.user.name, extraPay: extraPay),
    );
    if (updated == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingreso extra actualizado.')),
      );
    }
  }
}

class _AddExtraPayDialog extends ConsumerStatefulWidget {
  final String profId;
  final ExtraPay? extraPay;

  const _AddExtraPayDialog({required this.profId, this.extraPay});

  @override
  ConsumerState<_AddExtraPayDialog> createState() => _AddExtraPayDialogState();
}

class _AddExtraPayDialogState extends ConsumerState<_AddExtraPayDialog> {
  final categoryController = TextEditingController();
  final amountController = TextEditingController();
  String? errorText;
  bool isSaving = false;

  bool get isEditing => widget.extraPay != null;

  @override
  void initState() {
    super.initState();
    final extraPay = widget.extraPay;
    if (extraPay != null) {
      categoryController.text = extraPay.category ?? '';
      amountController.text = extraPay.amount?.toString() ?? '';
    }
  }

  @override
  void dispose() {
    categoryController.dispose();
    amountController.dispose();
    super.dispose();
  }

  Future<void> save() async {
    final amount = double.tryParse(amountController.text.trim());
    final category = categoryController.text.trim();
    if (category.isEmpty || amount == null || amount <= 0) {
      setState(
        () => errorText = 'Ingresa una categoría y una cantidad válida.',
      );
      return;
    }

    setState(() {
      isSaving = true;
      errorText = null;
    });
    try {
      if (isEditing) {
        await ref
            .read(extraPayProvider.notifier)
            .updateExtraPay(
              extraPay: widget.extraPay!,
              amount: amount,
              category: category,
            );
      } else {
        await ref
            .read(extraPayProvider.notifier)
            .addExtraPay(
              amount: amount,
              category: category,
              profId: widget.profId,
            );
      }
      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          isSaving = false;
          errorText = 'No se pudo guardar el ingreso.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isEditing ? 'Editar ingreso extra' : 'Agregar ingreso extra'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: categoryController,
            decoration: const InputDecoration(
              labelText: 'Categoría',
              prefixIcon: Icon(Icons.category_outlined),
            ),
          ),
          TextField(
            controller: amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Cantidad',
              prefixIcon: const Icon(Icons.attach_money),
              errorText: errorText,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: isSaving ? null : () => Navigator.pop(context, false),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: isSaving ? null : save,
          child:
              isSaving
                  ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                  : Text(isEditing ? 'Actualizar' : 'Guardar'),
        ),
      ],
    );
  }
}

class _DailyLedgerEntry {
  final String label;
  final String person;
  final double amount;
  final String date;
  final String type;
  final ExtraPay? extraPay;

  const _DailyLedgerEntry({
    required this.label,
    required this.person,
    required this.amount,
    required this.date,
    required this.type,
    this.extraPay,
  });
}

class _SummaryTile extends StatelessWidget {
  final String title;
  final String value;

  const _SummaryTile({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
