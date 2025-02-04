import 'package:flutter/material.dart';


class MetricsPage extends StatefulWidget {
  final String name;
  
  MetricsPage({required this.name});

  @override
  State<MetricsPage> createState() => _MetricsPageState();
}

class _MetricsPageState extends State<MetricsPage> {
  late String title;

  @override
  void initState(){
    title = widget.name;
  }
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('$title'),
      ),
    );
  }
}