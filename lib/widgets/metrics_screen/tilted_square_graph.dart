import 'package:flutter/material.dart';

class TiltedSquare extends StatelessWidget {
  final Color color;
  final double size;
  final bool glow;

  const TiltedSquare({
    super.key,
    required this.color,
    this.size = 20,
    this.glow = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _TiltedSquarePainter(color, glow),
    );
  }
}

class _TiltedSquarePainter extends CustomPainter {
  final Color color;
  final bool glow;

  _TiltedSquarePainter(this.color, this.glow);

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    path.moveTo(size.width * 0.4, 0); // top-left
    path.lineTo(size.width, 0);
    path.lineTo(size.width * 0.6, size.height);
    path.lineTo(0, size.height);
    path.close();

    // 🔹 Neon Glow Layer
    if (glow) {
      final glowPaint = Paint()
        ..shader = RadialGradient(
          colors: [color,Color.fromARGB(0, 23, 238, 16)],
          radius: 0.7,
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

      canvas.drawPath(path, glowPaint);
    }

    // 🔹 Solid Fill Layer
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
