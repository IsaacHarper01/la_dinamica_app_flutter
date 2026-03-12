import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/config/theme/app_theme.dart';
import 'package:la_dinamica_app/model/UserLocal.dart';
import 'package:la_dinamica_app/providers/create_queries_aws.dart';
import 'package:la_dinamica_app/providers/date_provider.dart';
import 'package:la_dinamica_app/providers/user_provider.dart';

class AddExpensesWidget extends ConsumerStatefulWidget {
  const AddExpensesWidget({super.key});

  @override
  ConsumerState<AddExpensesWidget> createState() => _AddExpensesWidgetState();
}

class _AddExpensesWidgetState extends ConsumerState<AddExpensesWidget> {
  final amountController = TextEditingController();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  Future<bool> submitExpense(UserLocal user, String date)async{
    final aws = DataStoreService();
    if (checkFileds()){
      await aws.saveExpense(
      tenant: user.tenant, 
      date: DateTime.parse(date), 
      name: nameController.text, 
      amount: double.parse(amountController.text), 
      description: descriptionController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gasto registrado exitosamente'),
          backgroundColor: Colors.green,
        ),
      );
      return true;
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, complete todos los campos.'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
  }

  bool checkFileds(){
    if(amountController.text.isEmpty || nameController.text.isEmpty){
      return false;
    }else{
      try {
        double.parse(amountController.text);
        return true;
      } catch (e) {
        return false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider).value!;
    final date = ref.watch(dateProvider);
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
            children: [
              Text("Añadir Gasto"),
              SizedBox(height: 20),
              TextField(controller: nameController,
                        decoration: InputDecoration(
                            labelStyle: const TextStyle(
                              color: Colors.white,),
                            labelText:"Nombre del gasto",
                            border: const OutlineInputBorder(),
                          ),),
              TextField(controller: amountController,
                        decoration: InputDecoration(
                            labelStyle: const TextStyle(
                              color: Colors.white,),
                            labelText:"Cantidad",
                            border: const OutlineInputBorder(),
                          ),),
              TextField(controller: descriptionController,
                        decoration: InputDecoration(
                            labelStyle: const TextStyle(
                              color: Colors.white,),
                            labelText:"Descripción (opcional)",
                            border: const OutlineInputBorder(),
                          ),),
              SizedBox(height: 20),
              Row(children: [
                FilledButton(onPressed: (){Navigator.pop(context);}, child: Text("Cancelar")),
                Spacer(),
                FilledButton(onPressed: ()async{
                  final status = await submitExpense(user, date);
                  if(status){
                    Navigator.pop(context);
                  }
                }, child: Text("Registrar"))
              ],)
            ],
          ),
        ),
      );
  }
}