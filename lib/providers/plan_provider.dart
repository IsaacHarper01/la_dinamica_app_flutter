import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';
import 'package:la_dinamica_app/providers/create_queries_aws.dart';
import 'package:la_dinamica_app/providers/default_plan_provider.dart';
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

  DataStoreReadService dataStoreReadService = DataStoreReadService();
  GraphqlServiceCreate dataStoreService = GraphqlServiceCreate();
  DataStoreDeleteService dataStoreDeleteService = DataStoreDeleteService();


  Future<void> loadPlans() async {
    LocalPlan defaultPlan = LocalPlan(
      type: "none",
      clases: 0,
      price: 0.0,
      client_id: "none",
    );
    final user = await ref.watch(userProvider.future);
    final gymId = user.tenant!.tenant_id;
    try {
      final awsPlans = await dataStoreReadService.getPlans(gymId);
      state = AsyncValue.data(awsPlans);
      for (var plan in awsPlans){
        if (plan.defaultPlan == true){
          defaultPlan = plan;
          break;
        }
      }
      ref.read(defaultPlanProvider.notifier).state = defaultPlan;
      safePrint('Plan predeterminado cargado: ${ref.read(defaultPlanProvider).type}');
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
    final user = await ref.watch(userProvider.future);
    try {
      await dataStoreDeleteService.deletePlanById(id, user.tenant!.tenant_id);
      loadPlans();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updatePlan(LocalPlan oldPlan, String newType, int newClases, double newPrice, int? newExpiration) async{
    final copyPlan = oldPlan.copyWith(
      type: newType,
      clases: newClases,
      price: newPrice,
      expiration: newExpiration,
    );
    await Amplify.DataStore.save(copyPlan);
    loadPlans();
  }

  Future<void> updatePlanDefaultStatus(LocalPlan oldPlan ,LocalPlan newplan) async {
    try {
        final updatedPlan = newplan.copyWith(defaultPlan: true);
        await Amplify.DataStore.save(updatedPlan);
        final updatedOldPlan = oldPlan.copyWith(defaultPlan: false);
        await Amplify.DataStore.save(updatedOldPlan);
        loadPlans();
        safePrint('✅ Estado de plan predeterminado actualizado correctamente');
    } catch (e) {
      safePrint('❌ Error al actualizar el estado de plan predeterminado: $e');
    }
  }
}
