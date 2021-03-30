import 'package:flutter/material.dart';

class Paper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: CustomPaint(
        painter: PaperPainter(),
      ),
    );
  }
}

class PaperPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    //drawAntiAlias(canvas);
    //drawStrokeWidth(canvas);
    //drawStrokeCap(canvas);
    //drawStrokeJoin(canvas);
    //drawStrokeMilterLimit(canvas);
    drawInvertColors(canvas);
  }

  void drawAntiAlias(Canvas canvas) {
    final paint = Paint()
      ..strokeWidth = 4.0
      ..color = Colors.blue
      ..isAntiAlias = true;
    final c1 = Offset(200.0, 200.0);
    canvas.drawCircle(c1, 160.0, paint);
    final c2 = c1.translate(400.0, 0.0);
    paint
      ..color = Colors.red
      ..isAntiAlias = false;
    canvas.drawCircle(c2, 160.0, paint);
  }

  void drawStrokeWidth(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 50.0
      ..style = PaintingStyle.stroke;
    final c1 = Offset(200.0, 200.0);
    canvas.drawCircle(c1, 160.0, paint);
    final c2 = c1.translate(400.0, 0.0);
    paint..style = PaintingStyle.fill;
    canvas.drawCircle(c2, 160.0, paint);
  }

  void drawStrokeCap(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 20.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt;
    final p1 = Offset(40.0, 40.0);
    final p2 = p1.translate(0.0, 100.0);
    canvas.drawLine(p1, p2, paint);
    final p3 = p1.translate(40.0, 0.0);
    final p4 = p2.translate(40.0, 0.0);
    paint.strokeCap = StrokeCap.round;
    canvas.drawLine(p3, p4, paint);
    final p5 = p3.translate(40.0, 0.0);
    final p6 = p4.translate(40.0, 0.0);
    paint.strokeCap = StrokeCap.square;
    canvas.drawLine(p5, p6, paint);
  }

  void drawStrokeJoin(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 20.0
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.bevel;
    final path1 = Path()
      ..moveTo(40.0, 40.0)
      ..lineTo(40.0, 120.0)
      ..relativeLineTo(80.0, -40.0)
      ..relativeLineTo(0.0, 80.0);
    canvas.drawPath(path1, paint);
    final offset = Offset(120.0, 0.0);
    final path2 = path1.shift(offset);
    paint.strokeJoin = StrokeJoin.miter;
    canvas.drawPath(path2, paint);
    final path3 = path2.shift(offset);
    paint.strokeJoin = StrokeJoin.round;
    canvas.drawPath(path3, paint);
  }

  void drawStrokeMilterLimit(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 20.0
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.miter
      ..strokeMiterLimit = 2.0;
    for (var i = 0; i < 3; i++) {
      final path = Path()
        ..moveTo(40.0 + 120.0 * i, 40.0)
        ..lineTo(40.0 + 120.0 * i, 120.0)
        ..relativeLineTo(80.0, -20.0 - 40.0 * i);
      canvas.drawPath(path, paint);
    }
    paint.strokeMiterLimit = 3;
    for (var i = 0; i < 3; i++) {
      final path = Path()
        ..moveTo(40.0 + 120.0 * i, 40.0 + 120.0)
        ..lineTo(40.0 + 120.0 * i, 120.0 + 120.0)
        ..relativeLineTo(80.0, -20.0 - 40.0 * i);
      canvas.drawPath(path, paint);
    }
  }

  void drawInvertColors(Canvas canvas) {
    final paint = Paint()
      ..color = Color(0xff009A44)
      ..invertColors = false;
    final c1 = Offset(80.0, 80.0);
    canvas.drawCircle(c1, 40.0, paint);
    final c2 = c1.translate(100.0, 0.0);
    paint.invertColors = true;
    canvas.drawCircle(c2, 40.0, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
