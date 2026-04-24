import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/config/theme/app_theme.dart';
import 'package:la_dinamica_app/model/UserLocal.dart';
import 'package:la_dinamica_app/models/Expense.dart';
import 'package:la_dinamica_app/providers/create_queries_aws.dart';
import 'package:la_dinamica_app/providers/date_provider_new.dart';
import 'package:la_dinamica_app/providers/expenses_provider.dart';
import 'package:la_dinamica_app/providers/user_provider.dart';
import 'package:la_dinamica_app/screens/history_expenses_screen.dart';

class AddExpensesWidget extends ConsumerStatefulWidget {
  final bool onEdit;
  final Expense? expense;

  const AddExpensesWidget({super.key, this.onEdit=false, this.expense});

  @override
  ConsumerState<AddExpensesWidget> createState() => _AddExpensesWidgetState();
}

class _AddExpensesWidgetState extends ConsumerState<AddExpensesWidget> {
  final amountController = TextEditingController();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();


  @override
  void initState() {
    super.initState();
    if(widget.onEdit){
      amountController.text = widget.expense!.amount.toString();
      nameController.text = widget.expense!.name;
      descriptionController.text = widget.expense!.description ?? "";
    }
  }

  Future<bool> updateExpense(Expense oldExpense)async{
    bool result = false;
    try {
      ref.read(expensesProvider.notifier).updateExpense(
        oldExpense, 
        nameController.text, 
        double.parse(amountController.text), 
        descriptionController.text,
        );
      result = true;
    } catch (e) {
      safePrint("Error al actualizar Gasto");
    }
    return result;
  }

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
    final date = ref.watch(dateProvider).today;
    final label = widget.onEdit ? "Editar Gasto": "Añadir Gasto";
    final finishState = widget.onEdit ? "Actualizar" : "Registrar";
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeigth = MediaQuery.of(context).size.height;
    return Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: colorList[2],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            spacing: 10,
            children: [
              Text(label),
              SizedBox(height: 20),
              TextField(controller: nameController,
                        decoration: InputDecoration(
                            labelStyle: const TextStyle(
                              color: Colors.white,),
                            labelText:"Categoría",
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
              LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth;

                    double fontSize;
                    if (width > 500) {
                      fontSize = 14;
                    } else if (width > 350) {
                      fontSize = 12;
                    } else {
                      fontSize = 10;
                    }

                    return Row(
                      children: [
                        Expanded(
                          child: FilledButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Cancelar",
                              style: TextStyle(fontSize: fontSize),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        Expanded(
                          child: FilledButton(
                            onPressed: () async {
                              final status = widget.onEdit
                                  ? await updateExpense(widget.expense!)
                                  : await submitExpense(user, date);

                              if (status) {
                                Navigator.pop(context);
                              }
                            },
                            child: Text(
                              finishState,
                              style: TextStyle(fontSize: fontSize),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                )
            ],
          ),
        ),
      );
  }
}