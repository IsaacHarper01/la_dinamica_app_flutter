import 'dart:ffi';

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
        where: Attendance.USERID.eq(id) & Attendance.DATE.eq(TemporalDate(DateTime.parse(date))),
      );
      if (attendance.isNotEmpty) {
        for (var att in attendance) {
          await Amplify.DataStore.delete(att);
        }
        safePrint('✅ Asistencia eliminada correctamente');
      } else {
        safePrint('❌ No se encontró la asistencia con el ID proporcionado');
      }
    } catch (e) {
      safePrint('❌ Error al eliminar la Asistencia: $e');
      rethrow;
    }
  }
}
