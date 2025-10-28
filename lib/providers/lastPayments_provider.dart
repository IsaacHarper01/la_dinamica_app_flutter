import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/model/UserLocal.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';
import 'package:la_dinamica_app/providers/create_queries_aws.dart';
import 'package:la_dinamica_app/providers/delete_queries_aws.dart';
import 'package:la_dinamica_app/providers/read_queries_aws.dart';

final paymentsProvider =
    StateNotifierProvider<PaymentsNotifier, AsyncValue<List<Payment>>>((ref) {
      return PaymentsNotifier(ref);
    });

class PaymentsNotifier extends StateNotifier<AsyncValue<List<Payment>>>{
  final Ref ref;

  PaymentsNotifier(this.ref,) : super(const AsyncValue.loading());

  Future<void> fetchLastPayments(UserLocal user, Student student)async{
    final aws = DataStoreReadService(); 
    final payments = await aws.getLastTenPayments(student.user_id!, user.tenant.tenant_id);
    state = AsyncValue.data(payments!);
  }

  Future<void> markDebt(UserLocal user, Student student, Payment payment, bool status)async{
    final aws = DataStoreService();
    aws.markDebtStatus(pay: payment,status: status);
    fetchLastPayments(user, student);
  }

  Future<void> deletePay(String id, UserLocal user, Student student)async{
    final aws = DataStoreDeleteService();
    aws.deletePaymentByID(id, user.tenant.tenant_id);
    fetchLastPayments(user, student);
  }

}