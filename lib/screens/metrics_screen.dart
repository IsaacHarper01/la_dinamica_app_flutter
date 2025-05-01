import 'dart:io';

import 'package:flutter/material.dart';
import 'package:la_dinamica_app/widgets/calendar_widget.dart';
import 'package:time_range_picker/time_range_picker.dart';


class MetricsPage extends StatefulWidget {
  final String name;
  final String image;

  const MetricsPage({super.key, required this.name, required this.image});

  @override
  State<MetricsPage> createState() => _MetricsPageState();
}

class _MetricsPageState extends State<MetricsPage> {
  late String title;
  late String photo;
  

  @override
  void initState(){
    super.initState();
    title = widget.name;
    photo = widget.image;
  }
  
  @override
  Widget build(BuildContext context){
    DateTime? selectedDate;
    TimeRange? selectedRange;
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text('$title')),
        ),
        backgroundColor: Color.fromRGBO(204, 208, 207, 1.0),
        body: ListView(
          children: [
            Container( //Student photo and Calendar Cointainer
              height: 400,
              color: Color.fromRGBO(6, 20, 27, 1.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    height: 350,
                    width: 200,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                        child: Opacity(
                          opacity: 0.7,
                          child: Image.file(
                            File(widget.image),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                  ),
                  Container(
                    height: 350,
                    width: 400,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(74, 92, 106, 1.0),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: SingleChildScrollView(
                        child: SizedBox(
                          child: CalendarTimeRangePicker(
                            onSelectionChanged: (date, range) {
                              setState(() {
                                selectedDate = date;
                                selectedRange = range;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 400,
              color: Color.fromRGBO(17, 33, 45, 1.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    height: 280,
                    width: 300,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(74, 92, 106, 1.0),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  Container(
                    height: 280,
                    width: 330,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(74, 92, 106, 1.0),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 400,
              color: Color.fromRGBO(35, 55, 69, 1.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    height: 350,
                    width: 620,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(74, 92, 106, 1.0),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
  }
}