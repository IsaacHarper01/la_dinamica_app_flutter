import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';
import 'package:la_dinamica_app/providers/expenses_provider.dart';
import 'package:la_dinamica_app/widgets/metrics_screen/add_expenses_widget.dart';

class HistoryExpensesScreen extends ConsumerStatefulWidget {

  const HistoryExpensesScreen({
    super.key,
    });

  @override
  ConsumerState<HistoryExpensesScreen> createState() => _HistoryExpensesScreenState();
}

class _HistoryExpensesScreenState extends ConsumerState<HistoryExpensesScreen> {
  
  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    final expensesAsync = ref.watch(expensesProvider);
    return expensesAsync.when(
      data:(expenses) => Scaffold(
        appBar: AppBar(title: Center(child: Text("Gastos del periodo"))),
        body: ListView.builder(
              itemCount: expenses.rangelist.length,
              itemBuilder: (context, index) {
                final expense = expenses.rangelist[index];
                return ExpenseCard(
                  expense: expense,
                  onDelete: () async {
                    safePrint('Eliminando gasto con ID: ${expense.id}');
                  },
                );
              },
            ),
    ),
    error: (error, stackTrace) => Center(),
    loading: () => Center(child: CircularProgressIndicator()),
  );
  }
}

class ExpenseCard extends StatelessWidget {
  final Expense expense;
  final VoidCallback onDelete;

  const ExpenseCard({
    super.key, 
    required this.expense, 
    required this.onDelete,
    });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final colorScheme = ColorScheme.of(context);
    final textTheme = TextTheme.of(context);

    return Card(
      elevation: 10,
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
                    expense.name,
                    style: textTheme.bodyLarge!.copyWith(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    spacing: 4,
                    children: [
                      Icon(
                        Icons.attach_money,
                        size: 18,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      Text(
                        '${expense.date}',
                        style: textTheme.labelLarge,
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.attach_money,
                        size: 18,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      Text(
                        expense.amount.toStringAsFixed(2),
                        style: textTheme.labelLarge,
                      ),
                    ],
                  ),
                  // Text('Registrado por: ${payment.prof_id}',
                  //     style: GoogleFonts.mulish(
                  //       fontSize: screenWidth * 0.02,
                  //       color: colorScheme.onSurfaceVariant,
                  //     )),
                ],
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (value) async {
                if (value == 'delete') {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder:
                        (_) => AlertDialog(
                          title: const Text('¿Eliminar Gasto?'),
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
              if (value == 'edit'){
                 Navigator.push(context, MaterialPageRoute(builder: (_)=>
                 AddExpensesWidget(onEdit: true,expense: expense )
                 ));
              }
            },
              itemBuilder:
                  (context) => [
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
                    const PopupMenuItem<String>(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, color: Colors.blueAccent),
                          SizedBox(width: 8),
                          Text('Editar'),
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