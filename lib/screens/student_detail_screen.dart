import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/backend/create_credential.dart';
import 'package:la_dinamica_app/backend/database.dart';
import 'package:la_dinamica_app/config/theme/app_theme.dart';
import 'package:la_dinamica_app/model/UserLocal.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';
import 'package:la_dinamica_app/providers/date_provider.dart';
import 'package:la_dinamica_app/providers/delete_queries_aws.dart';
import 'package:la_dinamica_app/providers/read_queries_aws.dart';
import 'package:la_dinamica_app/providers/user_provider.dart';
import 'package:la_dinamica_app/screens/metrics_screen.dart';
import 'package:la_dinamica_app/widgets/student_info_profile.dart';

import '../providers/attendance_provider.dart';

// ignore: must_be_immutable
class StudentDetailScreen extends ConsumerStatefulWidget {
  final String name;
  final int id;
  final String image;

  const StudentDetailScreen({
    super.key,
    required this.name,
    required this.id,
    required this.image,
  });

  @override
  ConsumerState<StudentDetailScreen> createState() =>
      _StudentDetailScreenState();
}

class _StudentDetailScreenState extends ConsumerState<StudentDetailScreen> {
  Pay paymentData = Pay(
    id: '0',
    user_id: 0,
    amount: 0.0,
    clases: 0,
    type: 'Desconocido',
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

  final DatabaseHelper db = DatabaseHelper();
  final awsDb = DataStoreReadService();
  final awsDelete = DataStoreDeleteService();

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
    final bool hasAttendance = attendedIds.contains(widget.id);
    final userAsync = ref.watch(userProvider);

    return userAsync.when(
      loading: () => Scaffold(body: Center(child: CircularProgressIndicator(),),),
      error: (error, stackTrace) => Scaffold(body: Center(child: Text("Error al cargar Usuario $error"),),),
      data: (userAsync) => Scaffold(
      appBar: AppBar(title: Text(widget.name)),
      body: FutureBuilder(
        future: awsDb.getLastPayandStudentData(widget.id, userAsync.tenantId),
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
    isActive = paymentData.clases != 0;
    final String date = ref.watch(dateProvider);
    final tenantId = user.tenantId;

    void handleDeleteDash(context, id) async {
    // Mostrar un cuadro de diálogo para confirmar la eliminación
    bool? shouldDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
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
        );
      },
    );

    // Si el usuario confirma, eliminar el registro
    if (shouldDelete == true) {
      awsDelete.deleteStudentByID(id, tenantId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registro Eliminado'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context); // Volver a la pantalla anterior
    }
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
                    child:
                            Image.network(
                              studentData.image!,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const Center(child: CircularProgressIndicator());
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/images/default_profile.jpg',
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                  ),
                ),
              ),
              if (hasAttendance)
                Positioned(
                  bottom: 12,
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.name,
                      style: TextStyle(fontSize: screenHeight * 0.04),
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
                                  '${studentData.address}',
                                  style: const TextStyle(color: Colors.white),
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
                                '${studentData.age} años',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
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
                      handleDeleteDash(context, widget.id);
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
                    onPressed: () {},
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
                                name: widget.name,
                                image: studentData.image!,
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
                const Text('Tipo de plan', style: TextStyle(fontSize: 25)),
                Text('${paymentData.type}'),
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
                InfoCard(id: widget.id, clases: paymentData.clases!, payDate: paymentData.date.toString(), phone: studentData.phone!),
                const SizedBox(height: 10),
                FilledButton.icon(
                  onPressed: () {
                    generateCredentialandSend(
                      widget.id,
                      widget.name,
                      studentData.address!,
                      studentData.phone!,
                      studentData.age.toString(),
                      widget.image,
                      tenantId,
                    );
                  },
                  label: const Text('Generar Credencial'),
                  style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(colorList[4]),
                    ),
                ),
                FilledButton.icon(
                  onPressed: () {
                    db.deleteStudentPlan(widget.id, date);
                  },
                  label: const Text('Eliminar Plan'),
                  style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(colorList[4]),
                    ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
