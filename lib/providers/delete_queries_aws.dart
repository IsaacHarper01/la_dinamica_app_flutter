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

Future<void> deleteStudentByID(int id) async {
    try {
      List<General> students = await Amplify.DataStore.query(
        General.classType,
        where: General.NUMID.eq(id),
      );
      if (students.isNotEmpty) {
        for (var student in students) {
          await Amplify.DataStore.delete(student);
        }
        safePrint('✅ Alumno eliminado correctamente');
      } else {
        safePrint('❌ No se encontró el Alumno con el ID proporcionado');
      }
    } catch (e) {
      safePrint('❌ Error al eliminar Alumno: $e');
      rethrow;
    }
  }

Future<void> deleteAttendanceByID(int id, String date) async {
    try {
      List<Attendance> attendance = await Amplify.DataStore.query(
        Attendance.classType,
        where: Attendance.USERID.eq(id),
        sortBy: [Attendance.DATE.descending()],
      );
      List<Payments> payments = await Amplify.DataStore.query(
        Payments.classType,
        where: Payments.USERID.eq(id),
        sortBy: [Payments.DATE.descending()],
      );

      if (attendance.isNotEmpty) {
          await Amplify.DataStore.delete(attendance.last);

      safePrint('✅ Asistencia eliminada correctamente');
      } 

      Payments? lastPayment = payments.isNotEmpty ? payments.last : null;

      if(lastPayment != null) {
        List<Plans> plan = await Amplify.DataStore.query(
        Plans.classType,
        where: Plans.TYPE.eq(lastPayment.type),
        );

        if (plan.first.clases! > lastPayment.clases!  && lastPayment.date!.format() != date){
          Payments updatedPayment = lastPayment.copyWith(clases: lastPayment.clases! + 1);
          await Amplify.DataStore.save(updatedPayment);
        } else {
          await Amplify.DataStore.delete(lastPayment);
        }
      } 
      
    } catch (e) {
      safePrint('❌ Error al eliminar la Asistencia: $e');
      rethrow;
    }
  }

}
