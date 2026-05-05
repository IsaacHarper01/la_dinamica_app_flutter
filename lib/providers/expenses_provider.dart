import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/model/finacial_model.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';
import 'package:la_dinamica_app/providers/create_queries_aws.dart';
import 'package:la_dinamica_app/providers/date_provider_new.dart';
import 'package:la_dinamica_app/providers/delete_queries_aws.dart';
import 'package:la_dinamica_app/providers/read_queries_aws.dart';
import 'package:la_dinamica_app/providers/user_provider.dart';

final expensesProvider = StateNotifierProvider<SalesNotifier,AsyncValue<FinancialModel<Expense>>>( 
    (ref) => SalesNotifier(ref),
);

class SalesNotifier extends StateNotifier<AsyncValue<FinancialModel<Expense>>>{
  final Ref ref;

  SalesNotifier(this.ref) : super(const AsyncValue.loading()){
    setAllExpenses();
  }

  DataStoreReadService aws =  DataStoreReadService();
  DataStoreService awsSave = DataStoreService();

  Future<void> setAllExpenses()async{
    try {
      await setTodayExpenses();
      await setRangeExpenses();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> setTodayExpenses()async{
    final today = ref.read(dateProvider).today;
    try {
      final user = await ref.watch(userProvider.future);
      final expenses = await aws.getTodayExpenses(user.tenant!.tenant_id, today);
      final current = state.value ?? FinancialModel<Expense>();
      state = AsyncData(current.copyWith(
        dayList: expenses, 
        totalDay: expenses.fold(0,(sum,expense)=>sum! + expense.amount) ?? 0.0
        ));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> setRangeExpenses()async{
    final start = ref.read(dateProvider).start;
    final end = ref.read(dateProvider).end;
    try {
      final user = await ref.watch(userProvider.future);
      final expenses = await aws.getExpensesRange(user.tenant!, start, end);
      safePrint(expenses);
      final current = state.value ?? FinancialModel<Expense>();
      state = AsyncData(current.copyWith(
        rangelist: expenses,
        totalRange: expenses.fold(0,(sum,expense)=>sum! +expense.amount) ?? 0.0
      ));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> newExpense(Tenant tenant, double amount, String name, DateTime date, String description)async{
      try {
        await awsSave.saveExpense(tenant: tenant, amount: amount,name: name, date: date, description: description);
      } catch (e,st) {
        state = AsyncValue.error(e, st);
      }finally{
        await setAllExpenses();
      }
  }

  Future<void> updateExpense(Expense oldExpense, String? newName, double? newAmount, String? newDescription)async{
    final newExpense = oldExpense.copyWith(
      name: newName,
      amount: newAmount,
      description: newDescription,
    );
    await Amplify.DataStore.save(newExpense);
    await setAllExpenses();
  }

  Future<void> deleteExpense(Expense expenseToDelete)async{
    try {
      final awsDelete = DataStoreDeleteService();
      await awsDelete.deleteExpense(expenseToDelete);
      await setAllExpenses();
    } catch (e, st) {
      if(!mounted) return;
        state = AsyncValue.error(e, st);
    }
  }
}