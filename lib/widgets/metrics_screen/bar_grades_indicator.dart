import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/widgets/metrics_screen/circle_total_grade.dart';
import 'package:la_dinamica_app/widgets/tilted_square_graph.dart';

class StatBar extends ConsumerStatefulWidget {
  
  final String label;
  final double filled;
  final int total;

  const StatBar({
    super.key,
    required this.label,
    required this.filled,
    this.total = 10,
    });

  @override
  ConsumerState <StatBar> createState() => _StatBarState();
}

class _StatBarState extends ConsumerState <StatBar> {
  
  @override
  Widget build(BuildContext context) {
    final filledRounded = double.parse(widget.filled.toStringAsFixed(2));
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(
            widget.label,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
        Expanded(
          child: Row(
            children: List.generate(widget.total, (index) {
              Color color;
              bool glow = false;

              if (index < filledRounded) {
                if (index < 5) {
                  color = const Color.fromARGB(255, 23, 126, 95);
                } else {
                  color = const Color.fromARGB(255, 23, 126, 95);
                  glow = true; // neon glow only for green
                }
              } else {
                color = Colors.grey.shade800;
              }

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.5),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // compute a reasonable square size from available width
                      final tileSize = min(constraints.maxWidth, 22.0);
                      return SizedBox(
                        height: 28, // gives the tile a fixed height region
                        child: Center(
                          child: TiltedSquare(color: color, size: tileSize, glow: glow),
                        ),
                      );
                    },
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(width: 10),
         SizedBox(
          height: 50,
          width: 50,
          child: CustomPaint(
            painter: CircleTotalGrade(
              percent: widget.total == 0 ? 0 : (filledRounded / widget.total),
              strokeWidth: 6,
            ),
            // optional child to show the numeric value centered
            child: Center(
              child: Text(
                '$filledRounded',
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
