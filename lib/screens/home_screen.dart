import 'dart:convert';

import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/config/provider/theme_provider.dart';
import 'package:la_dinamica_app/model/UserLocal.dart';

import 'package:la_dinamica_app/models/ModelProvider.dart';
import 'package:la_dinamica_app/providers/date_provider_new.dart';
import 'package:la_dinamica_app/providers/plan_provider.dart';
import 'package:la_dinamica_app/providers/read_queries_aws.dart';
import 'package:la_dinamica_app/providers/attendant_students_provider.dart';
import 'package:la_dinamica_app/providers/user_provider.dart';
import 'package:la_dinamica_app/screens/permissions_screen.dart';
import 'package:la_dinamica_app/screens/scanner.dart';
import 'package:la_dinamica_app/screens/student_detail_screen.dart';
import 'package:la_dinamica_app/widgets/calendar_widget_general.dart';
import 'package:la_dinamica_app/widgets/payment_box.dart';
import 'package:la_dinamica_app/widgets/products_page.dart/product_payment_box.dart';
import 'package:la_dinamica_app/widgets/select_school_widget.dart';
import 'package:la_dinamica_app/widgets/students_number_home.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../widgets/preview_student_container.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> with WidgetsBindingObserver{
  UserLocal? user;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      user = ref.read(userProvider).value;
      if (user != null) {
        ref
            .watch(studentsAttendanceProvider.notifier)
            .loadValues();
      }
    });
    Future.microtask(() => ref.read(planProvider.notifier).loadPlans());
  }

  Future<void> checkAction(BuildContext context) async {
    final currentDate = ref.read(dateProvider).today;
    final result = await scannerQR(context,);
    safePrint('QR Result: $result');
    final decodedResult = decodeInfo(result);
    safePrint('DECODED Result: $decodedResult');
    if(decodedResult!=null){
      if (decodedResult['codeType']=='QR'){
        await manageQR(decodedResult['info'], currentDate, user!);
      }
      else{
       await manageBarcode(decodedResult['info'], currentDate, user!);
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
            String id = info['id'] ?? "-1";
            if (id == "-1") {
              return Future.value(false);
            }

            final student = await awsDb.checkIfStudentExists(id, user.tenant!.tenant_id);
            if (student!=null) {
              //check if student exist in General table
              await showPaymentDialog(context, ref, student: student, name: student.name!, date: date, user: user);
              return Future.value(true);
            } else {
              return Future.value(false);
            }
          }
        else if(info['action']=='newAccess' && user.permissions!['addProfesor']==true){
          String profId = info['profID'];
          final permissions = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PermissionsScreen(),
            ),
          );
          safePrint('Permisos otorgados: $permissions');
          awsDb.giveUserAccess(user.tenant!, jsonEncode(permissions), profId);
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
      final aws = DataStoreReadService();
      final product = await aws.productExists(productCode, user.tenant!.tenant_id);
      if(product != null){
        await showProductInfoDialog(context, product, user);
        return Future.value(true);
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
            content: Text('Producto no encontrado: $productCode'),
            backgroundColor: Colors.red,
            ),);
        return Future.value(false);
        }
  }

  Map<String, dynamic>? decodeInfo(Barcode? data){
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

    final studentsState = ref.watch(studentsAttendanceProvider);
    final userState = ref.watch(userProvider);

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
            user!.permissions!["editPast"] == true ?
            CalendarButton() : SizedBox(),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(left: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              onPressed: (){},
              child: const Icon(Icons.monetization_on_outlined),
            ),
            FloatingActionButton(
              onPressed: () => checkAction(context),
              child: const Icon(Icons.qr_code_scanner_outlined),
            ),
          ],
        ),
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      body: userState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data:
            (user) => studentsState.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
              data: (attendanceModel) {
                final allStudents = attendanceModel.attendanceToday;
                if (attendanceModel.attendanceToday.isEmpty) {
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
                return RefreshIndicator(
                  onRefresh: () async{
                    await ref.read(studentsAttendanceProvider.notifier).setAttendanceToday(
                      ref.read(dateProvider).today);
                  },
                  child: SingleChildScrollView(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: screenHeight * 0.06),
                          Center(
                            child: StudentsNumberHome(studentsNumber: "Asistencias: ${allStudents.length}"),
                          ),
                          SizedBox(height: screenHeight * 0.03),
                          Column(
                            children:
                                allStudents.asMap().entries.map((entry) {
                                  Student student = entry.value.student!;
                                  return Column(
                                    children: [
                                      InkWell(
                                        onTap:(){Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => StudentDetailScreen(
                                                student: student,
                                              ),
                                        ),
                                      );},
                                      child: PreviewStudentContainer(
                                          student: student,
                                          onDismissed: () {
                                            ref
                                                .read(studentsAttendanceProvider.notifier)
                                                .deleteAttendance(
                                                  allStudents.firstWhere((element)=>element.student!.id ==student.id),
                                                  ref.read(dateProvider).today,
                                                );
                                          },
                                        ),
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
                  ),
                );
              },
            ),
      ),
    );
  }
}

