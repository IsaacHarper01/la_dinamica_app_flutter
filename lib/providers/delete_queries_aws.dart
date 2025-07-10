import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';

class DataStoreDeleteService {
  // Método para eliminar un plan por ID
  Future<void> deletePlanById(String planId) async {
    try {
      // Hacemos una consulta para encontrar el plan por su ID
      List<LocalPlan> plans = await Amplify.DataStore.query(
        LocalPlan.classType,
        where: LocalPlan.ID.eq(planId),
      );

      // Verificamos si se encontró el plan
      if (plans.isNotEmpty) {
        LocalPlan planToDelete = plans.first; // Tomamos el primer plan encontrado

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
        List<Student> students = await Amplify.DataStore.query(
          Student.classType,
          where: Student.USER_ID.eq(id),
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
          where: Attendance.USER_ID.eq(id),
          sortBy: [Attendance.DATE.descending()],
        );
        List<Pay> payments = await Amplify.DataStore.query(
          Pay.classType,
          where: Pay.USER_ID.eq(id),
          sortBy: [Pay.DATE.descending()],
        );

        if (attendance.isNotEmpty) {
            await Amplify.DataStore.delete(attendance.last);

        safePrint('✅ Asistencia eliminada correctamente');
        } 

        Pay? lastPayment = payments.isNotEmpty ? payments.last : null;

        if(lastPayment != null) {
          List<LocalPlan> plan = await Amplify.DataStore.query(
          LocalPlan.classType,
          where: LocalPlan.TYPE.eq(lastPayment.type),
          );

          if (plan.first.clases! > lastPayment.clases!  && lastPayment.date!.format() != date){
            Pay updatedPayment = lastPayment.copyWith(clases: lastPayment.clases! + 1);
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
