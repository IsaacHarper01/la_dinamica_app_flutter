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

  Future<List<List<String>>> getPlansNamesIds() async {
    try {
      // Consultar los datos almacenados en DataStore
      List<Plans> plans = await Amplify.DataStore.query(Plans.classType);
      List<General> general = await Amplify.DataStore.query(General.classType);

      List<String> names = [];
      List<String> ids = [];
      List<String> planType = [];
      List<String> planPrice = [];
      List<String> numClases = [];
      
      for (var person in general) {
        names.add(person.name!);
        ids.add(person.numId.toString());
      }
      for (var plan in plans) {
        planType.add(plan.type!);
        planPrice.add(plan.price.toString());
        numClases.add(plan.clases.toString());
      }
      return [names, ids, planType, planPrice, numClases];
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

  Future<Map<String, dynamic>> getLastPayandStudentData(int userId) async{
    try {
      List<General> general = await Amplify.DataStore.query(
        General.classType,
        where: General.NUMID.eq(userId),
      );
      List<Payments> payments = await Amplify.DataStore.query(
        Payments.classType,
        where: Payments.USERID.eq(userId),
        sortBy: [Payments.DATE.descending()],
      );

      if (general.isEmpty || payments.isEmpty) {
        safePrint('❌ No se encontraron datos para el usuario con ID $userId');
        return {};
      }
      print('Payments: $payments');

      Map<String, dynamic> result = {
        'lastPay':  payments.last,
        'studentData': general.first,
      };
      safePrint('✅ Datos obtenidos correctamente');
      return result;
    } catch (e) {
      safePrint('❌ Error al obtener los datos del usuario: $e');
      rethrow;
    }
  }

  Future<double> getIncomeRange(DateTime startDate, DateTime endDate) async {
    double totalIncome = 0.0;
    try {
      // Consultar los datos almacenados en DataStore
      List<Payments> payments = await Amplify.DataStore.query(
        Payments.classType,
        where: Payments.DATE.between(TemporalDate(startDate), TemporalDate(endDate)),
      );
      if (payments.isEmpty) {
        safePrint('❌ No se encontraron ingresos en el rango de fechas proporcionado');
        return 0.0;
      }else {
        for (var payment in payments) {
          totalIncome += payment.amount ?? 0.0;
        }
        safePrint('✅ Ingreso calculado correctamente');
      }
      return totalIncome;
    } catch (e) {
      safePrint('❌ Error al obtener los Ingresos: $e');
      rethrow;
    }
  }
  
  Future<Map<String, dynamic>> getTotalAmounRange(DateTime startDate,DateTime endDate) async {
    Map<String, dynamic> clasesDates = {};
    try {
      List<Payments> payments = await Amplify.DataStore.query(
        Payments.classType,
        where: Payments.DATE.between(TemporalDate(startDate), TemporalDate(endDate)),
      );
      if (payments.isEmpty) {
        safePrint('❌ No se encontraron ingresos en el rango de fechas proporcionado');
        return {'total': 0.0, 'count': 0};
      } else {
        for (var payment in payments) {
          String dateKey = payment.date!.format();
          double amount = payment.amount ?? 0.0;

          if (clasesDates.containsKey(dateKey)) {
            clasesDates[dateKey] += amount;
          } else {
            clasesDates[dateKey] = amount;
          }
            }
        }
      return clasesDates;
    } catch (e) {
      safePrint('❌ Error al obtener el monto total: $e');
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

  Future<List<List<String>>> getAgesandAddress(List<int> ids) async {
    try {
      List<General> general = [];
      for (var id in ids) {
        general.addAll(await Amplify.DataStore.query(
          General.classType,
          where: General.NUMID.eq(id),
        ));
      }
      List<String> ages = [];
      List<String> addresses = [];
      if (general.isNotEmpty) {
        for (var student in general) {
          ages.add(student.age.toString());
          addresses.add(student.address!);
        }
        safePrint('✅ Edades y direcciones obtenidas correctamente');
        return [ages, addresses];
      } else {
        safePrint('❌ No se encontró el alumno con el ID proporcionado');
        return [[], []];
      }
    } catch (e) {
      safePrint('❌ Error al obtener las edades y direcciones: $e');
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

  Future<List<Attendance>> getAttendanceRange(
      DateTime startDate, DateTime endDate) async {
    try {
      List<Attendance> attendance = await Amplify.DataStore.query(
        Attendance.classType,
        where: Attendance.DATE.between(
          TemporalDate(startDate),
          TemporalDate(endDate),
        ),
      );
      safePrint('✅ Asistencias obtenidas correctamente');
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
      );
      safePrint('✅ Pagos obtenidos correctamente');
      if (payments.isNotEmpty) {
        return payments.last;
      } else {
        return null;
      }
    } catch (e) {
      safePrint('❌ Error al obtener los pagos: $e');
      rethrow;
    }
  }

  Future<List<Payments>> getPaymentsRange(DateTime startDate, DateTime endDate) async {
    try {
      List<Payments> payments = await Amplify.DataStore.query(
        Payments.classType,
        where: Payments.DATE.between(
          TemporalDate(startDate),
          TemporalDate(endDate),
        ),
      );
      safePrint('✅ Pagos obtenidos correctamente');
      return payments;
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

}
