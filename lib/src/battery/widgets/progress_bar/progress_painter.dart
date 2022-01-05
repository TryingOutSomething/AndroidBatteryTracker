import 'dart:math' as math;

import 'package:flutter/material.dart';

class ProgressPainter extends CustomPainter {
  final double percentage;
  final double strokeWidth;
  final Color circleColour;

  ProgressPainter({
    required this.percentage,
    required this.circleColour,
    double? strokeWidth,
  }) : strokeWidth = strokeWidth ?? 4;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = size.center(Offset.zero);
    final Size constrainedSize =
        (size - Offset(strokeWidth, strokeWidth)) as Size;
    final shortestSide =
        math.min(constrainedSize.width, constrainedSize.height);
    final foregroundPaint = Paint()
      ..color = circleColour
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final radius = shortestSide / 2;

    final startAngle = -(2 * math.pi * 0.25);
    final sweepAngle = 2 * math.pi * percentage;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      foregroundPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    final oldPainter = oldDelegate as ProgressPainter;

    return oldPainter.percentage != percentage ||
        oldPainter.strokeWidth != strokeWidth ||
        oldPainter.circleColour != circleColour;
  }
}
