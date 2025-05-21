import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/backend/database.dart';
import 'package:la_dinamica_app/model/plan.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';
import 'package:la_dinamica_app/providers/create_queries_aws.dart';
import 'package:la_dinamica_app/providers/read_queries_aws.dart';
import 'package:la_dinamica_app/providers/delete_queries_aws.dart';

final planProvider =
    StateNotifierProvider<PlanNotifier, AsyncValue<List<Plans>>>(
  (ref) => PlanNotifier(),
);

class PlanNotifier extends StateNotifier<AsyncValue<List<Plans>>> {
  PlanNotifier() : super(const AsyncValue.loading()) {
    loadPlans();
  }

  final db = DatabaseHelper();
  DataStoreReadService dataStoreReadService = DataStoreReadService();
  DataStoreService dataStoreService = DataStoreService();
  DataStoreDeleteService dataStoreDeleteService = DataStoreDeleteService();
  
  Future<void> loadPlans() async {
    try {
      final aws_plans = await dataStoreReadService.getPlans();
      safePrint("obtained plans from aws: $aws_plans");
      state = AsyncValue.data(aws_plans);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addPlan(Plan plan) async {
    try {
      await dataStoreService.savePlan(
        type: plan.type,
        clases: plan.clases, 
        price: plan.price);

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
