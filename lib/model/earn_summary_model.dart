import 'package:la_dinamica_app/model/finacial_model.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';

class FinancialSummary {
  final FinancialModel<Sale> sales;
  final FinancialModel<Payment> payments;
  final FinancialModel<Expense> expenses;

  FinancialSummary({
    required this.sales,
    required this.payments,
    required this.expenses,
  });

  factory FinancialSummary.empty() {
    return FinancialSummary(
      sales: FinancialModel<Sale>(dayList: [], rangelist: [], totalDay: 0.0, totalRange: 0.0),
      payments: FinancialModel<Payment>(dayList: [], rangelist: [], totalDay: 0.0, totalRange: 0.0),
      expenses: FinancialModel<Expense>(dayList: [], rangelist: [], totalDay: 0.0, totalRange: 0.0),
    );
  }

  FinancialSummary copyWith({
    FinancialModel<Sale>? sales,
    FinancialModel<Payment>? payments,
    FinancialModel<Expense>? expenses,

  }){
    return FinancialSummary(
        sales: sales ?? this.sales,
        payments: payments ?? this.payments,
        expenses: expenses ?? this.expenses,
      );
  }
}