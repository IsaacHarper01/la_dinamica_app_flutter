import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/model/UserLocal.dart';
import 'package:la_dinamica_app/model/finacial_model.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';
import 'package:la_dinamica_app/providers/create_queries_aws.dart';
import 'package:la_dinamica_app/providers/date_provider_new.dart';
import 'package:la_dinamica_app/providers/read_queries_aws.dart';
import 'package:la_dinamica_app/providers/user_provider.dart';

final incomePlanProvider = StateNotifierProvider<SalesNotifier,AsyncValue<FinancialModel<Payment>>>( 
    (ref) => SalesNotifier(ref),
);

class SalesNotifier extends StateNotifier<AsyncValue<FinancialModel<Payment>>>{
  final Ref ref;

  SalesNotifier(this.ref) : super(const AsyncValue.loading()){
    setAllPayments();
  }

  DataStoreReadService aws =  DataStoreReadService();
  GraphqlServiceCreate awsSave = GraphqlServiceCreate();

  Future<void> setAllPayments()async{
    try {
      await setTodayPayments();
      await setRangePayments();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> setTodayPayments()async{
    final today = ref.read(dateProvider).today;
    try {
      final user = await ref.watch(userProvider.future);
      final payments = await aws.getTodayPayments(user.tenant!.tenant_id, today);
      final current = state.value ?? FinancialModel<Payment>();
      state = AsyncData(current.copyWith(
        dayList: payments, 
        totalDay: payments.fold(0,(sum,payment)=>sum! +payment.amount!) ?? 0.0
        ));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> setRangePayments()async{
    final start = ref.read(dateProvider).start;
    final end = ref.read(dateProvider).end;
    try {
      final user = await ref.watch(userProvider.future);
      final payments = await aws.getPaymentsRange(start, end, user.tenant!.tenant_id);
      final current = state.value ?? FinancialModel<Payment>();
      state = AsyncData(current.copyWith(
        rangelist: payments,
        totalRange: payments.fold(0,(sum,payment)=>sum! +payment.amount!) ?? 0.0
      ));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addPay(Student student, LocalPlan plan, String date, UserLocal user)async{
    final aws = GraphqlServiceCreate();
    final date = ref.read(dateProvider).today;
    DateTime? expirationDate;
    Student newStudent;

    if(plan.expiration!=null){
      expirationDate = DateTime.parse(date).add(Duration(days: plan.expiration!));
      newStudent = student.copyWith(
        expirationPlan: TemporalDate(expirationDate), 
        remainClasses: plan.clases);
    }else{
      newStudent = student.copyWith(remainClasses: plan.clases);
    }
    Amplify.DataStore.save(newStudent);
    aws.savePayment(
      userId: student.user_id!,
      amount: plan.price!,
      clases: plan.clases!,
      plan: plan,
      date: date,
      dbId: user.tenant!.tenant_id,
      profId: user.name,
    );
    setAllPayments();
  }
}