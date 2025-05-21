import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';

class DataStoreDeleteService {
  // Método para eliminar un plan por ID
  Future<void> deletePlanById(String planId) async {
    try {
      // Hacemos una consulta para encontrar el plan por su ID
      List<Plans> plans = await Amplify.DataStore.query(
        Plans.classType,
        where: Plans.ID.eq(planId),
      );

      // Verificamos si se encontró el plan
      if (plans.isNotEmpty) {
        Plans planToDelete = plans.first; // Tomamos el primer plan encontrado

        // Eliminamos el plan del DataStore
        await Amplify.DataStore.delete(planToDelete);
        safePrint('✅ Plan eliminado correctamente');
      } else {
        safePrint('❌ No se encontró el plan con el ID proporcionado');
      }
    } catch (e) {
      safePrint('❌ Error al eliminar el plan: $e');
      rethrow;
    }
  }
}
