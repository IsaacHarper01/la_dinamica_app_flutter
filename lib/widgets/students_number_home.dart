import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:la_dinamica_app/config/theme/app_theme.dart';

class StudentsNumberHome extends StatefulWidget {
  final String studentsNumber; 

  const StudentsNumberHome({
    super.key,
    required this.studentsNumber
    });

  @override
  State<StudentsNumberHome> createState() => _StudentNumberState();
}

class _StudentNumberState extends State<StudentsNumberHome> {
  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    final bool isPortrait = orientation == Orientation.portrait;
    final screenWidth = isPortrait ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.width * 1.2;
    return Container(
      width: screenWidth*0.34,
      height: screenWidth*0.08,
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: colorList[4],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: 
          Text(
            widget.studentsNumber,
            style: GoogleFonts.gochiHand(fontSize: screenWidth*0.03),
            ),
      ),

    );
  }
}
