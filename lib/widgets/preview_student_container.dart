import 'dart:io';
import 'package:flutter/material.dart';

class PreviewStudentContainer extends StatelessWidget {
  final String name;
  final String image;
  final Function()? onDismissed;

  const PreviewStudentContainer({
    super.key,
    required this.name,
    required this.image,
    this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    final bool isPortatil = orientation == Orientation.portrait;
    final screenHeight = isPortatil
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.height * 2;
    final screenWidth = MediaQuery.of(context).size.width;

    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        return await _showDeleteConfirmationDialog(context);
      },
      child: Padding(
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
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
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
      ),
    );
  }

  Future<bool> _showDeleteConfirmationDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('¿Eliminar asistencia?'),
          content: const Text(
              '¿Estás seguro de que deseas eliminar esta asistencia?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (onDismissed != null) {
                  onDismissed!();
                }
                Navigator.of(context).pop(true);
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
    return confirmed ?? false;
  }
}
