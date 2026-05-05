import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';
import 'package:la_dinamica_app/providers/delete_queries_aws.dart';
import 'package:la_dinamica_app/providers/read_queries_aws.dart';
import 'package:la_dinamica_app/providers/storageS3.dart';
import 'package:la_dinamica_app/providers/user_provider.dart';


final searchTermProvider = StateProvider<String>((ref) => '');

final studentsProvider =
    StateNotifierProvider<StudentsNotifier, AsyncValue<List<Student>>>((ref) {
      return StudentsNotifier(ref);
    });

final filteredStudentsProvider = Provider<List<Student>>((ref) {
  final students = ref.watch(studentsProvider).asData?.value ?? [];
  final searchTerm = ref.watch(searchTermProvider).toLowerCase().trim();

  if (searchTerm.isEmpty) {
    return students;
  }

  return students.where((student) {
    final name = student.name!.toLowerCase();
    final id = student.user_id;
    return name.contains(searchTerm) || id == int.tryParse(searchTerm);
  }).toList();
});

class StudentsNotifier extends StateNotifier<AsyncValue<List<Student>>> {
  final Ref ref;

  StudentsNotifier(this.ref) : super(const AsyncValue.loading()){
    fetchStudents();
  }
  
  Future<void> fetchStudents() async {
    try {
      final awsDb = DataStoreReadService();
      final user = await ref.watch(userProvider.future);
      final tenenatId = user.tenant!.tenant_id;
      final students = await awsDb.getStudents(tenenatId);
      if (students.isEmpty) {
        state = const AsyncValue.data([]);
        return;
      }

      state = AsyncValue.data(students);
    } catch (e) {
      if (!mounted) return;
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> deleteStudent(Student student)async{
    try {
      final awsConnection = DataStoreDeleteService();
      final s3Connection = Storages3();
      await s3Connection.deleteFile(student.image!);
      await awsConnection.deleteStudent(student);
    } catch (e) {
      if (!mounted) return;
      state = AsyncValue.error(e, StackTrace.current);
    }finally{
      await fetchStudents();
    }
  }
}
