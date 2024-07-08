import 'dart:math';

import 'package:flutter/material.dart';

class DottedEllipsePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final dashWidth = 5; // Width of each dash
    final dashSpace = 5; // Space between dashes

    double angle = 0;
    while (angle < 360) {
      final startX =
          size.width / 2 + size.width / 2 * cos(_degreesToRadians(angle));
      final startY =
          size.height / 2 + size.height / 2 * sin(_degreesToRadians(angle));
      final endX = size.width / 2 +
          (size.width / 2 + dashWidth) * cos(_degreesToRadians(angle));
      final endY = size.height / 2 +
          (size.height / 2 + dashWidth) * sin(_degreesToRadians(angle));

      canvas.drawLine(
        Offset(startX, startY),
        Offset(endX, endY),
        paint,
      );
      angle += dashWidth + dashSpace;
    }
  }

  double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
