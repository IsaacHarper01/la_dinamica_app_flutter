import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';

class DataStoreService {
  Future<void> savePlan({
    required String type,
    required int clases,
    required double price,
  }) async {
    final item = Plans(
      type: type,
      clases: clases,
      price: price,
    );

    try {
      await Amplify.DataStore.save(item);
      safePrint('✅ Plan guardado correctamente');
    } catch (e) {
      safePrint('❌ Error al guardar el plan: $e');
      rethrow;
    }
  }

  Future<void> savePayment({
    required String userId,
    required double amount,
    required int clases,
    required String type,
    required String date,
  }) async {
    final item = Payments(
        userId: userId,
        amount: amount,
        clases: clases,
        type: type,
        date: TemporalDate.fromString("${date}Z"));

    try {
      await Amplify.DataStore.save(item);
      safePrint('✅ Payment guardado correctamente');
    } catch (e) {
      safePrint('❌ Error al guardar el Payment: $e');
      rethrow;
    }
  }

  Future<void> saveMetric({
    required String userId,
    required String metric,
    required String date,
    required double value,
  }) async {
    final item = Metrics(
        userId: userId,
        metric: metric,
        date: TemporalDate.fromString("${date}Z"),
        value: value);

    try {
      await Amplify.DataStore.save(item);
      safePrint('✅ Payment guardado correctamente');
    } catch (e) {
      safePrint('❌ Error al guardar el Payment: $e');
      rethrow;
    }
  }

  Future<void> saveGeneral({
    required String name,
    required String address,
    required String phone,
    required int age,
    required String birthday,
    required String email,
    required String image,
  }) async {
    final item = General(
        name: name,
        address: address,
        phone: phone,
        age: age,
        birthday: TemporalDate.fromString("${birthday}Z"),
        email: email,
        image: image);

    try {
      await Amplify.DataStore.save(item);
      safePrint('✅ Payment guardado correctamente');
    } catch (e) {
      safePrint('❌ Error al guardar el Payment: $e');
      rethrow;
    }
  }

  Future<void> saveAttendance({
    required String userId,
    required String name,
    required String date,
    required String status,
  }) async {
    final item = Attendance(
        userId: userId,
        name: name,
        date: TemporalDate.fromString("${date}Z"),
        status: status);

    try {
      await Amplify.DataStore.save(item);
      safePrint('✅ Payment guardado correctamente');
    } catch (e) {
      safePrint('❌ Error al guardar el Payment: $e');
      rethrow;
    }
  }

  // Puedes añadir más métodos aquí: getPlans, deletePlan, updatePlan, etc.
}
