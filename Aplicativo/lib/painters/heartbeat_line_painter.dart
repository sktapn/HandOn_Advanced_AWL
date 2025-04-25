import 'package:flutter/material.dart';

class HeartbeatLinePainter extends CustomPainter {
  final double progress;
  final Color color;

  HeartbeatLinePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = 2.0
          ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, size.height / 2);
    path.lineTo(size.width * 0.2, size.height / 2);

    if (progress > 0.2) {
      path.lineTo(size.width * 0.3, size.height * 0.3);
      path.lineTo(size.width * 0.35, size.height / 2);
      if (progress > 0.35) {
        path.lineTo(size.width * 0.4, size.height * 0.1);
        path.lineTo(size.width * 0.45, size.height * 0.9);
        path.lineTo(size.width * 0.5, size.height / 2);
      }
      if (progress > 0.5) path.lineTo(size.width * 0.7, size.height / 2);
      if (progress > 0.7) {
        path.lineTo(size.width * 0.75, size.height * 0.3);
        path.lineTo(size.width * 0.8, size.height / 2);
        path.lineTo(size.width * 0.85, size.height * 0.1);
        path.lineTo(size.width * 0.9, size.height * 0.9);
        path.lineTo(size.width * 0.95, size.height / 2);
        path.lineTo(size.width, size.height / 2);
      }
    }

    final clipPath =
        Path()
          ..moveTo(0, 0)
          ..lineTo(size.width * progress, 0)
          ..lineTo(size.width * progress, size.height)
          ..lineTo(0, size.height)
          ..close();

    canvas.clipPath(clipPath);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
