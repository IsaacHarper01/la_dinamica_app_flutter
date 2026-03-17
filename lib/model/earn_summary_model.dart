import 'package:la_dinamica_app/model/finacial_model.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';

class FinancialSummary {
  final FinacialModel<Sale> sales;
  final FinacialModel<Payment> payments;
  final FinacialModel<Expense> expenses;

  FinancialSummary({
    required this.sales,
    required this.payments,
    required this.expenses,
  });

  FinancialSummary copyWith({
    FinacialModel<Sale>? sales,
    FinacialModel<Payment>? payments,
    FinacialModel<Expense>? expenses,

  }){
    return FinancialSummary(
        sales: sales ?? this.sales,
        payments: payments ?? this.payments,
        expenses: expenses ?? this.expenses,
      );
  }
}