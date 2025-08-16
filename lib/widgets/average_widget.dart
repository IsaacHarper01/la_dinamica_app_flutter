import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
            Text(title1, style: GoogleFonts.gochiHand(fontSize: 16)),
            Text(title2, style: GoogleFonts.gochiHand(fontSize: 10)),
          ]),
          const SizedBox(width: 30),
          Text(average, style: GoogleFonts.gochiHand(color: Colors.white, fontSize: 16)),
        ],),
      ),
    );
  }
}