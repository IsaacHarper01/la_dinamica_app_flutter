import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/model/earn_summary_model.dart';
import 'package:la_dinamica_app/providers/expenses_provider.dart';
import 'package:la_dinamica_app/providers/income_plan_provider.dart';
import 'package:la_dinamica_app/providers/sales_provider.dart';

final incomeSummaryProvider = StateNotifierProvider<SalesNotifier,AsyncValue<FinancialSummary>>( 
    (ref) => SalesNotifier(ref),
);

class SalesNotifier extends StateNotifier<AsyncValue<FinancialSummary>>{
  final Ref ref;

  SalesNotifier(this.ref) : super(const AsyncValue.loading()){
    setAllProviders();
    }
  
  Future<void> setAllProviders()async{
    try {
      await Future.wait([
      ref.read(salesProvider.notifier).setAllSales(),
      ref.read(incomePlanProvider.notifier).setAllPayments(),
      ref.read(expensesProvider.notifier).setAllExpenses(),
      ]);

      final salesAsync = ref.read(salesProvider);
      final paymentsAsync = ref.read(incomePlanProvider);
      final expensesAsync = ref.read(expensesProvider);

      final summary = FinancialSummary(
        sales: salesAsync.value!, 
        payments: paymentsAsync.value!, 
        expenses: expensesAsync.value!);

      state = AsyncData(summary.setMap("Ingreso Neto"));
      state.value?.setMap("Ingreso Neto");
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
  
  void setMap(String option){
    final current = state.value;
    if (current == null) return;
    state = AsyncData(current.setMap(option));
  }

  void clear() {
  state = AsyncValue.data(
    FinancialSummary.empty(), // you define this
    );
  }
}