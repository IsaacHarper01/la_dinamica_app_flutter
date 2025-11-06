import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/model/UserLocal.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';
import 'package:la_dinamica_app/providers/date_provider.dart';
import 'package:la_dinamica_app/providers/sales_provider.dart';


class SalesScreen extends ConsumerStatefulWidget {
  final UserLocal user;

  const SalesScreen({
    super.key,
    required this.user,
    });

  @override
  ConsumerState<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends ConsumerState<SalesScreen> {
  
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(salesProvider.notifier)
         .fetchTodaySales();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final salesAsync = ref.watch(salesProvider);
    final date = ref.watch(dateProvider);
    return salesAsync.when(
      data:(sales) => Scaffold(
        appBar: AppBar(title: Center(child: Text("Ventas de $date"))),
        body: ListView.builder(
              itemCount: sales.length,
              itemBuilder: (context, index) {
                final sale = sales[index];
                return SaleCard(
                  sale: sale,
                  permision: widget.user.permissions["deletePayments"]!,
                  setDebt: ()async{
                      safePrint("Adeudo guardado correctamente");
                  },
                  onDelete: () async {
                    safePrint('Eliminando pago con ID: ${sale.id}');
                  },
                );
              },
            ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async{
            }, 
          child: Icon(Icons.add),
          ),
    ),
    error: (error, stackTrace) => Center(),
    loading: () => Center(child: CircularProgressIndicator()),
  );
  }
}

class SaleCard extends StatelessWidget {
  final Sale sale;
  final VoidCallback onDelete;
  final VoidCallback setDebt;
  final bool permision;

  const SaleCard({
    super.key, 
    required this.sale, 
    required this.onDelete,
    required this.setDebt,
    required this.permision,
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
                    sale.product!.name!,
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
                        '${sale.date}',
                        style: textTheme.labelLarge,
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.attach_money,
                        size: 18,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      Text(
                        sale.price!.toStringAsFixed(2),
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
              if (value == 'edit'){
                 
              }
              if (value=='debt'){
               setDebt();
              }
            },
              itemBuilder:
                  (context) => [
                    if(permision)...[
                    const PopupMenuItem<String>(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.redAccent),
                          SizedBox(width: 8),
                          Text('Eliminar'),
                        ],
                      ),
                    )],
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