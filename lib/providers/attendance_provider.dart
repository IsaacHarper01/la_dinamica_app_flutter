import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';
import 'package:la_dinamica_app/providers/attendant_students_provider.dart';

final attendedIdsProvider = Provider<Set<Student>>((ref) {
  final studendsAsync = ref.watch(studentsAttendanceProvider);

  return studendsAsync.when(
    data: (students) => students.toSet(),
    loading: () => {},
    error: (_, __) => {},
  );
});
