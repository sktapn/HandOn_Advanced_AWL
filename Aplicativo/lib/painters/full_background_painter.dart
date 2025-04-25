import 'package:flutter/material.dart';

class FullBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 1) Preenche todo o fundo com um gradiente (aqui usamos uma cor única, mas você pode personalizar)
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final gradientPaint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xFFF5F7FA),
          Color(0xFFF5F7FA),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(rect);
    canvas.drawRect(rect, gradientPaint);

    // 2) Desenha uma onda no topo
    final topPath = Path();
    topPath.moveTo(0, 0);
    topPath.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.10,
      size.width * 0.5,
      size.height * 0.07,
    );
    topPath.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.05,
      size.width,
      size.height * 0.15,
    );
    topPath.lineTo(size.width, 0);
    topPath.close();

    final topPaint = Paint()..color = const Color(0xFF0277BD).withOpacity(0.15);
    canvas.drawPath(topPath, topPaint);

    // 3) Desenha uma onda na base
    final bottomPath = Path();
    bottomPath.moveTo(0, size.height);
    bottomPath.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.90,
      size.width * 0.5,
      size.height * 0.95,
    );
    bottomPath.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.99,
      size.width,
      size.height * 0.90,
    );
    bottomPath.lineTo(size.width, size.height);
    bottomPath.close();

    final bottomPaint = Paint()
      ..color = const Color(0xFF4CAF50).withOpacity(0.15);
    canvas.drawPath(bottomPath, bottomPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
