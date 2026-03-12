import 'package:la_dinamica_app/models/Expense.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';

class IncomeState {
  final List<Payment> listPlanIncome;
  final List<Sale> listProductIncome;
  final List<Expense> listExpense;
  final double? dayPlanIncome;
  final double? dayProductIncome;
  final double? dayExpense;
  final double? planIncome;
  final double? productIncome;
  final double? expenseTotal;

  IncomeState({
    required this.listPlanIncome,
    required this.listProductIncome,
    required this.listExpense,
    this.dayPlanIncome,
    this.dayProductIncome,
    this.dayExpense,
    this.planIncome,
    this.productIncome,
    this.expenseTotal,
  });

  IncomeState copyWith({
    List<Payment>? listPlanIncome,
    List<Sale>? listProductIncome,
    List<Expense>? listExpense,
    double? dayPlanIncome,
    double? dayProductIncome,
    double? dayExpense,
    double? planIncome,
    double? productIncome,
    double? expenseTotal,
  }){
    return IncomeState(
      listPlanIncome: listPlanIncome ?? this.listPlanIncome, 
      listProductIncome: listProductIncome ?? this.listProductIncome, 
      listExpense: listExpense ?? this.listExpense,
      dayPlanIncome: dayPlanIncome ?? this.dayPlanIncome,
      dayProductIncome: dayProductIncome ?? this.dayProductIncome,
      dayExpense: dayExpense ?? this.dayExpense,
      planIncome: planIncome ?? this.planIncome, 
      productIncome: productIncome?? this.productIncome,
      expenseTotal: expenseTotal ?? this.expenseTotal,
      );
  }
}

