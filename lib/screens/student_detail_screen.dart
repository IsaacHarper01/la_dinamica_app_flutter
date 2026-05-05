import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:la_dinamica_app/backend/create_credential.dart';
import 'package:la_dinamica_app/backend/image_capture.dart';
import 'package:la_dinamica_app/config/theme/app_theme.dart';
import 'package:la_dinamica_app/model/UserLocal.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';
import 'package:la_dinamica_app/providers/all_students_provider.dart';
import 'package:la_dinamica_app/providers/image_fromS3_provider.dart';
import 'package:la_dinamica_app/providers/read_queries_aws.dart';
import 'package:la_dinamica_app/providers/user_provider.dart';
import 'package:la_dinamica_app/screens/add_student_screen.dart';
import 'package:la_dinamica_app/screens/editPayments_screen.dart';
import 'package:la_dinamica_app/screens/metrics_screen.dart';
import 'package:la_dinamica_app/widgets/student_info_profile.dart';

import '../providers/attendance_provider.dart';

// ignore: must_be_immutable
class StudentDetailScreen extends ConsumerStatefulWidget {
  final Student student;

  const StudentDetailScreen({
    super.key,
    required this.student,
  });

  @override
  ConsumerState<StudentDetailScreen> createState() =>
      _StudentDetailScreenState();
}

class _StudentDetailScreenState extends ConsumerState<StudentDetailScreen> {
  Payment paymentData = Payment(
    id: '0',
    user_id: 0,
    amount: 0.0,
    clases: 0,
    plan: LocalPlan(),
    date: TemporalDate(DateTime.now()),
    client_id: '',
    prof_id: '',
  );

  Student studentData = Student(
    id: '0',
    name: 'Desconocido',
    address: 'Desconocido',
    phone: 'Desconocido',
    age: 0,
    image: 'assets/images/default_profile.jpg',
  );

  bool isActive = true;
  List<Payment>? debts;

  final awsDb = DataStoreReadService();

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    final bool isPortatil = orientation == Orientation.portrait;
    final screenHeight =
        isPortatil
            ? MediaQuery.of(context).size.height
            : MediaQuery.of(context).size.height * 2;
    final screenWidth =
        isPortatil
            ? MediaQuery.of(context).size.width
            : MediaQuery.of(context).size.width * 0.8;

    final attendedIds = ref.watch(attendedIdsProvider);
    final bool hasAttendance = attendedIds.any((attendant)=> attendant.student!.id == widget.student.id);
    final userAsync = ref.watch(userProvider);

