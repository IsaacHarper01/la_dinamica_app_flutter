import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:la_dinamica_app/config/theme/app_theme.dart';
import 'package:la_dinamica_app/providers/exam_provider.dart';
import 'package:la_dinamica_app/providers/stop_watch_provider.dart';

class SetBase10Widget extends ConsumerStatefulWidget {
  const SetBase10Widget({super.key});

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
      height: 180,
      width: 630,
      decoration: BoxDecoration(
        color: colorList[3],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text('Opcional', style: GoogleFonts.gochiHand(fontSize: 20)),
          Text(
          """Puedes establecar un objetivo para poder calificar esta metrica en base 10, si bien esto es opcional al agregarlo la calificacion obtenida en base 10 se suma al total""", 
          style: GoogleFonts.gochiHand(fontSize: 10)),
          Row(
            children: [
              Text("Objetivo:", style: GoogleFonts.gochiHand(fontSize: 20)),
              Checkbox(
                value: isMinor, 
                onChanged: (bool? value) {
                  setState(() {
                    isMinor = value ?? false;
                  });
                },
                activeColor: Colors.blue,
                checkColor: Colors.white,
                ),
              Text(isMinor ? "Menor o igual que ->" : "Mayor o igual que ->", style: GoogleFonts.gochiHand(fontSize: 20)),
              SizedBox(width: 10,),
              Expanded(
                flex: 1,
                child: TextField(
                  controller: objetiveController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: ref.read(stopwatchProvider).toString(),
                    labelStyle: GoogleFonts.gochiHand(fontSize: 15),
                  ),
                  style: GoogleFonts.gochiHand(fontSize: 15),
                ),
              ),
              Expanded(child: ElevatedButton(
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
                child: Text("Guardar", style: GoogleFonts.gochiHand(fontSize: 15),),
                )
              )
            ],
          ),
          Row(
            children: [
              Text("        reducir 1 punto por cada:       ", style: GoogleFonts.gochiHand(fontSize: 20)),
              SizedBox(width: 10,),
              Expanded(
                flex: 1,
                child: TextField(
                  controller: penaltyController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "00:05:00.00",
                    labelStyle: GoogleFonts.gochiHand(fontSize: 15),
                  ),
                  style: GoogleFonts.gochiHand(fontSize: 15),
                ),
              ),
              Expanded(
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
                child: Text("Guardar", style: GoogleFonts.gochiHand(fontSize: 15),),
                )
              )
            ],
          )
        ],
      )
    );
  }
}