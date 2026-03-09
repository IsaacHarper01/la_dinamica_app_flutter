import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/model/income_state.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';
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
      final tenenatId = user.tenant.tenant_id;
      final start = DateTime.now().subtract(Duration(days:DateTime.now().day-1));
      final end = DateTime.now();
      final incomeMap = await awsDb.getAllInconmeRange(tenenatId, start, end);
      final salesList = incomeMap["sales"];
      final planList = incomeMap["payments"];
      final totalPlan = calculatePlanIncome(planList);
      final totalSales = calculateSalesIncome(salesList);
      final income = IncomeState(
        listPlanIncome:planList, 
        listProductIncome: salesList,
        planIncome: totalPlan,
        productIncome: totalSales,
        );
      state = AsyncValue.data(income);

    } catch (e) {
      if (!mounted) return;
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
  
  double calculatePlanIncome(List<Payment> listPayments){
    double total = 0.0;
    for(var payment in listPayments){
      total += payment.amount!;
    }
    return total; 
  }

  double calculateSalesIncome(List<Sale> listSales){
    double total = 0.0;
    for(var sale in listSales){
      total += sale.price!;
    }
    return total; 
  }

  }