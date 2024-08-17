import 'package:flutter/material.dart';
import 'package:la_dinamica_app/config/theme/app_theme.dart';

class SearchStudentContainer extends StatelessWidget {
  final String circleText;

  const SearchStudentContainer({super.key, required this.circleText});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      height: screenHeight * 0.18,
      width: double.infinity,
      decoration: BoxDecoration(color: colorList[8]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 2,
                color: colorList[4],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                circleText,
                style: TextStyle(
                    color: colorList[4],
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: TextField(
                decoration: InputDecoration(
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: colorList[7]),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                  fillColor: colorList[7],
                  filled: true,
                  hintText: 'Nombre',
                  hintStyle: const TextStyle(fontSize: 18),
                  suffixIcon: const Icon(Icons.search),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0, // Centra el texto verticalmente
                    horizontal: 50.0, // Centra el texto horizontalmente
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: colorList[
                            0]), // Mantiene o cambia el mismo color al enfocarse
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: colorList[
                            7]), // Color del borde cuando no está enfocado
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
