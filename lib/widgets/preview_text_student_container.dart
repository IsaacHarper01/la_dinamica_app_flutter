import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:la_dinamica_app/providers/storageS3.dart';

class PreviewStudentContainerText extends StatelessWidget {
  final String type;
  final String name;
  final int id;
  final String image;
  final Color backgroundColor;

  const PreviewStudentContainerText({
    super.key,
    required this.type,
    required this.name,
    required this.id,
    required this.image,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery
        .of(context)
        .orientation;
    final bool isPortatil = orientation == Orientation.portrait;
    final screenHeight =
    isPortatil
        ? MediaQuery
        .of(context)
        .size
        .height
        : MediaQuery
        .of(context)
        .size
        .height * 2;
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final awsS3 = Storages3();
    final TextEditingController _controller = TextEditingController();

    return FutureBuilder<String?>(
      future: awsS3.getImageUrl(image),
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        final imageUrl = snapshot.data ?? "";
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
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child:
                    Image.network(
                        imageUrl,
                        width: screenHeight * 0.06,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(child: CircularProgressIndicator());
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/images/default_profile.jpg',
                            width: screenHeight * 0.06,
                            fit: BoxFit.cover,
                          );
                        },
                      )
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
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(labelText: textDecorator,border: OutlineInputBorder(),),
                  ),
                )
              ],
              
            ),
          ),
        );
      },
    );
  }
}
