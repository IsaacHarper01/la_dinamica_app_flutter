import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/model/finacial_model.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';
import 'package:la_dinamica_app/providers/create_queries_aws.dart';
import 'package:la_dinamica_app/providers/date_provider_new.dart';
import 'package:la_dinamica_app/providers/read_queries_aws.dart';
import 'package:la_dinamica_app/providers/user_provider.dart';

final expensesProvider = StateNotifierProvider<SalesNotifier,AsyncValue<FinacialModel<Expense>>>( 
    (ref) => SalesNotifier(ref),
);

class SalesNotifier extends StateNotifier<AsyncValue<FinacialModel<Expense>>>{
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
    final today = ref.read(dateProviderNew).today;
    try {
      final user = await ref.watch(userProvider.future);
      final expenses = await aws.getTodayExpenses(user.tenant.tenant_id, today);
      state = AsyncData(FinacialModel<Expense>(
        dayList: expenses, 
        totalDay: expenses.fold(0,(sum,expense)=>sum! + expense.amount) ?? 0.0
        ));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> setRangeExpenses()async{
    final start = ref.read(dateProviderNew).start;
    final end = ref.read(dateProviderNew).end;
    try {
      final user = await ref.watch(userProvider.future);
      final expenses = await aws.getExpensesRange(user.tenant, start, end);
      state = AsyncData(FinacialModel<Expense>(
        rangelist: expenses,
        totalRange: expenses.fold(0,(sum,expense)=>sum! +expense.amount) ?? 0.0
      ));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> newExpense(Tenant tenant, double amount, String name, DateTime date, String description)async{
      try {
        awsSave.saveExpense(tenant: tenant, amount: amount,name: name, date: date, description: description);
        await setAllExpenses();
      } catch (e,st) {
        state = AsyncValue.error(e, st);
      }
  }
}