import 'dart:io';
import 'package:flutter/material.dart';
import 'package:la_dinamica_app/config/theme/app_theme.dart';
import 'package:la_dinamica_app/backend/database.dart';

// ignore: must_be_immutable
class StudentDetailScreen extends StatelessWidget {
  final String name;
  final int id;
  final String image;

  StudentDetailScreen({super.key, required this.name, required this.id, required this.image});
  
  Map<String, dynamic> paymentData={'id':0,'userId':0,'amount':0,'clases':0,'type':'Desconocido','date':'-'};
  Map<String,dynamic> studentData={};

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
    bool isActive = true;
    DatabaseHelper db = DatabaseHelper();

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: FutureBuilder(
        future: db.fetchLastPayandStudentlData(id), 
        builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
                if(snapshot.data['lastPay'].isNotEmpty){
                  paymentData = snapshot.data['lastPay'];
                }
                studentData = snapshot.data['studentData'];
                return info_screen(screenHeight, db, context, screenWidth, isActive, paymentData, studentData);
            }}
            ) 
      
    );
  }

  SingleChildScrollView info_screen(
    double screenHeight,
    DatabaseHelper db,
    BuildContext context,
    double screenWidth,
    bool isActive,
    Map<String,dynamic>paymentData,
    Map<String,dynamic> studentData){
    if (paymentData['clases']==0){
      isActive=false;
    }else{isActive=true;}
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
                        File(image),
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    )),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      name,
                      style: TextStyle(
                        fontSize: screenHeight * 0.05,
                      ),
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
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.fmd_good_rounded,
                                  color: Colors.white,
                                ),
                                Text(
                                  '${studentData['address']}',
                                  style: TextStyle(color: Colors.white),
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
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.directions_walk_rounded,
                                color: Colors.white,
                              ),
                              Text(
                                '${studentData['age']} años',
                                style: TextStyle(color: Colors.white),
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
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FilledButton(
                    onPressed: () async {
                      await db.InserAttendanceData(id, name);
                      await db.varifyPay(id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Asistencia Registrada'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(colorList[2])),
                    child: const Text('Marcar Asistencia')),
                FilledButton(
                    onPressed: () {},
                    style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(colorList[4])),
                    child: const Text('Pagos')),
                FilledButton(
                  onPressed: () {},
                  style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(colorList[3])),
                  child: const Text('Metricas'),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
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
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Clases faltantes: ${paymentData['clases']}'),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('ID: $id'),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Fecha del ultimo pago: ${paymentData['date']}'),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Telefono: ${studentData['phone']}'),
                ),
    
              ],
            ),
          )
        ],
      ),
    );
  }
}
