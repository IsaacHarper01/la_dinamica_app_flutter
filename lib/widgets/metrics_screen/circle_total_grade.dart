import 'dart:math';
import 'package:flutter/material.dart';

class CircleTotalGrade extends CustomPainter {
  final double percent; // 0.0 .. 1.0
  final double strokeWidth;

  CircleTotalGrade({required this.percent, this.strokeWidth = 6});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (min(size.width, size.height) / 2) - (strokeWidth / 2);

    // Background ring
    final bgPaint = Paint()
      ..color = Colors.grey.shade800
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, bgPaint);

    if (percent <= 0) return;

    // Arc with gradient using a SweepGradient shader
    final rect = Rect.fromCircle(center: center, radius: radius);
    final startAngle = -pi / 2; // start at top
    final sweepAngle = 2 * pi * percent;

    final gradient = SweepGradient(
      startAngle: startAngle,
      endAngle: startAngle + sweepAngle,
      colors: [
        Colors.redAccent,
        Colors.orangeAccent,
        Colors.limeAccent,
        Colors.greenAccent,
      ],
    );

    final fgPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    // Draw arc
    canvas.drawArc(rect, startAngle, sweepAngle, false, fgPaint);

    // Optional subtle outer glow (small blurred stroke)
    final glowPaint = Paint()
      ..color = Colors.greenAccent.withOpacity(0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth * 1.6
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawArc(rect, startAngle, sweepAngle, false, glowPaint);
  }

  @override
  bool shouldRepaint(covariant CircleTotalGrade oldDelegate) {
    return oldDelegate.percent != percent || oldDelegate.strokeWidth != strokeWidth;
  }
}
