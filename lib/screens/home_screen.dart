import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/config/provider/theme_provider.dart';
import 'package:la_dinamica_app/model/UserLocal.dart';

import 'package:la_dinamica_app/providers/date_provider.dart';
import 'package:la_dinamica_app/providers/read_queries_aws.dart';
import 'package:la_dinamica_app/providers/students_provider.dart';
import 'package:la_dinamica_app/providers/user_provider.dart';
import 'package:la_dinamica_app/screens/scanner.dart';
import 'package:la_dinamica_app/widgets/calendar_widget_general.dart';
import 'package:la_dinamica_app/widgets/select_school_widget.dart';

import '../model/student.dart';
import '../widgets/preview_student_container.dart';
import '../widgets/search_student_container.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  UserLocal? user;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Defer execution to avoid modifying state during widget build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      user = ref.read(userProvider).value;

      if (user != null) {
        ref
            .watch(studentsProvider.notifier)
            .fetchAttendanceToday(ref.read(dateProvider));
      }
    });

    // Escucha cualquier cambio en el userProvider y dateProvider
    // ref.listen(attendanceRefreshProvider, (prev, next) {
    //   final (user, date) = next;
    //   if (user != null) {
    //     ref.read(studentsProvider.notifier).fetchAttendanceToday(date);
    //   }
    // });

    _searchController.addListener(() {
      ref.read(searchTermProvider.notifier).state = _searchController.text;
    });
  }


  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> registerAssistance(BuildContext context) async {
    final currentDate = ref.read(dateProvider);
    final result = await scannerQR(context, user!.tenantId);
    final aws = DataStoreReadService();

    if (result == null || result.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ID no encontrado'),
          backgroundColor: Colors.red,
        ),
      );
      safePrint("No se escanearon datos o hubo un error");
      return;
    }
    if (result['action'] == 'attencance') {
      final id = result['id'];
      final name = result['name'];
      await ref
          .read(studentsProvider.notifier)
          .insertAttendance(id, name, currentDate);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Asistencia registrada'),
          backgroundColor: Colors.green,
        ),
      );
    }
    if (result['action'] == 'newAccess') {
      aws.giveUserAccess(result["tenant_id"], result["permissions"], user!);
    }
  }

  void _clearSearch() {
    _searchController.clear();
    ref.read(searchTermProvider.notifier).state = '';
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    final bool isPortrait = orientation == Orientation.portrait;
    final screenHeight =
        isPortrait
            ? MediaQuery.of(context).size.height
            : MediaQuery.of(context).size.height * 1.2;
    final screenWidth =
        isPortrait
            ? MediaQuery.of(context).size.width
            : MediaQuery.of(context).size.width * 1.2;
    final themeMode = ref.watch(themeNotifierProvider);
    final isDarkMode = themeMode == ThemeMode.dark;

    final studentsState = ref.watch(studentsProvider);
    final userState = ref.watch(userProvider);
    final filteredStudents = ref.watch(filteredStudentsProvider);
    final allStudents = studentsState.asData?.value ?? [];
    final searchTerm = ref.watch(searchTermProvider);

    return Scaffold(
      appBar: AppBar(
        actions: [
          SignOutButton(),
          SizedBox(width: screenWidth * 0.3),
          SelectSchoolWidget(),
          SizedBox(width: screenWidth * 0.35),
          CalendarButton(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => registerAssistance(context),
        child: const Icon(Icons.qr_code_scanner_outlined),
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      body: userState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data:
            (user) => studentsState.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
              data: (students) {
                if (students.isEmpty) {
                  return Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        isDarkMode
                            ? 'assets/images/f_ma18.png'
                            : 'assets/images/f_ma11.png',
                        height:
                            isDarkMode
                                ? screenHeight * 0.2
                                : screenHeight * 0.1,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }

                return SingleChildScrollView(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: screenHeight * 0.06),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Buscar por ID o nombre...',
                              prefixIcon: const Icon(Icons.search),
                              suffixIcon:
                                  searchTerm.isNotEmpty
                                      ? IconButton(
                                        icon: const Icon(Icons.clear),
                                        onPressed: _clearSearch,
                                      )
                                      : null,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              filled: true,
                              fillColor: Theme.of(context).colorScheme.surface,
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.06),
                        SearchStudentContainer(
                          circleText:
                              searchTerm.isEmpty
                                  ? 'Asistencias de hoy: ${allStudents.length}'
                                  : 'Mostrando: ${filteredStudents.length} de ${allStudents.length}',
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        if (filteredStudents.isEmpty && searchTerm.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 64,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withAlpha(128),
                                ),
                                Text(
                                  'No se encontraron estudiantes\ncon el término: "$searchTerm"',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyLarge?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface.withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          Column(
                            children:
                                filteredStudents.asMap().entries.map((entry) {
                                  Student student = entry.value;

                                  return Column(
                                    children: [
                                      PreviewStudentContainer(
                                        name: student.name,
                                        image: student.image,
                                        onDismissed: () {
                                          ref
                                              .read(studentsProvider.notifier)
                                              .deleteAttendance(
                                                student.id,
                                                ref.read(dateProvider),
                                                user.tenantId,
                                              );
                                        },
                                      ),
                                      const Divider(
                                        height: 0,
                                        indent: 20,
                                        endIndent: 20,
                                      ),
                                    ],
                                  );
                                }).toList(),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
      ),
    );
  }
}

