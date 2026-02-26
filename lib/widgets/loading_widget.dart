import 'package:flutter/material.dart';
import 'package:la_dinamica_app/config/theme/app_theme.dart';

class LoadingWidget extends StatefulWidget {
  final String loadingText;
  const LoadingWidget({
    super.key, 
    required this.loadingText
    });

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: colorList[5],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: Colors.black,),
              SizedBox(height: 20),
              Text(widget.loadingText,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black
                ),
              ),
            ],
          ),
        ),
      );
  }
}