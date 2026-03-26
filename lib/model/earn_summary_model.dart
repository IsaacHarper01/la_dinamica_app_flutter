import 'package:la_dinamica_app/model/finacial_model.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';

class FinancialSummary {
  final FinancialModel<Sale> sales;
  final FinancialModel<Payment> payments;
  final FinancialModel<Expense> expenses;
  final Map<String, dynamic>? mapDate;

  FinancialSummary({
    required this.sales,
    required this.payments,
    required this.expenses,
    this.mapDate
  });

  factory FinancialSummary.empty() {
    return FinancialSummary(
      sales: FinancialModel<Sale>(dayList: [], rangelist: [], totalDay: 0.0, totalRange: 0.0),
      payments: FinancialModel<Payment>(dayList: [], rangelist: [], totalDay: 0.0, totalRange: 0.0),
      expenses: FinancialModel<Expense>(dayList: [], rangelist: [], totalDay: 0.0, totalRange: 0.0),
      mapDate: null
    );
  }

  FinancialSummary copyWith({
    FinancialModel<Sale>? sales,
    FinancialModel<Payment>? payments,
    FinancialModel<Expense>? expenses,
    Map<String, dynamic>? mapDate,
  }){
    return FinancialSummary(
        sales: sales ?? this.sales,
        payments: payments ?? this.payments,
        expenses: expenses ?? this.expenses,
        mapDate: mapDate ?? this.mapDate,
      );
  }

  FinancialSummary setMap(String option){
    Map<String, double> map = {};
    switch (option) {

      case "Ingreso Neto":
        for (var payment in payments.rangelist) {
          String dateKey = payment.date!.format();
          double amount = payment.amount ?? 0.0;
          if (map.containsKey(dateKey)) {
            map[dateKey] = map[dateKey]! + amount;
          } else {
            map[dateKey] = amount;
          }
        }
        for (var sale in sales.rangelist) {
          String dateKey = sale.date!.format();
          double amount = sale.price ?? 0.0;

          if (map.containsKey(dateKey)) {
            map[dateKey] = map[dateKey]! + amount;
          } else {
            map[dateKey] = amount;
          }
        }
        for (var expense in expenses.rangelist) {
          String dateKey = expense.date.format();
          double amount = expense.amount;

          if (map.containsKey(dateKey)) {
            map[dateKey] = map[dateKey]! - amount;
          } else {
            map[dateKey] = amount;
          }
        }
        break;

      case "Ingreso de planes":
        for (var payment in payments.rangelist) {
          String dateKey = payment.date!.format();
          double amount = payment.amount ?? 0.0;

          if (map.containsKey(dateKey)) {
            map[dateKey] = map[dateKey]! + amount;
          } else {
            map[dateKey] = amount;
          }
        }
        break;

      case "Ingreso de productos":
        for (var sale in sales.rangelist) {
          String dateKey = sale.date!.format();
          double amount = sale.price ?? 0.0;

          if (map.containsKey(dateKey)) {
            map[dateKey] = map[dateKey]! + amount;
          } else {
            map[dateKey] = amount;
          }
        }
        break;
        
      case "Gastos":
        for (var expense in expenses.rangelist) {
          String dateKey = expense.date.format();
          double amount = expense.amount;

          if (map.containsKey(dateKey)) {
            map[dateKey] = map[dateKey]! + amount;
          } else {
            map[dateKey] = amount;
          }
        }
        break;
      default:
    }
    return copyWith(mapDate: map);
  }
}