import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:la_dinamica_app/config/theme/app_theme.dart';

class BoxInfoWidget extends StatefulWidget {
  final double screenWidth;
  final double planData;
  final double productData;
  final String date;
  final String text;
  const BoxInfoWidget({
    super.key,
    required this.screenWidth,
    required this.planData,
    required this.productData,
    required this.date,
    required this.text
    });

  @override
  State<BoxInfoWidget> createState() => _BoxInfoWidgetState();
}

class _BoxInfoWidgetState extends State<BoxInfoWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
                height: 130,
                width: widget.screenWidth * 0.9,
                decoration: BoxDecoration(
                  color: colorList[3],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        widget.text,
                        style: GoogleFonts.michroma(color: Colors.white),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Ingresos de planes: ',
                            style: GoogleFonts.michroma(color: Colors.white),
                          ),
                          Text(
                            '\$${widget.planData.toString()}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Ingresos de productos: ',
                            style: GoogleFonts.michroma(color: Colors.white),
                          ),
                          Text(
                            '\$${widget.productData.toString()}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      const Divider(height: 0, indent: 20, endIndent: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total: ',
                            style: GoogleFonts.michroma(color: Colors.white),
                          ),
                          Text(
                            '\$${(widget.planData+widget.productData).toString()}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
  }
}