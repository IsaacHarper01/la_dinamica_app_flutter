import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';
import 'package:amplify_datastore/amplify_datastore.dart';

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
      safePrint('✅ Planes obtenidos correctamente');
      return payments;
    } catch (e) {
      safePrint('❌ Error al obtener los planes: $e');
      rethrow;
    }
  }

  Future<List<Metrics>> getMetrics() async {
    try {
      // Consultar los datos almacenados en DataStore
      List<Metrics> metrics = await Amplify.DataStore.query(Metrics.classType);
      safePrint('✅ Planes obtenidos correctamente');
      return metrics;
    } catch (e) {
      safePrint('❌ Error al obtener los planes: $e');
      rethrow;
    }
  }

  Future<List<General>> getGeneral() async {
    try {
      // Consultar los datos almacenados en DataStore
      List<General> general = await Amplify.DataStore.query(General.classType);
      safePrint('✅ Planes obtenidos correctamente');
      return general;
    } catch (e) {
      safePrint('❌ Error al obtener los planes: $e');
      rethrow;
    }
  }

  Future<List<Attendance>> getAttendance() async {
    try {
      // Consultar los datos almacenados en DataStore
      List<Attendance> attendance =
          await Amplify.DataStore.query(Attendance.classType);
      safePrint('✅ Planes obtenidos correctamente');
      return attendance;
    } catch (e) {
      safePrint('❌ Error al obtener los planes: $e');
      rethrow;
    }
  }

  // Puedes agregar más métodos para otras consultas si es necesario.
}
