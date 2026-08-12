import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/model/UserLocal.dart';
import 'package:la_dinamica_app/providers/date_provider_new.dart';
import 'package:la_dinamica_app/providers/income_plan_provider.dart';
import 'package:la_dinamica_app/providers/sales_provider.dart';

class DailyLedgerScreen extends ConsumerStatefulWidget {
  final UserLocal user;

  const DailyLedgerScreen({
    super.key,
    required this.user,
  });

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
    });
  }

  @override
  Widget build(BuildContext context) {
    final date = ref.watch(dateProvider).today;
    final paymentsAsync = ref.watch(incomePlanProvider);
    final salesAsync = ref.watch(salesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumen del día'),
      ),
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
                    label: sale.product?.name ?? 'Venta',
                    person: sale.profname ?? 'Sin registro',
                    amount: sale.price ?? 0,
                    date: sale.date?.format() ?? date,
                    type: 'Venta',
                  ),
                );
              }

              final isAdmin = widget.user.userAccess?.any((access) => access.isAdmin == true) ?? false;
              safePrint("UserLocal ${widget.user.userAccess}");
              safePrint("IS ADMIN $isAdmin");
              final currentUserName = widget.user.name;
              final List<_DailyLedgerEntry> visibleEntries = isAdmin
                  ? allEntries
                  : allEntries.where((entry) => entry.person == currentUserName).toList();

              final people = <String>{'Todos'};
              if (isAdmin) {
                for (final entry in allEntries) {
                  people.add(entry.person);
                }
              }

              final filteredEntries = isAdmin
                  ? (selectedPerson == 'Todos'
                      ? allEntries
                      : allEntries.where((entry) => entry.person == selectedPerson).toList())
                  : visibleEntries;

              final total = filteredEntries.fold<double>(0, (sum, entry) => sum + entry.amount);

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
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 12),
                                DropdownButtonFormField<String>(
                                  value: selectedPerson,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.person),
                                  ),
                                  items: people
                                      .map(
                                        (person) => DropdownMenuItem(
                                          value: person,
                                          child: Text(person),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (value) {
                                    if (value != null) {
                                      setState(() => selectedPerson = value);
                                    }
                                  },
                                ),
                                const SizedBox(height: 16),
                              ] else ...[
                                const Text(
                                  'Registros del usuario',
                                  style: TextStyle(fontWeight: FontWeight.bold),
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
                                      value: '\$${total.toStringAsFixed(2)}',
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
                        child: filteredEntries.isEmpty
                            ? const Center(
                                child: Text('No hay registros para este filtro.'),
                              )
                            : ListView.separated(
                                itemCount: filteredEntries.length,
                                separatorBuilder: (_, __) => const Divider(height: 1),
                                itemBuilder: (context, index) {
                                  final entry = filteredEntries[index];
                                  return ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: entry.type == 'Pago'
                                          ? Colors.green.shade100
                                          : Colors.blue.shade100,
                                      child: Icon(
                                        entry.type == 'Pago'
                                            ? Icons.attach_money
                                            : Icons.shopping_bag_outlined,
                                        color: entry.type == 'Pago'
                                            ? Colors.green.shade800
                                            : Colors.blue.shade800,
                                      ),
                                    ),
                                    title: Text(entry.label),
                                    subtitle: Text('${entry.type} • ${entry.person} • ${entry.date}'),
                                    trailing: Text(
                                      '\$${entry.amount.toStringAsFixed(2)}',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
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
      ),
    );
  }
}

class _DailyLedgerEntry {
  final String label;
  final String person;
  final double amount;
  final String date;
  final String type;

  const _DailyLedgerEntry({
    required this.label,
    required this.person,
    required this.amount,
    required this.date,
    required this.type,
  });
}

class _SummaryTile extends StatelessWidget {
  final String title;
  final String value;

  const _SummaryTile({
    required this.title,
    required this.value,
  });

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
