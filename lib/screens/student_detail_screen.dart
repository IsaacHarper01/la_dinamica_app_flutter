import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/backend/create_credential.dart';
import 'package:la_dinamica_app/backend/database.dart';
import 'package:la_dinamica_app/config/theme/app_theme.dart';
import 'package:la_dinamica_app/screens/metrics_screen.dart';

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
  Map<String, dynamic> paymentData = {
    'id': 0,
    'userId': 0,
    'amount': 0,
    'clases': 0,
    'type': 'Desconocido',
    'date': '-'
  };

  Map<String, dynamic> studentData = {};
  bool isActive = true;

  final DatabaseHelper db = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    final bool isPortatil = orientation == Orientation.portrait;
    final screenHeight = isPortatil
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.height * 2;
    final screenWidth = isPortatil
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.width * 0.8;

    final attendedIds = ref.watch(attendedIdsProvider);
    final bool hasAttendance = attendedIds.contains(widget.id);

    return Scaffold(
        appBar: AppBar(title: Text(widget.name)),
        body: FutureBuilder(
            future: db.fetchLastPayandStudentlData(widget.id),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                if (snapshot.data['lastPay'].isNotEmpty) {
                  paymentData = snapshot.data['lastPay'];
                }
                studentData = snapshot.data['studentData'];
                return infoScreen(
                    screenHeight, context, screenWidth, hasAttendance);
              }
            }));
  }

  Widget infoScreen(double screenHeight, BuildContext context,
      double screenWidth, bool hasAttendance) {
    isActive = paymentData['clases'] != 0;

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
                    child: Image.file(
                      File(widget.image),
                      width: double.infinity,
                      fit: BoxFit.cover,
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
                      style: TextStyle(fontSize: screenHeight * 0.05),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
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
                                  '${studentData['address']}',
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
                                '${studentData['age']} años',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FilledButton(
                    onPressed: () async {
                      await db.InserAttendanceData(widget.id, widget.name);
                      await db.varifyPay(widget.id);
                      setState(() {
                        hasAttendance = true;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Asistencia Registrada'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(colorList[2])),
                    child: const Text('Marcar Asistencia')),
                FilledButton(
                    onPressed: () {},
                    style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(colorList[4])),
                    child: const Text('Pagos')),
                FilledButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MetricsPage(
                                  name: widget.name,
                                  image: widget.image,
                                )));
                  },
                  style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(colorList[3])),
                  child: const Text('Metricas'),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Tipo de plan',
                  style: TextStyle(fontSize: 25),
                ),
                Text('${paymentData['type']}')
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
                          bottomLeft: Radius.circular(10))),
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
                          bottomRight: Radius.circular(10))),
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Clases faltantes: ${paymentData['clases']}'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('ID: ${widget.id}'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Fecha del ultimo pago: ${paymentData['date']}'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Telefono: ${studentData['phone']}'),
                ),
                ElevatedButton(
                    onPressed: () {
                      generateCredentialandSend(
                          widget.id,
                          widget.name,
                          studentData['address'],
                          studentData['phone'],
                          studentData['age'],
                          widget.image);
                    },
                    child: Text('Generar Credencial')),
                ElevatedButton(
                    onPressed: () {
                      db.deleteStudentPlan(widget.id);
                    },
                    child: Text('Eliminar Plan'))
              ],
            ),
          )
        ],
      ),
    );
  }
}
