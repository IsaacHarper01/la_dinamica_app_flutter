import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';

class DataStoreReadService {

  Future<List<LocalPlan>> getPlans(String tenantId) async {
    try {
      // Consultar los datos almacenados en DataStore
      List<LocalPlan> plans = await Amplify.DataStore.query(
        LocalPlan.classType,
        where: LocalPlan.CLIENT_ID.eq(tenantId),
      );
      safePrint('✅ Planes obtenidos correctamente');
      return plans;
    } catch (e) {
      safePrint('❌ Error al obtener los planes: $e');
      rethrow;
    }
  }

  Future<List<List<String>>> getPlansNamesIds(String tenantId) async {
    try {
      // Consultar los datos almacenados en DataStore
      List<LocalPlan> plans = await Amplify.DataStore.query(
        LocalPlan.classType,
        where: LocalPlan.CLIENT_ID.eq(tenantId),
      );
      List<Student> general = await Amplify.DataStore.query(
        Student.classType,
        where: Student.CLIENT_ID.eq(tenantId),
        );

      List<String> names = [];
      List<String> ids = [];
      List<String> planType = [];
      List<String> planPrice = [];
      List<String> numClases = [];

      for (var person in general) {
        names.add(person.name!);
        ids.add(person.user_id.toString());
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

  Future<List<Pay>> getPayments(String tenantId) async {
    try {
      // Consultar los datos almacenados en DataStore
      List<Pay> payments = await Amplify.DataStore.query(
        Pay.classType,
        where: Pay.CLIENT_ID.eq(tenantId),
        );
      safePrint('✅ Pagos obtenidos correctamente');
      return payments;
    } catch (e) {
      safePrint('❌ Error al obtener los Pagos: $e');
      rethrow;
    }
  }

  Future<List<Pay>> getPaymentsRange(
    DateTime startDate,
    DateTime endDate,
    String tenantId,
  ) async {
    try {
      List<Pay> payments = await Amplify.DataStore.query(
        Pay.classType,
        where: Pay.DATE.between(TemporalDate(startDate), TemporalDate(endDate)) 
            .and(Pay.CLIENT_ID.eq(tenantId)),
      );
      safePrint('✅ Pagos obtenidos correctamente');
      return payments;
    } catch (e) {
      safePrint('❌ Error al obtener los pagos: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getLastPayandStudentData(int userId, String tenantId) async {
    try {
      List<Student> general = await Amplify.DataStore.query(
        Student.classType,
        where: Student.USER_ID.eq(userId)
          .and(Student.CLIENT_ID.eq(tenantId)),
      );
      List<Pay> payments = await Amplify.DataStore.query(
        Pay.classType,
        where: Pay.USER_ID.eq(userId) 
            .and(Pay.CLIENT_ID.eq(tenantId)),
        sortBy: [Pay.DATE.descending()],
      );

      if (general.isEmpty || payments.isEmpty) {
        safePrint('❌ No se encontraron datos para el usuario con ID $userId');
        return {};
      }
      safePrint('Payments: $payments');

      Map<String, dynamic> result = {
        'lastPay': payments.first,
        'studentData': general.first,
      };
      safePrint('✅ Datos obtenidos correctamente');
      return result;
    } catch (e) {
      safePrint('❌ Error al obtener los datos del usuario: $e');
      rethrow;
    }
  }

  Future<double> getIncomeRange(DateTime startDate, DateTime endDate, String tenantId) async {
    double totalIncome = 0.0;
    try {
      // Consultar los datos almacenados en DataStore
      List<Pay> payments = await Amplify.DataStore.query(
        Pay.classType,
        where: Pay.DATE.between(TemporalDate(startDate), TemporalDate(endDate)) 
            .and(Pay.CLIENT_ID.eq(tenantId)),
      );
      if (payments.isEmpty) {
        safePrint(
          '❌ No se encontraron ingresos en el rango de fechas proporcionado',
        );
        return 0.0;
      } else {
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
  
  Future<List<Map<String, dynamic>>?> getTotalAmounRange(DateTime startDate,DateTime endDate, String tenantId) async {
    Map<String, dynamic> clasesDates = {};
    Map<String, dynamic> studentsPerDay = {};

    try {
      List<Pay> payments = await Amplify.DataStore.query(
        Pay.classType,
        where: Pay.DATE.between(TemporalDate(startDate), TemporalDate(endDate)) 
            .and(Pay.CLIENT_ID.eq(tenantId)),
      );
      List<Attendance> students = await Amplify.DataStore.query(
        Attendance.classType,
        where: Attendance.DATE.between(TemporalDate(startDate),TemporalDate(endDate)) 
            .and(Attendance.CLIENT_ID.eq(tenantId)),
        );

      if (payments.isNotEmpty) {
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
      else {
        safePrint('❌ No se encontraron pagos en el rango de fechas proporcionado');
        clasesDates = {};
        }
      if (students.isNotEmpty) {

        for (var student in students) {
          String dateKey = student.date!.format();
          if (studentsPerDay.containsKey(dateKey)) {
            studentsPerDay[dateKey] += 1;
          } else {
            studentsPerDay[dateKey] = 1;
          }
        }
      } else{
        safePrint('❌ No se encontraron asistencias en el rango de fechas proporcionado');
        studentsPerDay = {};
      }
      return [clasesDates, studentsPerDay];
    }
    catch (e) {
      safePrint('❌ Error al obtener el monto total: $e');
      rethrow;
    }
  }

  Future<List<Metric>> getMetrics(String tenantId) async {
    try {
      // Consultar los datos almacenados en DataStore
      List<Metric> metrics = await Amplify.DataStore.query(
        Metric.classType,
        where: Metric.CLIENT_ID.eq(tenantId),
      );
      safePrint('✅ Metricas obtenidas correctamente');
      return metrics;
    } catch (e) {
      safePrint('❌ Error al obtener las Metricas: $e');
      rethrow;
    }
  }

  Future<List<Student>> getStudents(String tenantId) async {
    try {
      // Consultar los datos almacenados en DataStore
      List<Student> general = await Amplify.DataStore.query(
        Student.classType,
        where: Student.CLIENT_ID.eq(tenantId),
        );
        
      safePrint('✅ Alumnos obtenidos correctamente');
      return general;
    } catch (e) {
      safePrint('❌ Error al obtener los Alumnos: $e');
      rethrow;
    }
  }

  Future<bool> checkIfStudentExists(int id, String tenantId) async {
    try {
      // Consultar los datos almacenados en DataStore
      List<Student> general = await Amplify.DataStore.query(
        Student.classType,
        where: Student.USER_ID.eq(id) 
            .and(Student.CLIENT_ID.eq(tenantId)),
      );
      if (general.isNotEmpty) {
        safePrint('✅ El alumno con ID $id existe');
        return true;
      } else {
        safePrint('❌ El alumno con ID $id no existe');
        return false;
      }
    } catch (e) {
      safePrint('❌ Error al verificar la existencia del alumno: $e');
      rethrow;
    }
  }

  Future<List<List<String>>> getAgesandAddress(List<int> ids, String tenantId) async {
    try {
      List<Student> general = [];
      for (var id in ids) {
        general.addAll(
          await Amplify.DataStore.query(
            Student.classType,
            where: Student.USER_ID.eq(id)
              .and(Student.CLIENT_ID.eq(tenantId)),
          )
        );
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

  Future<List<Attendance>> getAttendance(String tenantId) async {
    try {
      // Consultar los datos almacenados en DataStore
      List<Attendance> attendance = await Amplify.DataStore.query(
        Attendance.classType,
        where: Attendance.CLIENT_ID.eq(tenantId),
      );
      safePrint('✅ Asistencias obtenidas correctamente');
      return attendance;
    } catch (e) {
      safePrint('❌ Error al obtener las asistencias: $e');
      rethrow;
    }
  }

  Future<List<Attendance>> getAttendanceByDate(String date, String tenantId) async {
    try {
      List<Attendance> attendance = await Amplify.DataStore.query(
        Attendance.classType,
        where: Attendance.DATE.eq(date) 
            .and(Attendance.CLIENT_ID.eq(tenantId)),
      );
      return attendance;
    } catch (e) {
      safePrint('❌ Error al obtener las asistencias: $e');
      rethrow;
    }
  }

  Future<List<Attendance>> getAttendanceRange(
    DateTime startDate,
    DateTime endDate,
    String tenantId,
  ) async {
    try {
      List<Attendance> attendance = await Amplify.DataStore.query(
        Attendance.classType,
        where: Attendance.DATE.between(TemporalDate(startDate),TemporalDate(endDate),) 
            .and(Attendance.CLIENT_ID.eq(tenantId)),
      );
      safePrint('✅ Asistencias obtenidas correctamente');
      return attendance;
    } catch (e) {
      safePrint('❌ Error al obtener las asistencias: $e');
      rethrow;
    }
  }

  Future<LocalPlan?> getSimplePlan(String tenantId) async {
    try {
      // Consultar los datos almacenados en DataStore
      List<LocalPlan> plans = await Amplify.DataStore.query(
        LocalPlan.classType,
        where: LocalPlan.CLASES.eq(1) 
            .and(LocalPlan.CLIENT_ID.eq(tenantId)),
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

  Future<Pay?> getLastPayment(int userId, String tenantId) async {
    try {
      // Consultar los datos almacenados en DataStore
      List<Pay> payments = await Amplify.DataStore.query(
        Pay.classType,
        where: Pay.USER_ID.eq(userId)  
            .and(Pay.CLIENT_ID.eq(tenantId)),
        sortBy: [Pay.DATE.descending()],
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

  Future<void> verifyPayment(int userId, String date, String tenantId, String profId) async {
    try {
      safePrint("Verificando pago para el usuario con ID: $userId en la fecha: $date");
      Pay? lastPayment = await getLastPayment(userId, tenantId);
      LocalPlan? basePlan = await getSimplePlan(tenantId);
      double cost = 0.0;
      String planType = 'Clase Unica';

      if (basePlan != null) {
        cost = basePlan.price!;
        planType = basePlan.type!;
      }
      safePrint('Plan base obtenido: $basePlan');
      safePrint('Ultimo pago obtenido: $lastPayment');
      if (lastPayment == null) {
        final newPayment = Pay(
          user_id: userId, //This user ID is the student ID
          amount: cost,
          clases: 0,
          type: planType,
          date: TemporalDate(DateTime.parse(date)),
          client_id: tenantId, //this user ID is the client ID
          prof_id: profId, //This user ID is the teacher ID
        );

        await Amplify.DataStore.save(newPayment);
        return;
      } else {
        if (lastPayment.type != planType && (lastPayment.clases!) > 0) {
          var remainingClases = (lastPayment.clases!) - 1;
          Pay newPayment = lastPayment.copyWith(clases: remainingClases);
          await Amplify.DataStore.delete(lastPayment);
          await Amplify.DataStore.save(newPayment);
          safePrint('Pago actualizado con clases restantes: $remainingClases');
          return;
        } else {
          final newPayment = Pay(
            user_id: userId,
            amount: cost,
            clases: 0,
            type: planType,
            date: TemporalDate(DateTime.parse(date)),
            client_id: tenantId, // this user ID is the client ID
            prof_id: profId, //This user ID is the teacher ID
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

  Future<bool> userExists(String userId) async {
    try {
      final users = await Amplify.DataStore.query(
        User.classType,
        where: User.ID.eq(userId),
      );
      return users.isNotEmpty;
    } catch (e) {
      safePrint('❌ Error checking user: $e');
      return false;
    }
  }

  Future<bool> clientExists(String userId) async {
    try {
      final clients = await Amplify.DataStore.query(
        Client.classType,
        where: Client.ID.eq(userId),
      );
      return clients.isNotEmpty;
    } catch (e) {
      safePrint('❌ Error checking client: $e');
      return false;
    }
  }

  Future<User?> getUser(String userId) async {
    try {
      final users = await Amplify.DataStore.query(
        User.classType,
        where: User.ID.eq(userId),
      );
      if (users.isNotEmpty) return users.first;
      safePrint('⚠️ User not found with ID: $userId');
      return null;
    } catch (e) {
      safePrint('❌ Error getting user: $e');
      rethrow;
    }
  }

  Future<Client?> getClient(String userId) async {
    try {
      final clients = await Amplify.DataStore.query(
        Client.classType,
        where: Client.ID.eq(userId),
      );
      if (clients.isNotEmpty) {
        return clients.first;
      } else {
        return null;
      }
    } catch (e) {
      safePrint('❌ Error getting client: $e');
      rethrow;
    }
  }
}
