import 'dart:io';
import 'package:flutter/material.dart';

class PreviewStudentContainer extends StatelessWidget {
  final String name;
  final String image;

  const PreviewStudentContainer({super.key, required this.name, required this.image});

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    final bool isPortatil = orientation == Orientation.portrait;
    final screenHeight = isPortatil
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.height * 2;
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: screenHeight * 0.11,
        width: screenWidth,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.file(
                    File(image),
                    width: screenHeight * 0.08,
                    fit: BoxFit.cover,
                  )),
            ),
            Expanded(
              // Usa Expanded para que el contenido del Column se ajuste al espacio disponible
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      // Envuelve el Text en un Flexible para evitar el desbordamiento
                      child: Text(
                        name,
                        style: TextStyle(
                            fontSize: screenHeight * 0.025,
                            fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
