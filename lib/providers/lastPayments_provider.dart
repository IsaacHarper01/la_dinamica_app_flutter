import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/model/UserLocal.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';
import 'package:la_dinamica_app/providers/create_queries_aws.dart';
import 'package:la_dinamica_app/providers/delete_queries_aws.dart';
import 'package:la_dinamica_app/providers/read_queries_aws.dart';
import 'package:la_dinamica_app/providers/user_provider.dart';

final paymentsProvider =
    StateNotifierProvider<PaymentsNotifier, AsyncValue<List<Payment>>>(
      (ref) => PaymentsNotifier(ref),
    );

class PaymentsNotifier extends StateNotifier<AsyncValue<List<Payment>>>{
  final Ref ref;

  PaymentsNotifier(this.ref,) : super(const AsyncValue.loading());

  Future<void> fetchLastPayments(Student student)async{
    final user = await ref.watch(userProvider.future);
    final aws = DataStoreReadService(); 
    final payments = await aws.getLastTenPayments(student.user_id!, user.tenant!.tenant_id);
    state = AsyncValue.data(payments!);
  }

  Future<void> markDebt(UserLocal user, Student student, Payment payment, bool status)async{
    final aws = GraphqlServiceCreate();
    await aws.markDebtStatus(pay: payment,status: status);
    await fetchLastPayments(student);
  }

  Future<void> deltePay(Payment pay, UserLocal user, Student student)async{
    final aws = DataStoreDeleteService();
    await aws.deletePayment(pay);
    await fetchLastPayments(student);
  }

  Future<bool> updatePayment(Payment oldPayment, Student student , double? newAmount, int newClasses, TemporalDate? newDate)async{
    bool status = false;
    try {
      final newPayment = oldPayment.copyWith(
      amount: newAmount,
      clases: newClasses,
      date: newDate,
      );
      await Amplify.DataStore.save(newPayment);
      await fetchLastPayments(student);
      status = true;
      return status;
    } catch (e) {
      return status;
    }
  }

}