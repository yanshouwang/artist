import 'dart:math';

import 'package:flutter/material.dart';

class PacMan extends StatefulWidget {
  PacMan({Key? key}) : super(key: key);

  @override
  _PacManState createState() => _PacManState();
}

class _PacManState extends State<PacMan> with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    controller.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(100.0, 100.0),
      painter: PacManPainter(controller),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class PacManPainter extends CustomPainter {
  final Animation<double> animation;

  PacManPainter(this.animation) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    //canvas.clipRect(Offset.zero & size);
    canvas.translate(size.width / 2.0, size.height / 2.0);
    drawHead(canvas, size);
    drawEye(canvas, size.width / 2.0);
  }

  @override
  bool shouldRepaint(covariant PacManPainter oldDelegate) {
    return false;
  }
}

extension on PacManPainter {
  void drawHead(Canvas canvas, Size size) {
    final begin = AngleColor(8.0, Colors.cyan);
    final end = AngleColor(40.0, Colors.amber);
    final tween = AngleColorTween(begin, end);
    final rect = Rect.fromCenter(
        center: Offset.zero, width: size.width, height: size.height);
    final startAngle = tween.evaluate(animation).angle * pi / 180.0;
    final sweepAngle = 2.0 * pi - startAngle.abs() * 2.0;
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = tween.evaluate(animation).color;
    canvas.drawArc(rect, startAngle, sweepAngle, true, paint);
  }

  void drawEye(Canvas canvas, double radius) {
    final c = Offset(0.15 * radius, -0.6 * radius);
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white;
    canvas.drawCircle(c, 0.12 * radius, paint);
  }
}

class AngleColor {
  final double angle;
  final Color color;

  AngleColor(this.angle, this.color);
}

class AngleColorTween extends Tween<AngleColor> {
  final AngleColor begin;
  final AngleColor end;

  AngleColorTween(this.begin, this.end) : super(begin: begin, end: end);

  @override
  AngleColor lerp(double t) {
    final angle = begin.angle + (end.angle - begin.angle) * t;
    final color = Color.lerp(begin.color, end.color, t)!;
    return AngleColor(angle, color);
  }
}
