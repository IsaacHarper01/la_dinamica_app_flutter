import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/providers/students_provider.dart';

final attendedIdsProvider = Provider<Set<int>>((ref) {
  final studendsAsync = ref.watch(studentsProvider);

  return studendsAsync.when(
    data: (students) => students.map((s) => s.id).toSet(),
    loading: () => {},
    error: (_, __) => {},
  );
});
