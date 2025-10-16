import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/model/metrics_state.dart';
import 'package:la_dinamica_app/providers/read_queries_aws.dart';
import 'package:la_dinamica_app/providers/user_provider.dart';

final metricsProvider = StateNotifierProvider.family<MetricsProvider, AsyncValue<MetricsState>, String>(
  (ref, userID) => MetricsProvider(ref, userID),
);

class MetricsProvider extends StateNotifier<AsyncValue<MetricsState>>{
  final Ref ref;
  final String userID;

  MetricsProvider(this.ref, this.userID) : super(const AsyncValue.loading()){
    loadLastGrades();
  }

  Future<void> loadLastGrades() async{
    final user = await ref.watch(userProvider.future);
    MetricsState metrics = MetricsState(); 
    final datastoreservice = DataStoreReadService();
    try{
      final grades = await datastoreservice.getLastExam(user.tenant.tenant_id, userID);
      if(grades != null){
      metrics = metrics.copyWith(grades: grades, evaluations: [grades.first.evaluation!]);
      }
    }
    catch(e){
      safePrint("Error al cargar las calificaciones: $e");
    }
  }
}