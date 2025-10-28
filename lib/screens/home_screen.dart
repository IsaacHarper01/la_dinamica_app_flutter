import 'dart:convert';

import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/config/provider/theme_provider.dart';
import 'package:la_dinamica_app/model/UserLocal.dart';

import 'package:la_dinamica_app/providers/date_provider.dart';
import 'package:la_dinamica_app/providers/plan_provider.dart';
import 'package:la_dinamica_app/providers/read_queries_aws.dart';
import 'package:la_dinamica_app/providers/students_provider.dart';
import 'package:la_dinamica_app/providers/user_provider.dart';
import 'package:la_dinamica_app/screens/permissions_screen.dart';
import 'package:la_dinamica_app/screens/scanner.dart';
import 'package:la_dinamica_app/widgets/calendar_widget_general.dart';
import 'package:la_dinamica_app/widgets/payment_box.dart';
import 'package:la_dinamica_app/widgets/select_school_widget.dart';
import 'package:la_dinamica_app/widgets/students_number_home.dart';
import 'package:mobile_scanner/mobile_scanner.dart';


import '../model/student.dart';
import '../widgets/preview_student_container.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> with WidgetsBindingObserver{
  UserLocal? user;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      user = ref.read(userProvider).value;
      if (user != null) {
        ref
            .watch(studentsProvider.notifier)
            .fetchAttendanceToday(ref.read(dateProvider));
      }
    });
    Future.microtask(() => ref.read(planProvider.notifier).loadPlans());
    _searchController.addListener(() {
      ref.read(searchTermProvider.notifier).state = _searchController.text;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  Future<void> checkAction(BuildContext context) async {
    final currentDate = ref.read(dateProvider);
    final result = await scannerQR(context,);
    safePrint('QR Result: $result');
    final decodedResult = decodeInfo(result, user!.tenant.tenant_id);
    if(decodedResult!=null){
      if (decodedResult['codeType']=='QR'){
       final bool status = await manageQR(decodedResult['info'], currentDate, user!);
      }
      else{
       final bool status = await manageBarcode(decodedResult['info'], currentDate, user!);
      }
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
            content: Text('Error'),
            backgroundColor: Colors.red,
            ),
          );
    }
  }

  Future<bool> manageQR(Map<String, dynamic> info, String date, UserLocal user)async{
      final awsDb = DataStoreReadService();
        if (info['action']=='attendance'){
            int id = info['id'] ?? -1;
            if (id == -1) {
              return Future.value(false);
            }

            String name = info['name'];
          
            if (await awsDb.checkIfStudentExists(id, user.tenant.tenant_id)) {
              //check if student exist in General table
              await showPaymentDialog(context, ref, studentID: id, name: name, date: date, user: user);
              return Future.value(true);
            } else {
              return Future.value(false);
            }
          }
        else if(info['action']=='newAccess' && user.permissions['addProfesor']==true){
          String profId = info['profID'];
          final permissions = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PermissionsScreen(),
            ),
          );
          safePrint('Permisos otorgados: $permissions');
          awsDb.giveUserAccess(user.tenant, jsonEncode(permissions), profId);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
            content: Text('Profesor añadido correctamente'),
            backgroundColor: Colors.green,
            ),
          );
          return Future.value(true);
            }
        else{
            return Future.value(false);
              }
  }

  Future<bool> manageBarcode(String productCode, String date, UserLocal user)async{
      return Future.value(false);
  }

  Map<String, dynamic>? decodeInfo(Barcode? data, String tenantId){
    try {
      if (data != null){
        if (data.format == BarcodeFormat.qrCode){
        Map<String, dynamic> info = jsonDecode(data.rawValue!);
        return {'codeType':'QR', 'info': info};
        }
        else{
          safePrint('Codigo de barras detectado: ${data.rawValue}');
          return {'codeType':'BARCODE','info':data.rawValue};
        }
      }
      else {
        return null;
          }
  } catch (e) {
    return null;
  }
  }

  void _clearSearch() {
    _searchController.clear();
    ref.read(searchTermProvider.notifier).state = '';
  }

  @override
  Widget build(BuildContext context) {
    user = ref.watch(userProvider).value;
    final Orientation orientation = MediaQuery.of(context).orientation;
    final bool isPortrait = orientation == Orientation.portrait;
    final screenHeight =
        isPortrait
            ? MediaQuery.of(context).size.height
            : MediaQuery.of(context).size.height * 1.2;

    final themeMode = ref.watch(themeNotifierProvider);
    final isDarkMode = themeMode == ThemeMode.dark;

    final studentsState = ref.watch(studentsProvider);
    final userState = ref.watch(userProvider);
    final filteredStudents = ref.watch(filteredStudentsProvider);
    final allStudents = studentsState.asData?.value ?? [];
    final searchTerm = ref.watch(searchTermProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SignOutButton(),
            Expanded(
              child: Center(
                child: SelectSchoolWidget(),
              ) 
            ),
            user!.permissions["editPast"] == true ?
            CalendarButton() : SizedBox()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => checkAction(context),
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
                                ? screenHeight * 0.1
                                : screenHeight * 0.2,
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
                        Center(
                          child: StudentsNumberHome(studentsNumber: "Asistencias: ${allStudents.length}"),
                        ),
                        SizedBox(height: screenHeight * 0.03),
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
                                                user.tenant.tenant_id,
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

