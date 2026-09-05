import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';
import 'package:la_dinamica_app/providers/expenses_provider.dart';
import 'package:la_dinamica_app/widgets/metrics_screen/add_expenses_widget.dart';

class HistoryExpensesScreen extends ConsumerStatefulWidget {
  const HistoryExpensesScreen({super.key});

  @override
  ConsumerState<HistoryExpensesScreen> createState() =>
      _HistoryExpensesScreenState();
}

class _HistoryExpensesScreenState extends ConsumerState<HistoryExpensesScreen> {
  static const allCategories = 'Todas las categorías';
  String selectedCategory = allCategories;
  String descriptionFilter = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final expensesAsync = ref.watch(expensesProvider);
    return expensesAsync.when(
      data: (expenses) {
        final categories =
            expenses.rangelist.map((expense) => expense.name).toSet().toList()
              ..sort();
        final activeCategory =
            categories.contains(selectedCategory)
                ? selectedCategory
                : allCategories;
        final normalizedDescription = descriptionFilter.trim().toLowerCase();
        final filteredExpenses =
            expenses.rangelist.where((expense) {
              final matchesCategory =
                  activeCategory == allCategories ||
                  expense.name == activeCategory;
              final matchesDescription =
                  normalizedDescription.isEmpty ||
                  (expense.description ?? '').toLowerCase().contains(
                    normalizedDescription,
                  );
              return matchesCategory && matchesDescription;
            }).toList();

        return Scaffold(
          appBar: AppBar(title: Center(child: Text("Gastos del periodo"))),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                child: DropdownButtonFormField<String>(
                  value: activeCategory,
                  decoration: const InputDecoration(
                    labelText: 'Filtrar por categoría',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.category),
                  ),
                  items: [
                    const DropdownMenuItem<String>(
                      value: allCategories,
                      child: Text(allCategories),
                    ),
                    ...categories.map(
                      (category) => DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      ),
                    ),
                  ],
                  onChanged: (category) {
                    if (category != null) {
                      setState(() {
                        selectedCategory = category;
                      });
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Buscar por descripción',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    setState(() {
                      descriptionFilter = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredExpenses.length,
                  itemBuilder: (context, index) {
                    final expense = filteredExpenses[index];
                    return ExpenseCard(
                      expense: expense,
                      onDelete: () async {
                        safePrint('Eliminando gasto con ID: ${expense.id}');
                        ref
                            .read(expensesProvider.notifier)
                            .deleteExpense(expense);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              showDialog(context: context, builder: (_) => AddExpensesWidget());
            },
            child: Icon(Icons.add),
          ),
        );
      },
      error: (error, stackTrace) => Center(),
      loading: () => Center(child: CircularProgressIndicator()),
    );
  }
}

class ExpenseCard extends StatelessWidget {
  final Expense expense;
  final VoidCallback onDelete;

  const ExpenseCard({super.key, required this.expense, required this.onDelete});

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
                      Text('${expense.date}', style: textTheme.labelLarge),
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
                  if (expense.description?.trim().isNotEmpty ?? false)
                    Text(
                      expense.description!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
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
                if (value == 'edit') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) =>
                              AddExpensesWidget(onEdit: true, expense: expense),
                    ),
                  );
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
