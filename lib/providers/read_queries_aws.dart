import 'dart:ffi';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:la_dinamica_app/model/plan.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';


class DataStoreReadService {
  Future<List<Plans>> getPlans() async {
    try {
      // Consultar los datos almacenados en DataStore
      List<Plans> plans = await Amplify.DataStore.query(Plans.classType);
      safePrint('✅ Planes obtenidos correctamente');
      return plans;
    } catch (e) {
      safePrint('❌ Error al obtener los planes: $e');
      rethrow;
    }
  }

  Future<List<Payments>> getPayments() async {
    try {
      // Consultar los datos almacenados en DataStore
      List<Payments> payments =
          await Amplify.DataStore.query(Payments.classType);
      safePrint('✅ Pagos obtenidos correctamente');
      return payments;
    } catch (e) {
      safePrint('❌ Error al obtener los Pagos: $e');
      rethrow;
    }
  }

  Future<List<Metrics>> getMetrics() async {
    try {
      // Consultar los datos almacenados en DataStore
      List<Metrics> metrics = await Amplify.DataStore.query(Metrics.classType);
      safePrint('✅ Metricas obtenidas correctamente');
      return metrics;
    } catch (e) {
      safePrint('❌ Error al obtener las Metricas: $e');
      rethrow;
    }
  }

  Future<List<General>> getGeneral() async {
    try {
      // Consultar los datos almacenados en DataStore
      List<General> general = await Amplify.DataStore.query(General.classType);
      safePrint('✅ Alumnos obtenidos correctamente');
      return general;
    } catch (e) {
      safePrint('❌ Error al obtener los Alumnos: $e');
      rethrow;
    }
  }

  Future<List<Attendance>> getAttendance() async {
    try {
      // Consultar los datos almacenados en DataStore
      List<Attendance> attendance =
          await Amplify.DataStore.query(Attendance.classType);
      safePrint('✅ Asistencias obtenidas correctamente');
      return attendance;
    } catch (e) {
      safePrint('❌ Error al obtener las asistencias: $e');
      rethrow;
    }
  }

  Future<List<Attendance>> getAttendanceByDate(String date) async {
    try {
      List<Attendance> attendance = await Amplify.DataStore.query(
        Attendance.classType,
        where: Attendance.DATE.eq(date),
      );
      return attendance;
    } catch (e) {
      safePrint('❌ Error al obtener las asistencias: $e');
      rethrow;
    }
  }

  Future<List<String?>> getImages(List<int> ids) async {
    try {

      List<General> general = []; 
        for (var id in ids) {
          general.addAll(await Amplify.DataStore.query(
            General.classType,
            where: General.NUMID.eq(id),
          ));
        }
      List<String> images = [];
      if (general.isNotEmpty) {
        for (var student in general) {
          images.add(student.image!);
        }
        safePrint('✅ Imagenes obtenidas correctamente');
        return images;
      } else {
        safePrint('❌ No se encontró el alumno con el ID proporcionado');
        return [];	
      }
    } catch (e) {
      safePrint(' Error al obtener las imagenes: $e');
      rethrow;
    }
  }

  Future<Plans?> getSimplePlan() async {
    try {
      // Consultar los datos almacenados en DataStore
      List<Plans> plans = await Amplify.DataStore.query(
        Plans.classType,
        where: Plans.CLASES.eq(1),
        );
      safePrint('✅ Planes obtenidos correctamente');
      if (plans.isNotEmpty) {
        return plans.first;
      } else {
        return null;
      }
    } catch (e) {
      safePrint('❌ Error al obtener los planes: $e');
      rethrow;
    }
  }

  Future<Payments?> getLastPayment(int userId) async {
    try {
      // Consultar los datos almacenados en DataStore
      List<Payments> payments = await Amplify.DataStore.query(
        Payments.classType,
        where: Payments.USERID.eq(userId),
        sortBy: [Payments.DATE.descending()],
        pagination: const QueryPagination(limit: 1),
      );
      safePrint('✅ Pagos obtenidos correctamente');
      if (payments.isNotEmpty) {
        return payments.first;
      } else {
        return null;
      }
    } catch (e) {
      safePrint('❌ Error al obtener los pagos: $e');
      rethrow;
    }
  }

  Future<void> verifyPayment(int userId, String date) async {
    try {
      Payments? lastPayment = await getLastPayment(userId);
      Plans? basePlan = await getSimplePlan();
      double cost = 0.0;
      String planType = 'Clase Unica';

      if (basePlan != null) {
        cost = basePlan.price!;
        planType = basePlan.type!;
      }

      if (lastPayment == null) {
        final newPayment = Payments(
          userId: userId,
          amount: cost,
          clases: 0,
          type: planType,
          date: TemporalDate(DateTime.parse(date)),
        );

      await Amplify.DataStore.save(newPayment);
      return;

      } else {
        if (lastPayment.type != planType && (lastPayment.clases!) > 0) {
          var remainingClases = (lastPayment.clases!) -1;
          Payments newPayment = lastPayment.copyWith(
            clases: remainingClases,
            date: TemporalDate(DateTime.parse(date)),
          );
          await Amplify.DataStore.save(newPayment);
          return;
        } else {
          final newPayment = Payments(
          userId: userId,
          amount: cost,
          clases: 0,
          type: planType,
          date: TemporalDate(DateTime.parse(date)),
        );
        await Amplify.DataStore.save(newPayment);
        }
      }

      safePrint('✅ Pago verificado correctamente');
      
    } catch (e) {
      safePrint('❌ Error al verificar el pago: $e');
      rethrow;
    }
  }
  // Puedes agregar más métodos para otras consultas si es necesario.
}
