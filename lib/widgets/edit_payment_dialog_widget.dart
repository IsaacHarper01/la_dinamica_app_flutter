import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/config/theme/app_theme.dart';
import 'package:la_dinamica_app/models/Payment.dart';
import 'package:la_dinamica_app/models/Student.dart';
import 'package:la_dinamica_app/providers/lastPayments_provider.dart';

class EditPaymentDialogWidget extends ConsumerStatefulWidget {
  final Student student;
  final Payment payment;

  const EditPaymentDialogWidget({super.key, required this.student , required this.payment});

  @override
  ConsumerState<EditPaymentDialogWidget> createState() => _EditPaymentDialogWidgetState();
}

class _EditPaymentDialogWidgetState extends ConsumerState<EditPaymentDialogWidget> {
  final amountController = TextEditingController();
  final dateController = TextEditingController();
  final classesController = TextEditingController();


  @override
  void initState() {
    super.initState();
      amountController.text = widget.payment.amount.toString();
      dateController.text = widget.payment.date!.getDateTime().toString().split(" ")[0];
      classesController.text = widget.payment.clases.toString();
  }

  Future<bool> updateExpense(Payment oldPayment, Student student)async{
    bool result = false;
    try {
      ref.read(paymentsProvider.notifier).updatePayment(
        oldPayment,
        student,
        double.parse(amountController.text),
        int.parse(classesController.text),
        TemporalDate(DateTime.parse(dateController.text)),
        );
      result = true;
    } catch (e) {
      safePrint("Error al actualizar Gasto");
    }
    return result;
  }


  bool checkFileds(){
    if(amountController.text.isEmpty || dateController.text.isEmpty || classesController.text.isEmpty){
      return false;
    }else{
      try {
        double.parse(amountController.text);
        int.parse(classesController.text);
        TemporalDate(DateTime.parse(dateController.text));
        return true;
      } catch (e) {
        return false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final label = "Editar Pago";
    return Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: colorList[2],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 10,
            children: [
              Text(label),
              SizedBox(height: 20),
              TextField(controller: dateController,
                        decoration: InputDecoration(
                            labelStyle: const TextStyle(
                              color: Colors.white,),
                            labelText:"Fecha",
                            border: const OutlineInputBorder(),
                          ),),
              TextField(controller: amountController,
                        decoration: InputDecoration(
                            labelStyle: const TextStyle(
                              color: Colors.white,),
                            labelText:"Cantidad",
                            border: const OutlineInputBorder(),
                          ),),
              TextField(controller: classesController,
                        decoration: InputDecoration(
                            labelStyle: const TextStyle(
                              color: Colors.white,),
                            labelText:"Clases restantes",
                            border: const OutlineInputBorder(),
                          ),),
              SizedBox(height: 20),
              Row(children: [
                FilledButton(onPressed: (){Navigator.pop(context);}, child: Text("Cancelar")),
                Spacer(),
                FilledButton(onPressed: ()async{
                  if(checkFileds()){
                    final status =  await updateExpense(widget.payment, widget.student);
                    if(status){
                      Navigator.pop(context);
                    }
                  }
                }, child: Text("Guardar"))
              ],)
            ],
          ),
        ),
      );
  }
}