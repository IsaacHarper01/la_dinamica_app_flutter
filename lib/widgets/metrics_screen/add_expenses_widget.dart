import 'package:flutter/material.dart';
import 'package:la_dinamica_app/config/theme/app_theme.dart';

class AddExpensesWidget extends StatefulWidget {
  const AddExpensesWidget({super.key});

  @override
  State<AddExpensesWidget> createState() => _AddExpensesWidgetState();
}

class _AddExpensesWidgetState extends State<AddExpensesWidget> {
  final amountController = TextEditingController();
  final nameController = TextEditingController();
  final categoryController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: colorList[5],
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
              TextField(controller: categoryController,
                        decoration: InputDecoration(
                            labelStyle: const TextStyle(
                              color: Colors.white,),
                            labelText:"Categoría",
                            border: const OutlineInputBorder(),
                          ),),
              SizedBox(height: 20),
              Row(children: [
                FilledButton(onPressed: (){Navigator.pop(context);}, child: Text("Cancelar")),
                Spacer(),
                FilledButton(onPressed: (){}, child: Text("Registrar"))
              ],)
            ],
          ),
        ),
      );
  }
}