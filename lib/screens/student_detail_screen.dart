import 'package:flutter/material.dart';
import 'package:la_dinamica_app/config/theme/app_theme.dart';

class StudentDetailScreen extends StatelessWidget {
  final String name;

  const StudentDetailScreen({super.key, required this.name});

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
                  Text(
                    'Total de clases: 10',
                    style: TextStyle(fontSize: 20),
                  ),
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
                    child: Text('Nombre del tutor: Shrek'),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Telefono del tutor: 213246574968'),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Telefono secundario: 52456432125'),
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
