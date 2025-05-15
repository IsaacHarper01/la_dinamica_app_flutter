import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/backend/database.dart';
import 'package:la_dinamica_app/model/plan.dart';

final planProvider =
    StateNotifierProvider<PlanNotifier, AsyncValue<List<Plan>>>(
  (ref) => PlanNotifier(),
);

class PlanNotifier extends StateNotifier<AsyncValue<List<Plan>>> {
  PlanNotifier() : super(const AsyncValue.loading()) {
    loadPlans();
  }

  final db = DatabaseHelper();

  Future<void> loadPlans() async {
    try {
      final plans = await db.fetchPlansData();
      state = AsyncValue.data(plans);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addPlan(Plan plan) async {
    try {
      await db.InsertPlanData(plan.toMap());
      loadPlans();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deletePlan(int id) async {
    try {
      await db.deletePlanById(id);
      loadPlans();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
