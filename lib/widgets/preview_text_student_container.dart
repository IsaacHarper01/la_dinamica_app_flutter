import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:la_dinamica_app/providers/image_fromS3_provider.dart';
import 'package:la_dinamica_app/providers/stop_watch_provider.dart';

class PreviewStudentContainerText extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final Orientation orientation = MediaQuery
        .of(context)
        .orientation;
    final bool isPortatil = orientation == Orientation.portrait;
    final screenHeight = isPortatil ? MediaQuery.of(context).size.height : MediaQuery.of(context).size.height * 2;
    final screenWidth = MediaQuery.of(context).size.width;
    
    final imageUrl = ref.watch(studentImageProvider(image));
    
    final textDecorator = type == "Tiempo"
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
          color: backgroundColor,
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
                        name,
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
                      'ID: $id',
                      style: GoogleFonts.gochiHand(
                        fontSize: screenHeight * 0.017,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            type == "Tiempo"
                ? Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    onPressed: (){
                      controller.text = ref.read(stopwatchProvider.notifier).currentTime;
                    }, 
                    child: Text('Detener',style: GoogleFonts.gochiHand(fontSize: 13),)),)
                : const SizedBox(width: 20),
            Expanded(
              flex: 1,
              child: TextField(
                controller: controller,
                decoration: InputDecoration(labelText: textDecorator,border: OutlineInputBorder(),),
              ),
            )
          ],
          
        ),
      ),
    );
  }
}
