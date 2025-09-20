import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:la_dinamica_app/providers/exam_provider.dart';
import 'package:la_dinamica_app/providers/image_fromS3_provider.dart';
import 'package:la_dinamica_app/providers/stop_watch_provider.dart';
import 'package:la_dinamica_app/widgets/metrics_screen/circle_total_grade.dart';

class PreviewStudentContainerText extends ConsumerStatefulWidget {
  final String type;
  final String name;
  final int id;
  final String image;
  final Color backgroundColor;
  final TextEditingController controller;

  const PreviewStudentContainerText({
    super.key,
    required this.type,
    required this.name,
    required this.id,
    required this.image,
    required this.backgroundColor,
    required this.controller,
  });

  @override
  ConsumerState<PreviewStudentContainerText> createState() => _PreviewStudentContainerTextState();
}

class _PreviewStudentContainerTextState extends ConsumerState<PreviewStudentContainerText> {
  double base10amount = 0.0;

  @override
  Widget build(BuildContext context) {
    final ref = this.ref;
    final Orientation orientation = MediaQuery
        .of(context)
        .orientation;
    final bool isPortatil = orientation == Orientation.portrait;
    final screenHeight = isPortatil ? MediaQuery.of(context).size.height : MediaQuery.of(context).size.height * 2;
    final screenWidth = MediaQuery.of(context).size.width;
    
    final imageUrl = ref.watch(studentImageProvider(widget.image));
    final state = ref.watch(examProvider);
    final base10Conversion = state.objetives.containsKey(state.actualState) && state.penalties.containsKey(state.actualState);

    final textDecorator = widget.type == "Tiempo"
        ? "Tiempo (s)"
        : "Calificación(0-10)";
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        height: screenHeight * 0.07,
        width: screenWidth,
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // 🔹 Imagen (solo se carga 1 vez y queda en cache)
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: imageUrl.when(
                  data: (url) => Image.network(
                    url ?? "",
                    width: screenHeight * 0.06,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/default_profile.jpg',
                        width: screenHeight * 0.06,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                  loading: () => SizedBox(
                    width: screenHeight * 0.06,
                    height: screenHeight * 0.06,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  error: (_, __) => Image.asset(
                    'assets/images/default_profile.jpg',
                    width: screenHeight * 0.06,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 4.0,
                  horizontal: 8.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        widget.name,
                        style: GoogleFonts.gochiHand(
                          fontSize: screenHeight * 0.03,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        maxLines: 1,
                      ),
                    ),
                    Text(
                      'ID: ${widget.id}',
                      style: GoogleFonts.gochiHand(
                        fontSize: screenHeight * 0.017,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            widget.type == "Tiempo"
                ? Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    onPressed: (){
                      widget.controller.text = ref.read(stopwatchProvider.notifier).currentTime;
                      if (base10Conversion){
                        setState(() {
                          base10amount = ref.read(examProvider.notifier).calculateConversion(widget.controller.text)!;
                        });
                        ref.read(examProvider.notifier).setConversion(studentId: widget.id.toString(), base10: base10amount);
                      }
                    }, 
                    child: Text('Detener',style: GoogleFonts.gochiHand(fontSize: 13),)),)
                : const SizedBox(width: 20),
            Expanded(
              flex: 1,
              child: TextField(
                controller: widget.controller,
                decoration: InputDecoration(labelText: textDecorator,border: OutlineInputBorder(),),
              ),
            ),
            base10Conversion ? Expanded(
              flex: 1,
              child: SizedBox(
                width: 50,
                height: 50,
                child: CustomPaint(
                  painter: CircleTotalGrade(percent: base10amount, strokeWidth: 6),
                  child: Center(
                    child: Text(base10amount.toStringAsFixed(1) , style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                ),
              )
            ) : const SizedBox(width: 5),
          ],
        ),
      ),
    );
  }
}