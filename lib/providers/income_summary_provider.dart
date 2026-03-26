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
      await ref.read(salesProvider.notifier).setAllSales();
      await ref.read(incomePlanProvider.notifier).setAllPayments();
      await ref.read(expensesProvider.notifier).setAllExpenses();
      state = AsyncData(FinancialSummary(
        sales: ref.read(salesProvider).value!, 
        expenses: ref.read(expensesProvider).value!, 
        payments: ref.read(incomePlanProvider).value!
      ));
      state.value?.setMap("Ingreso Neto");
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
  
  void setMap(String option){
    state = AsyncData(state.value!..setMap(option));
  }

  void clear() {
  state = AsyncValue.data(
    FinancialSummary.empty(), // you define this
    );
  }
}