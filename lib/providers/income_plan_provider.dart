import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/model/finacial_model.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';
import 'package:la_dinamica_app/providers/create_queries_aws.dart';
import 'package:la_dinamica_app/providers/date_provider_new.dart';
import 'package:la_dinamica_app/providers/read_queries_aws.dart';
import 'package:la_dinamica_app/providers/user_provider.dart';

final incomePlanProvider = StateNotifierProvider<SalesNotifier,AsyncValue<FinacialModel<Payment>>>( 
    (ref) => SalesNotifier(ref),
);

class SalesNotifier extends StateNotifier<AsyncValue<FinacialModel<Payment>>>{
  final Ref ref;

  SalesNotifier(this.ref) : super(const AsyncValue.loading()){
    setAllPayments();
  }

  DataStoreReadService aws =  DataStoreReadService();
  DataStoreService awsSave = DataStoreService();

  Future<void> setAllPayments()async{
    try {
      await setTodayPayments();
      await setRangePayments();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> setTodayPayments()async{
    final today = ref.read(dateProviderNew).today;
    try {
      final user = await ref.watch(userProvider.future);
      final payments = await aws.getTodayPayments(user.tenant.tenant_id, today);
      state = AsyncData(FinacialModel<Payment>(
        dayList: payments, 
        totalDay: payments.fold(0,(sum,payment)=>sum! +payment.amount!) ?? 0.0
        ));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> setRangePayments()async{
    final start = ref.read(dateProviderNew).start;
    final end = ref.read(dateProviderNew).end;
    try {
      final user = await ref.watch(userProvider.future);
      final payments = await aws.getPaymentsRange(start, end, user.tenant.tenant_id);
      state = AsyncData(FinacialModel<Payment>(
        rangelist: payments,
        totalRange: payments.fold(0,(sum,payment)=>sum! +payment.amount!) ?? 0.0
      ));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

}