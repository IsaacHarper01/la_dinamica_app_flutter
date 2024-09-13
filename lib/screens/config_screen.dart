import 'package:flutter/material.dart';
import 'package:la_dinamica_app/config/theme/app_theme.dart';
import 'package:la_dinamica_app/backend/database.dart';
import 'package:la_dinamica_app/screens/add_new_plan.dart';

class ConfigScreen extends StatelessWidget {
  const ConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    final bool isPortatil = orientation == Orientation.portrait;
    final screenWidth = isPortatil
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.width * 0.8;
    final db = DatabaseHelper();
    

    return Scaffold(
      
      body: FutureBuilder(
        future: db.fetchPlansData(), 
        builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
            List<List<String>> planes=[];
            for (var item in snapshot.data) {
              planes.add([item['type'],item['clases'].toString(),item['price'].toString()]);
            }  
            return box_plans(screenWidth, context, planes);
            }
            }
              ),
    );
  }

  Center box_plans(double screenWidth, BuildContext context, List<List<String>> planes) {
    return Center(
        child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 20),
        child: Container(
          width: screenWidth * 0.9,
          decoration: BoxDecoration(
              color: colorList[1], borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Configuraciones de planes',
                      style: TextStyle(
                          fontSize: screenWidth * 0.06, color: Colors.white),
                    )
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FilledButton(
                        style: ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(colorList[3])),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AddNewPlan(),
                              ));
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.add_circle_outlined),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Agregar nuevo plan',
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        )),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  children: planes.map((item) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: item.map((subitem) {
                            return Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  subitem,
                                  style:
                                      TextStyle(fontSize: screenWidth * 0.04),
                                ),
                              ),
                            );
                          }).toList()),
                    );
                  }).toList(),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
              
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}


