import 'dart:convert';
import 'dart:io';

import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/backend/create_credential.dart';
import 'package:la_dinamica_app/backend/database.dart';
import 'package:la_dinamica_app/config/theme/app_theme.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';
import 'package:la_dinamica_app/providers/date_provider.dart';
import 'package:la_dinamica_app/providers/read_queries_aws.dart';
import 'package:la_dinamica_app/providers/user_provider.dart';
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
  Pay paymentData = Pay(
    id: '0',
    user_id: 0,
    amount: 0.0,
    clases: 0,
    type: 'Desconocido',
    date: TemporalDate(DateTime.now()),
  );

  Student studentData = Student(
    id: '0',
    name: 'Desconocido',
    address: 'Desconocido',
    phone: 'Desconocido',
    age: 0,
    image: '',
  );

  bool isActive = true;

  final DatabaseHelper db = DatabaseHelper();
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
    final bool hasAttendance = attendedIds.contains(widget.id);

    return Scaffold(
      appBar: AppBar(title: Text(widget.name)),
      body: FutureBuilder(
        future: awsDb.getLastPayandStudentData(widget.id, ref.read(userProvider)!.db_id!),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.data['lastPay'] != null &&
                snapshot.data['studentData'] != null) {
              paymentData = snapshot.data['lastPay'];
              studentData = snapshot.data['studentData'];
            }

            return infoScreen(
              screenHeight,
              context,
              screenWidth,
              hasAttendance,
            );
          }
        },
      ),
    );
  }

  Widget infoScreen(
    double screenHeight,
    BuildContext context,
    double screenWidth,
    bool hasAttendance,
  ) {
    isActive = paymentData.clases != 0;
    final String date = ref.watch(dateProvider);

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
                              jsonDecode(widget.image)['imageUrl'],
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
                    onPressed: () async {
                      await db.insertAttendanceData(
                        widget.id,
                        widget.name,
                        date,
                      );
                      await db.varifyPay(widget.id, date);
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
                      backgroundColor: WidgetStateProperty.all(colorList[2]),
                    ),
                    child: const Text(
                      'Marcar Asistencia',
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
                                image: widget.image,
                              ),
                        ),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(colorList[3]),
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Clases faltantes: ${paymentData.clases}'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('ID: ${widget.id}'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Fecha del ultimo pago: ${paymentData.date}'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Telefono: ${studentData.phone}'),
                ),
                ElevatedButton(
                  onPressed: () {
                    generateCredentialandSend(
                      widget.id,
                      widget.name,
                      studentData.address!,
                      studentData.phone!,
                      studentData.age.toString(),
                      widget.image,
                    );
                  },
                  child: const Text('Generar Credencial'),
                ),
                ElevatedButton(
                  onPressed: () {
                    db.deleteStudentPlan(widget.id, date);
                  },
                  child: const Text('Eliminar Plan'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
