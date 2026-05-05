import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:la_dinamica_app/config/theme/app_theme.dart';

class InfoCard extends StatelessWidget {
  final int id;
  final int clases;
  final TemporalDate payDate;
  final TemporalDate? expiration;
  final String phone;
  final double totalDebt;

  const InfoCard({
    super.key,
    required this.id,
    required this.clases,
    required this.payDate,
    required this.phone,
    required this.totalDebt,
    this.expiration,
  });

  String formatDate(TemporalDate date){
    DateTime datetime = date.getDateTime();
    List<String> months = ["ENE","FEB","MAR","ABR","MAY","JUN","JUL","AGO","SEP","OCT","NOV","DIC"];
    final newString = "${datetime.day}-${months[datetime.month-1]}-${datetime.year}";
    return newString;
  }

  @override
  Widget build(BuildContext context) {
    final expirationDate = expiration!=null ? formatDate(expiration!) : "Desconocido"; 
    return SizedBox(
      width: 500,
      height: 500,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),

        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
               Card(
                elevation: 3,
                color: colorList[2],
                shadowColor: colorList[5],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person),
                      Text(
                          ' ID:   $id',
                          style: GoogleFonts.gochiHand(fontSize: 20, fontWeight: FontWeight.bold)
                        ),
                    ],
                  ),
                ),
              ),
      
            Card(
                elevation: 3,
                color: colorList[2],
                shadowColor: colorList[5],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.class_),
                      Text(' Clases restantes:    $clases',
                      style: GoogleFonts.gochiHand(fontSize: 20, fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
              ),
            Card(
                elevation: 3,
                shadowColor: colorList[5],
                color: colorList[2],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.calendar_today),
                      Text(' Fecha del ultimo pago:  ${formatDate(payDate)}',
                      style: GoogleFonts.gochiHand(fontSize: 20, fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
              ),
            Card(
                elevation: 3,
                shadowColor: colorList[5],
                color: colorList[2],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.calendar_today),
                      Text(' Fecha de expiración:  $expirationDate',
                      style: GoogleFonts.gochiHand(fontSize: 20, fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
              ),
            Card(
                elevation: 3,
                shadowColor: colorList[5],
                color: colorList[2],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.phone),
                      Text(' Telefono:    $phone',
                      style: GoogleFonts.gochiHand(fontSize: 20, fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
              ),
            Card(
                elevation: 3,
                shadowColor: colorList[5],
                color: colorList[2],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.money_off_rounded),
                      Text('Adeudos:    $totalDebt',
                      style: GoogleFonts.gochiHand(fontSize: 20, fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

