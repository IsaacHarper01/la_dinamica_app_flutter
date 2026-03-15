import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:la_dinamica_app/model/UserLocal.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';
import 'package:la_dinamica_app/providers/date_provider.dart';
import 'package:la_dinamica_app/providers/lastPayments_provider.dart';
import 'package:la_dinamica_app/widgets/payment_box.dart';

class EditpaymentsScreen extends ConsumerStatefulWidget {
  final UserLocal user;
  final Student student;

  const EditpaymentsScreen({
    super.key,
    required this.user,
    required this.student,
    });

  @override
  ConsumerState<EditpaymentsScreen> createState() => _EditpaymentsScreenState();
}

class _EditpaymentsScreenState extends ConsumerState<EditpaymentsScreen> {
  
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(paymentsProvider.notifier)
         .fetchLastPayments(widget.user, widget.student);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final paymentsAsync = ref.watch(paymentsProvider);
    final date = ref.watch(dateProvider);

    return paymentsAsync.when(
      data:(payments) => Scaffold(
        appBar: AppBar(title: Center(child: Text("Ultimos Pagos"))),
        body: RefreshIndicator(
          onRefresh: () async{
            ref.read(paymentsProvider.notifier).fetchLastPayments(widget.user, widget.student);
          },
          child: ListView.builder(
                itemCount: payments.length,
                itemBuilder: (context, index) {
                  final payment = payments[index];
                  final payStatus = payment.debt == true ? false : true;
                  return PayCard(
                    payment: payment,
                    permision: widget.user.permissions["deletePayments"]!,
                    setDebt: ()async{
                        await ref.read(paymentsProvider.notifier).markDebt(widget.user, widget.student, payment, payStatus);
                        safePrint("Adeudo guardado correctamente");
                    },
                    onDelete: () async {
                      await ref.read(paymentsProvider.notifier).deletePay(payment.id, widget.user, widget.student);
                      safePrint('Eliminando pago con ID: ${payment.id}');
                    },
                  );
                },
              ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async{
              await showPaymentDialog(context, ref, student: widget.student,name: widget.student.name! , date: date, user: widget.user);
              ref.read(paymentsProvider.notifier)
                 .fetchLastPayments(widget.user, widget.student);
            }, 
          child: Icon(Icons.add),
          ),
    ),
    error: (error, stackTrace) => Center(),
    loading: () => Center(child: CircularProgressIndicator()),
  );
  }
}

class PayCard extends StatelessWidget {
  final Payment payment;
  final VoidCallback onDelete;
  final VoidCallback setDebt;
  final bool permision;

  const PayCard({
    super.key, 
    required this.payment, 
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
      color: payment.debt == true ? Color.fromRGBO(114, 33, 33, 0.498) : colorScheme.surface,
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
                    payment.plan!.type!,
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
                        '${payment.date}',
                        style: textTheme.labelLarge,
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.attach_money,
                        size: 18,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      Text(
                        payment.amount!.toStringAsFixed(2),
                        style: textTheme.labelLarge,
                      ),
                    ],
                  ),
                  Text('Registrado por: ${payment.prof_id}',
                      style: GoogleFonts.mulish(
                        fontSize: screenWidth * 0.02,
                        color: colorScheme.onSurfaceVariant,
                      )),
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
                    payment.debt == true ?
                    const PopupMenuItem<String>(
                      value: 'debt',
                      child: Row(
                        children: [
                          Icon(Icons.money, color: Colors.green),
                          SizedBox(width: 8),
                          Text('Pagado'),
                        ],
                      ),
                    ):
                    const PopupMenuItem<String>(
                      value: 'debt',
                      child: Row(
                        children: [
                          Icon(Icons.money_off_sharp, color: Colors.green),
                          SizedBox(width: 8),
                          Text('Adeudo'),
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