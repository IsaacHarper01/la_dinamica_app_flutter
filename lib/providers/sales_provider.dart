import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/model/finacial_model.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';
import 'package:la_dinamica_app/providers/create_queries_aws.dart';
import 'package:la_dinamica_app/providers/date_provider_new.dart';
import 'package:la_dinamica_app/providers/read_queries_aws.dart';
import 'package:la_dinamica_app/providers/user_provider.dart';

final salesProvider = StateNotifierProvider<SalesNotifier,AsyncValue<FinancialModel<Sale>>>( 
    (ref) => SalesNotifier(ref),
);

class SalesNotifier extends StateNotifier<AsyncValue<FinancialModel<Sale>>>{
  final Ref ref;

  SalesNotifier(this.ref) : super(const AsyncValue.loading()){
    setAllSales();
  }

  DataStoreReadService aws =  DataStoreReadService();
  DataStoreService awsSave = DataStoreService();

  Future<void> setAllSales()async{
    try {
      await setTodaySales();
      await setRangeSales();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> setTodaySales()async{
    final today = ref.read(dateProvider).today;
    try {
      final user = await ref.watch(userProvider.future);
      final sales = await aws.fetchSales(user.tenant.tenant_id, today);
      state = AsyncData(FinancialModel<Sale>(
        dayList: sales, 
        totalDay: sales.fold(0,(sum,sale)=>sum! +sale.price!) ?? 0.0
        ));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> setRangeSales()async{
    final start = ref.read(dateProvider).start;
    final end = ref.read(dateProvider).end;
    try {
      final user = await ref.watch(userProvider.future);
      final sales = await aws.getSalesPerRange(start,end,user.tenant.tenant_id);
      final current = state.value ?? FinancialModel<Sale>();
      state = AsyncData(current.copyWith(
        rangelist: sales,
        totalRange: sales.fold(0,(sum,sale)=>sum! +sale.price!) ?? 0.0
      ));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> newSale(String tenantId, double price, String date, String profName, Product product)async{
      try {
        awsSave.saveSale(tenaniId: tenantId, price: price, product: product, date: date, profName: profName);
        setAllSales();
      } catch (e,st) {
        state = AsyncValue.error(e, st);
      }
  }
}