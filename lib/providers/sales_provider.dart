import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';
import 'package:la_dinamica_app/providers/create_queries_aws.dart';
import 'package:la_dinamica_app/providers/date_provider.dart';
import 'package:la_dinamica_app/providers/read_queries_aws.dart';
import 'package:la_dinamica_app/providers/user_provider.dart';

final salesProvider = StateNotifierProvider<SalesNotifier,AsyncValue<List<Sale>>>(
    (ref) => SalesNotifier(ref),
);

class SalesNotifier extends StateNotifier<AsyncValue<List<Sale>>>{
  final Ref ref;

  SalesNotifier(this.ref) : super(const AsyncValue.loading());

  DataStoreReadService aws =  DataStoreReadService();
  DataStoreService awsSave = DataStoreService();

  Future<void> fetchTodaySales()async{
    try {
      final user = await ref.watch(userProvider.future);
      final date = ref.watch(dateProvider);
      final sales = await aws.fetchSales(user.tenant.tenant_id, date);
      state = AsyncValue.data(sales);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> newSale(String tenantId, double price, String date, String profName, Product product)async{
      try {
        awsSave.saveSale(tenaniId: tenantId, price: price, product: product, date: date, profName: profName);
      } catch (e,st) {
        state = AsyncValue.error(e, st);
      }
  }
}