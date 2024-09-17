import 'package:flutter/material.dart';
import 'package:la_dinamica_app/config/theme/app_theme.dart';
import 'package:la_dinamica_app/backend/database.dart';

class StudentDetailScreen extends StatelessWidget {
  final String name;
  final int id;

  const StudentDetailScreen({super.key, required this.name, required this.id});

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
      body: SingleChildScrollView(
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
                        child: Image.network(
                          'https://i.pinimg.com/originals/fb/6d/16/fb6d16c4321ab45dad1c6290f2740f7a.jpg',
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
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.fmd_good_rounded,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    'Direccion',
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
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.directions_walk_rounded,
                                  color: Colors.white,
                                ),
                                Text(
                                  'Edad',
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
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Tipo de plan',
                    style: TextStyle(fontSize: 25),
                  ),
                  Text('Hombro al fallo')
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
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Clases asistidas: 1'),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Clases faltantes: 9'),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('ID: 21201226410'),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Fecha de registro: 26/10/2222'),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Telefono del tutor: 213246574968'),
                  ),
      
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
