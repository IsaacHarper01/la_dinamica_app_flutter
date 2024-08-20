import 'package:flutter/material.dart';

class PreviewStudentContainer extends StatelessWidget {
  final String name;

  const PreviewStudentContainer({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: screenHeight * 0.14,
        width: screenWidth,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    'https://i.pinimg.com/originals/fb/6d/16/fb6d16c4321ab45dad1c6290f2740f7a.jpg',
                    width: screenHeight * 0.11,
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
                    Text(
                      'Clases',
                      style: TextStyle(fontSize: screenHeight * 0.02),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 2,
                              color: Colors.green,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Completas: 12',
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: screenHeight * 0.018,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 2,
                              color: Colors.blue,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Faltantes: 4',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: screenHeight * 0.018,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
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
