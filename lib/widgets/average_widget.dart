import 'package:flutter/material.dart';
import 'package:la_dinamica_app/config/theme/app_theme.dart';

class AverageWidget extends StatelessWidget {
  final String average;
  final String title1;
  final String title2;

  const AverageWidget({
    super.key,
    required this.average,
    required this.title1,
    required this.title2,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 50,
        width: 350,
        decoration: BoxDecoration(
          color: colorList[2],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          const Icon(Icons.analytics_outlined, color: Colors.white, size: 30),
          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [ 
            Text(title1, style: const TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.normal,)),
            Text(title2, style: const TextStyle(color: Colors.white,fontSize: 10,fontWeight: FontWeight.normal,)),
          ]),
          const SizedBox(width: 30),
          Text(average, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold,)),
        ],),
      ),
    );
  }
}