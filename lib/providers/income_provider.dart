import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/model/UserLocal.dart';
import 'package:la_dinamica_app/model/income_state.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';
import 'package:la_dinamica_app/providers/create_queries_aws.dart';
import 'package:la_dinamica_app/providers/date_provider.dart';
import 'package:la_dinamica_app/providers/read_queries_aws.dart';
import 'package:la_dinamica_app/providers/user_provider.dart';

final incomeProvider =
    StateNotifierProvider<IncomeNotifier, AsyncValue<IncomeState>>((ref) {
      return IncomeNotifier(ref);
    });

class IncomeNotifier extends StateNotifier<AsyncValue<IncomeState>> {
  final Ref ref;

  IncomeNotifier(this.ref) : super(const AsyncValue.loading()){
    loadActualMonth();
  }
  
  Future<void> loadActualMonth() async {
    try {
      final awsDb = DataStoreReadService();
      final user = await ref.watch(userProvider.future);
      final date = DateTime.parse(ref.watch(dateProvider));
      final start = DateTime.now().subtract(Duration(days:DateTime.now().day-1));
      final end = DateTime.now();
      final incomeMap = await awsDb.getAllInconmeRange(user.tenant.tenant_id, start, end);
      final salesList = incomeMap["sales"];
      final planList = incomeMap["payments"];
      final expensesList = incomeMap["expenses"];
      final planData = calculatePlanIncomeRange(planList, date);
      final salesData = calculateSalesIncomeRange(salesList, date);
      final expenseData = calculateExpensesRange(expensesList, date);
      final income = IncomeState(
        listPlanIncome:planList, 
        listProductIncome: salesList,
        listExpense: expensesList,
        dayPlanIncome: planData["day"]!,
        dayProductIncome: salesData["day"]!,
        dayExpense: expenseData["day"],
        planIncome: planData["range"],
        productIncome: salesData["range"],
        expenseTotal: expenseData["range"],
        );
      state = AsyncValue.data(income);

    } catch (e) {
      if (!mounted) return;
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> reLoadIncomeData(DateTime start, DateTime end)async{
    try {
      final awsDb = DataStoreReadService();
      final user = await ref.watch(userProvider.future);
      final date = DateTime.parse(ref.watch(dateProvider));
      final incomeMap = await awsDb.getAllInconmeRange(user.tenant.tenant_id, start, end);
      final salesList = incomeMap["sales"];
      final planList = incomeMap["payments"];
      final expensesList = incomeMap["expenses"];
      final planData = calculatePlanIncomeRange(planList, date);
      final salesData = calculateSalesIncomeRange(salesList, date);
      final expenseData = calculateExpensesRange(expensesList, date);
      final income = IncomeState(
        listPlanIncome:planList, 
        listProductIncome: salesList,
        listExpense: expensesList,
        dayPlanIncome: planData["day"]!,
        dayProductIncome: salesData["day"]!,
        dayExpense: expenseData["day"],
        planIncome: planData["range"],
        productIncome: salesData["range"],
        expenseTotal: expenseData["range"],
        );
      state = AsyncValue.data(income);
    } catch (e) {
      if (!mounted) return;
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
  
  Map<String, double> calculatePlanIncomeRange(List<Payment> listPayments, DateTime date){
    double totalRange = 0.0;
    double totalDay = 0.0;
    for(var payment in listPayments){
      totalRange += payment.amount!;
      if (payment.date == TemporalDate(date)) {
        totalDay += payment.amount!;
      }
    }
    return {"range": totalRange,"day":totalDay}; 
  }

  Map<String, double> calculateSalesIncomeRange(List<Sale> listSales, DateTime date){
    double totalRange = 0.0;
    double totalDay = 0.0;
    for(var sale in listSales){
      totalRange += sale.price!;
      if (sale.date == TemporalDate(date)) {
        totalDay += sale.price!;
      }
    }
    return {"range": totalRange,"day":totalDay}; 
  }

   Map<String, double> calculateExpensesRange(List<Expense> listExpenses, DateTime date){
    double totalRange = 0.0;
    double totalDay = 0.0;
    for(var expense in listExpenses){
      totalRange += expense.amount;
      if (expense.date == TemporalDate(date)) {
        totalDay += expense.amount;
      }
    }
    return {"range": totalRange,"day":totalDay}; 
  }

  Future<void> addPay(Student student, LocalPlan plan, String date, UserLocal user)async{
    final aws = DataStoreService();
    aws.savePayment(
      userId: student.user_id!,
      amount: plan.price!,
      clases: plan.clases!,
      plan: plan,
      date: date,
      dbId: user.tenant.tenant_id,
      profId: user.name,
    );
    loadActualMonth();
  }

  }