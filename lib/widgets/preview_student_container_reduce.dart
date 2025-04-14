import 'dart:io';
import 'package:flutter/material.dart';

class PreviewStudentContainerReduce extends StatelessWidget {
  final String name;
  final int id;
  final String image;
  final Color backgroundColor;
  final Icon? trailingIcon;

  const PreviewStudentContainerReduce(
      {super.key,
      required this.name,
      required this.id,
      required this.image,
      required this.backgroundColor,
      this.trailingIcon});

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
                child: Image.file(
                  File(image),
                  width: screenHeight * 0.06,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        name,
                        style: TextStyle(
                          fontSize: screenHeight * 0.022,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        maxLines: 1,
                      ),
                    ),
                    Text(
                      'ID: $id',
                      style: TextStyle(fontSize: screenHeight * 0.015),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (child, animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: trailingIcon != null
                  ? Padding(
                      key: ValueKey('icon-$id'),
                      padding: const EdgeInsets.only(right: 12.0),
                      child: trailingIcon,
                    )
                  : SizedBox.shrink(key: ValueKey('empty-$id')),
            ),
          ],
        ),
      ),
    );
  }
}
