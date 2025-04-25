import 'package:flutter/material.dart';

class MedicalPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = const Color(0xFF0277BD).withOpacity(0.1)
          ..strokeWidth = 1.0
          ..style = PaintingStyle.stroke;

    const spacing = 40.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawLine(Offset(x - 5, y), Offset(x + 5, y), paint);
        canvas.drawLine(Offset(x, y - 5), Offset(x, y + 5), paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
