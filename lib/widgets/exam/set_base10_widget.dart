import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:la_dinamica_app/config/theme/app_theme.dart';
import 'package:la_dinamica_app/providers/exam_provider.dart';
import 'package:la_dinamica_app/providers/stop_watch_provider.dart';

class SetBase10Widget extends ConsumerStatefulWidget {
  final screenWidth;
  const SetBase10Widget({super.key, required this.screenWidth});

  @override
  ConsumerState<SetBase10Widget> createState() => _SetBase10WidgetState();
}

class _SetBase10WidgetState extends ConsumerState<SetBase10Widget> {
  bool isMinor = false;
  final objetiveController = TextEditingController();
  final penaltyController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    
    return Container(
      width: widget.screenWidth,
      decoration: BoxDecoration(
        color: colorList[3],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text('Opcional', style: GoogleFonts.gochiHand()),
          Text(
          """Puedes establecar un objetivo para poder calificar esta metrica en base 10, si bien esto es opcional al agregarlo la calificacion obtenida en base 10 se suma al total y se promedia con las demas metricas.""", 
          style: GoogleFonts.gochiHand()),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 1,
                  child: Text("Objetivo:", style: GoogleFonts.gochiHand())),
                Flexible(
                  flex: 1,
                  child: Checkbox(
                    value: isMinor, 
                    onChanged: (bool? value) {
                      setState(() {
                        isMinor = value ?? false;
                      });
                    },
                    activeColor: Colors.blue,
                    checkColor: Colors.white,
                    ),
                ),
                Flexible(
                  flex: 1,
                  child: Text(isMinor ? "Menor o igual que ->" : "Mayor o igual que ->", style: GoogleFonts.gochiHand())),
                SizedBox(width: 5),
                Flexible(
                  flex: 2,
                  child: TextField(
                    controller: objetiveController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: ref.read(stopwatchProvider).toString(),
                      labelStyle: GoogleFonts.gochiHand(),
                    ),
                    style: GoogleFonts.gochiHand(),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: ElevatedButton(
                  onPressed: (){
                    if (isMinor) {
                      ref.read(examProvider.notifier).setObjetives(
                        {ref.read(examProvider).actualState:"<${objetiveController.text}"}
                      );
                    } else {
                      ref.read(examProvider.notifier).setObjetives(
                        {ref.read(examProvider).actualState:">${objetiveController.text}"}
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorList[2]
                  ),  
                  child: Text("Guardar", style: GoogleFonts.gochiHand(),),
                  )
                )
              ],
            ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 2,
                  child: Text("reducir 1 punto por cada:    ", style: GoogleFonts.gochiHand())),
                SizedBox(width: 10,),
                Flexible(
                  flex: 1,
                  child: TextField(
                    controller: penaltyController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "00:05:00.00",
                      labelStyle: GoogleFonts.gochiHand(),
                    ),
                    style: GoogleFonts.gochiHand(),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: ElevatedButton(
                  onPressed: (){
                    ref.read(examProvider.notifier).setPenalties(
                        {ref.read(examProvider).actualState:penaltyController.text}
                      );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorList[2]
                  ), 
                  child: Text("Guardar", style: GoogleFonts.gochiHand(),),
                  )
                )
              ],
            ),
        ],
      )
    );
  }
}