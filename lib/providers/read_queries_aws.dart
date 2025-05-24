import 'dart:ffi';

import 'package:amplify_flutter/amplify_flutter.dart';
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
  // Puedes agregar más métodos para otras consultas si es necesario.
}
