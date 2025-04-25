import 'package:flutter/material.dart';

class HealthIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Offset position;
  final double size;

  const HealthIcon({
    Key? key,
    required this.icon,
    required this.color,
    required this.position,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top:
          position.dy < 0
              ? MediaQuery.of(context).size.height + position.dy
              : position.dy,
      child: Opacity(
        opacity: 0.15,
        child: Icon(icon, color: color, size: size),
      ),
    );
  }
}