    return userAsync.when(
      loading: () => Scaffold(body: Center(child: CircularProgressIndicator(),),),
      error: (error, stackTrace) => Scaffold(body: Center(child: Text("Error al cargar Usuario $error"),),),
      data: (userAsync) => Scaffold(
      appBar: AppBar(title: Text(widget.student.name!)),
      body: FutureBuilder(
        future: awsDb.getLastPayandStudentData(widget.student.user_id!, userAsync.tenant.tenant_id),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.data['studentData'] != null) {
              studentData = snapshot.data['studentData'];
            }
            if (snapshot.data['lastPay'] != null){
              paymentData = snapshot.data['lastPay'];
            }
            if(snapshot.data['debts'] != null){
              debts = snapshot.data['debts'];
            }
            
            return infoScreen(
              screenHeight,
              context,
              screenWidth,
              hasAttendance,
              userAsync
            );
          }
        },
      ),
      ) 
    );
  }

  Widget infoScreen(
    double screenHeight,
    BuildContext context,
    double screenWidth,
    bool hasAttendance,
    UserLocal user,
  ) {
    isActive = studentData.remainClasses != 0;
    final student = widget.student;
    final tenantId = user.tenant.tenant_id;
    final imageUrl = ref.watch(imageProvider(studentData.image!));

    void handleDeleteDash(context, id, bool permision) async {
    bool? shouldDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return 
        permision ?
        AlertDialog(
          title: const Text('Confirmar Eliminación'),
          content: const Text(
            '¿Estás seguro de que quieres eliminar a este alumno?',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(false); // Retornar false si cancela
              },
            ),
            TextButton(
              child: const Text('Eliminar'),
              onPressed: () {
                Navigator.of(context).pop(true); // Retornar true si confirma
              },
            ),
          ],
        ): AlertDialog(
          title: const Text('Permiso Denegado'),
          content: const Text(
            'No tienes permiso para eliminar a este alumno. Contacta al administrador.',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop(false); // Retornar false al cerrar
              },
            ),
          ],
        );
      },
    );

    // Si el usuario confirma, eliminar el registro
    if (shouldDelete == true) {
      await ref.read(studentsProvider.notifier).deleteStudent(student);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registro Eliminado'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context); // Volver a la pantalla anterior
    }
  }

  double calculateTotalDebt(){
    var total = 0.0;
    if(debts != null){
      for(var debt in debts!){
        total += debt.amount!;
      }
    }
    return total;
  }

    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [
              SizedBox(
                height: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Opacity(
                    opacity: 0.5,
                    child: imageUrl.when(
                      data: (url) => Image.network(
                        url ?? "",
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/images/default_profile.jpg',
                            width: double.infinity,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                      loading: () => SizedBox(
                        width: screenHeight * 0.06,
                        height: screenHeight * 0.06,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      error: (_, __) => Image.asset(
                        'assets/images/default_profile.jpg',
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              if (hasAttendance)
                Positioned(
                  top: 12,
                  right: 12,
                  child: AnimatedScale(
                    scale: 1.0,
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(6),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(onPressed:()async{
                    await pickAndSaveImage(student.image!, tenantId, true, false).then((newPath) {
                            if (newPath != null) {
                              setState(() {
                                studentData = studentData.copyWith(image: newPath);
                              });
                            }
                          });
                  }, 
                  icon: Icon(Icons.camera_alt_rounded),
                  style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(colorList[1]),
                          shape: WidgetStateProperty.all(const CircleBorder()),
                          )
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      student.name!,
                      style: GoogleFonts.gochiHand(
                        fontSize: screenHeight * 0.05,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  Row(
                    children: [
                       Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: colorList[1],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.fmd_good_rounded,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    '${student.address}',
                                    style: GoogleFonts.gochiHand(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: colorList[1],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.directions_walk_rounded,
                                  color: Colors.white,
                                ),
                                Text(
                                  '${student.age} años',
                                  style: GoogleFonts.gochiHand(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      Expanded(
                        flex: 6,
                        child: SizedBox()),
                      Expanded(child: IconButton(
                        onPressed: () async{
                          Navigator.push(context, 
                          MaterialPageRoute(builder: (builder) => AddStudentScreen(edit: true,student: student)));
                        },
                        icon: const Icon(Icons.edit, color: Colors.white,),
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(colorList[1]),
                          shape: WidgetStateProperty.all(const CircleBorder()),
                          )
                        )
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              spacing: 8,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: (){
                      handleDeleteDash(context, student.user_id, user.permissions['deleteStudents'] ?? false);
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(colorList[4]),
                    ),
                    child: const Text(
                      'Eliminar Registro',
                      textAlign: TextAlign.center,
                    ),
                    
                  ),
                ),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => EditpaymentsScreen(
                                student: student,
                                user: user,
                              ),
                        ),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(colorList[4]),
                    ),
                    child: const Text('Pagos'),
                  ),
                ),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => MetricsPage(
                                student: student,
                                name: student.name!,
                                image: student.image!,
                              ),
                        ),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(colorList[4]),
                    ),
                    label: const Text(
                      'Metricas',
                      maxLines: 1,
                      overflow: TextOverflow.visible,
                    ),
                    icon: const Icon(Icons.bar_chart_outlined),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Tipo de plan', style: GoogleFonts.gochiHand(fontSize: 30, fontWeight: FontWeight.bold)),
                Text(paymentData.plan!.type ?? "Sin Plan", style: GoogleFonts.gochiHand(fontSize: 20)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: screenWidth / 2.8,
                  decoration: BoxDecoration(
                    color: isActive ? Colors.green : Colors.transparent,
                    border: Border.all(width: 1),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Activo'),
                    ),
                  ),
                ),
                Container(
                  width: screenWidth / 2.8,
                  decoration: BoxDecoration(
                    color: !isActive ? Colors.red : Colors.transparent,
                    border: Border.all(width: 1),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Desactivado'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InfoCard(
                  id: student.user_id!, 
                  clases: student.remainClasses ?? 0, 
                  payDate: paymentData.date!, 
                  phone: student.phone!,
                  expiration: student.expirationPlan, 
                  totalDebt: calculateTotalDebt()),
                const SizedBox(height: 10),
                FilledButton.icon(
                  onPressed: () {
                    generateCredentialandSend(
                      student.user_id!,
                      student.name!,
                      student.address!,
                      student.phone!,
                      student.age.toString(),
                      student.image!,
                      tenantId,
                    );
                  },
                  label: const Text('Generar Credencial'),
                  style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(colorList[4]),
                    ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
