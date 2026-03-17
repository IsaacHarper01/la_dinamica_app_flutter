import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/model/earn_summary_model.dart';
import 'package:la_dinamica_app/providers/expenses_provider.dart';
import 'package:la_dinamica_app/providers/income_plan_provider.dart';
import 'package:la_dinamica_app/providers/sales_provider.dart';


final incomeSummaryProvider = Provider<AsyncValue<FinancialSummary>>((ref) {

  final salesAsync = ref.watch(salesProvider);
  final plansAsync = ref.watch(incomePlanProvider);
  final expensesAsync = ref.watch(expensesProvider);

  if (salesAsync.isLoading || plansAsync.isLoading || expensesAsync.isLoading) {
    return const AsyncValue.loading();
  }

  if (salesAsync.hasError) {
    return AsyncValue.error(salesAsync.error!, salesAsync.stackTrace!);
  }

  if (plansAsync.hasError) {
    return AsyncValue.error(plansAsync.error!, plansAsync.stackTrace!);
  }

  if (expensesAsync.hasError) {
    return AsyncValue.error(expensesAsync.error!, expensesAsync.stackTrace!);
  }

  final sales = salesAsync.value!;
  final plans = plansAsync.value!;
  final expenses = expensesAsync.value!;

  return AsyncData(
    FinancialSummary(
      sales: sales,
      expenses: expenses,
      payments: plans,
    ),
  );
});