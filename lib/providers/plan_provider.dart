import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/backend/database.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';
import 'package:la_dinamica_app/providers/create_queries_aws.dart';
import 'package:la_dinamica_app/providers/delete_queries_aws.dart';
import 'package:la_dinamica_app/providers/read_queries_aws.dart';
import 'package:la_dinamica_app/providers/user_provider.dart';

final planProvider =
    StateNotifierProvider<PlanNotifier, AsyncValue<List<LocalPlan>>>(
      (ref) => PlanNotifier(ref),
    );

class PlanNotifier extends StateNotifier<AsyncValue<List<LocalPlan>>> {
  final Ref ref;

  PlanNotifier(this.ref) : super(const AsyncValue.loading()) {
    loadPlans();
  }

  final db = DatabaseHelper();
  DataStoreReadService dataStoreReadService = DataStoreReadService();
  DataStoreService dataStoreService = DataStoreService();
  DataStoreDeleteService dataStoreDeleteService = DataStoreDeleteService();

  Future<void> loadPlans() async {
    final user = await ref.watch(userProvider.future);
    final gymId = user.db_id;
    try {
      final awsPlans = await dataStoreReadService.getPlans(gymId!);
      safePrint("obtained plans from aws: $awsPlans for gym: $gymId");
      state = AsyncValue.data(awsPlans);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addPlan(LocalPlan plan) async {
    try {
      await dataStoreService.savePlan(
        type: plan.type!,
        clases: plan.clases!,
        price: plan.price!,
        gymId: plan.client_id!,
      );

      loadPlans();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deletePlan(String id) async {
    try {
      await dataStoreDeleteService.deletePlanById(id);
      loadPlans();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
