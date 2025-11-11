import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';

class DataStoreDeleteService {
  // Método para eliminar un plan por ID
  Future<void> deletePlanById(String planId, String tenantID) async {
    try {
      // Hacemos una consulta para encontrar el plan por su ID
      List<LocalPlan> plans = await Amplify.DataStore.query(
        LocalPlan.classType,
        where: LocalPlan.ID.eq(planId).and(LocalPlan.CLIENT_ID.eq(tenantID)),
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

  Future<void> deleteStudentByID(int id, String tenantId) async {
      try {
        List<Student> students = await Amplify.DataStore.query(
          Student.classType,
          where: Student.USER_ID.eq(id).and(Student.CLIENT_ID.eq(tenantId)),
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

  Future<void> deleteAttendanceByID(int id, String date, String tenantId) async {
      try {
        List<Attendance> attendance = await Amplify.DataStore.query(
          Attendance.classType,
          where: Attendance.USER_ID.eq(id)
          .and(Attendance.CLIENT_ID.eq(tenantId))
          .and(Attendance.DATE.eq(date)),
          sortBy: [Attendance.DATE.descending()],
        );
        List<Payment> payments = await Amplify.DataStore.query(
          Payment.classType,
          where: Payment.USER_ID.eq(id)
          .and(Payment.CLIENT_ID.eq(tenantId))
          .and(Payment.DATE.eq(date)),
          sortBy: [Payment.DATE.descending()],
        );

        if (attendance.isNotEmpty) {
            await Amplify.DataStore.delete(attendance.first);
            safePrint('✅ Asistencia eliminada correctamente');
        } 

        Payment? lastPayment = payments.isNotEmpty ? payments.last : null;

        if(lastPayment != null) {
          List<LocalPlan> plan = await Amplify.DataStore.query(
          LocalPlan.classType,
          where: LocalPlan.TYPE.eq(lastPayment.plan!.type),
          );

          if (plan.first.clases! > lastPayment.clases!  && lastPayment.date!.format() != date){
            Payment updatedPayment = lastPayment.copyWith(clases: lastPayment.clases! + 1);
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

  Future<void> deleteExamn(Evaluations exam, String tenantId) async {
    try {
      final metrics = await Amplify.DataStore.query(
        JoinMetric.classType,
        where: JoinMetric.EVALUATION.eq(exam.id).and(JoinMetric.TENANT_ID.eq(tenantId)),
      );
      for (var metric in metrics) {
        await Amplify.DataStore.delete(metric);
        await Amplify.DataStore.delete(metric.metric!);
      }
      await Amplify.DataStore.delete(exam);
      safePrint('✅ Examen eliminado correctamente');

    } catch (e) {
      safePrint('❌ Error al eliminar el examen: $e');
      rethrow;
    }
  }

  Future<void> deletePaymentByID(String id, String tenantId) async {
      try {
        List<Payment> payments = await Amplify.DataStore.query(
          Payment.classType,
          where: Payment.ID.eq(id).and(Payment.CLIENT_ID.eq(tenantId)),
        );
        if (payments.isNotEmpty) {
          for (var payment in payments) {
            await Amplify.DataStore.delete(payment);
          }
          safePrint('✅ Pago eliminado correctamente');
        } else {
          safePrint('❌ No se encontró el Pago con el ID proporcionado');
        }
      } catch (e) {
        safePrint('❌ Error al eliminar Pago: $e');
      }
    }

  Future<void> deleteProduct(Product product)async{
      Amplify.DataStore.delete(product);
  }

}
