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
    final Orientation orientation = MediaQuery.of(context).orientation;
    final bool isPortatil = orientation == Orientation.portrait;
    final screenWidth = isPortatil ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.width * 0.8;
    
    return Center(
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: colorList[2],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          const Icon(Icons.analytics_outlined, color: Colors.white),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [ 
            Text(title1, style: GoogleFonts.gochiHand()),
            Text(title2, style: GoogleFonts.gochiHand()),
          ]),
          Text(average, style: GoogleFonts.gochiHand(color: Colors.white)),
        ],),
      ),
    );
  }
}