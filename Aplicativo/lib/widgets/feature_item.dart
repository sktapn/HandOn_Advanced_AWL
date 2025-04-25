import 'package:flutter/material.dart';

class FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const FeatureItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(fontSize: 14, color: Color(0xFF666666)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
