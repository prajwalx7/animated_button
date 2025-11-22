import 'package:flutter/material.dart';

class AnimatedButtonPainter extends CustomPainter {
  final Color color;
  final double bumpFactor;

  AnimatedButtonPainter({required this.color, required this.bumpFactor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final double pillHeight = 46.0;
    final double topOffset = 22.0;
    final double mainWidth = size.width - 14;

    final RRect mainPill = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, topOffset, mainWidth, pillHeight),
      Radius.circular(pillHeight / 2),
    );

    Path path = Path()..addRRect(mainPill);

    if (bumpFactor > 0) {
      final double bumpRadius = 12.0 * bumpFactor;
      final Offset bumpCenter = Offset(mainWidth - 15.0, topOffset + 5.0);

      final Path bumpPath = Path()
        ..addOval(Rect.fromCircle(center: bumpCenter, radius: bumpRadius));

      path = Path.combine(PathOperation.union, path, bumpPath);
    }

    canvas.drawShadow(path, Colors.black.withValues(alpha: 0.2), 6.0, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant AnimatedButtonPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.bumpFactor != bumpFactor;
  }
}
