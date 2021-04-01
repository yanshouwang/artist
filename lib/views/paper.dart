import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Paper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: FutureBuilder(
        future: loadImageFromAssetsAsync('#images/shoot.png'),
        builder: (context, AsyncSnapshot<ui.Image> snapshot) => snapshot.hasData
            ? CustomPaint(painter: GraphicPainter(snapshot.data!))
            : CustomPaint(painter: SimplePainter()),
      ),
    );
  }
}

extension CanvasX on Canvas {
  void center(Size size) {
    final dx = size.width / 2.0;
    final dy = size.height / 2.0;
    translate(dx, dy);
  }

  void drawBottomRightGrids(Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5
      ..color = Colors.grey;
    save();
    final width = size.width / 2.0;
    final height = size.height / 2.0;
    final step = 20.0;
    final horizontalCount = height / step;
    final p1 = Offset(0.0, 0.0);
    final p2 = Offset(width, 0.0);
    for (var i = 0; i < horizontalCount; i++) {
      drawLine(p1, p2, paint);
      translate(0.0, step);
    }
    restore();
    save();
    final verticalCount = width / step;
    final p3 = Offset(0.0, height);
    for (var i = 0; i < verticalCount; i++) {
      drawLine(p1, p3, paint);
      translate(step, 0.0);
    }
    restore();
  }

  void drawGrids(Size size) {
    save();
    drawBottomRightGrids(size);
    scale(1, -1);
    drawBottomRightGrids(size);
    restore();
    save();
    scale(-1, 1);
    drawBottomRightGrids(size);
    restore();
    save();
    scale(-1, -1);
    drawBottomRightGrids(size);
    restore();
  }

  void drawAxis(Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;
    final width = size.width / 2.0;
    final height = size.height / 2.0;
    final p1 = Offset(-width, 0.0);
    final p2 = Offset(width, 0.0);
    final p3 = Offset(width - 12.0, 8.0);
    final p4 = Offset(width - 12.0, -8.0);
    drawLine(p1, p2, paint);
    drawLine(p2, p3, paint);
    drawLine(p2, p4, paint);
    final p5 = Offset(0.0, -height);
    final p6 = Offset(0.0, height);
    final p7 = Offset(8.0, height - 12.0);
    final p8 = Offset(-8.0, height - 12.0);
    drawLine(p5, p6, paint);
    drawLine(p6, p7, paint);
    drawLine(p6, p8, paint);
  }

  void drawMarks(Size size) {
    final style = TextStyle(
      fontSize: 12.0,
      color: Colors.black,
      fontStyle: FontStyle.italic,
    );
    final width = size.width / 2.0;
    final height = size.height / 2.0;
    final step = 20.0;
    final horizontalCount = height / step;
    final verticalCount = width / step;
    // O
    final o = TextSpan(text: 'O', style: style.copyWith(color: Colors.blue));
    final painter = TextPainter(text: o, textDirection: TextDirection.ltr)
      ..layout();
    final oSize = painter.size;
    final offset = Offset(oSize.height / 2.0, oSize.height / 2.0);
    painter.paint(this, offset);
    // x+
    save();
    for (var i = 0; i < verticalCount; i++) {
      if (i != 0 && i.isEven) {
        final x = (i * step).toInt().toString();
        painter
          ..text = TextSpan(text: x, style: style)
          ..layout();
        final xSize = painter.size;
        final offset = Offset(-xSize.width / 2.0, xSize.height / 2.0);
        painter.paint(this, offset);
      }
      translate(step, 0.0);
    }
    restore();
    // x-
    save();
    for (var i = 0; i < verticalCount; i++) {
      if (i != 0 && i.isEven) {
        final x = (-i * step).toInt().toString();
        painter
          ..text = TextSpan(text: x, style: style)
          ..layout();
        final xSize = painter.size;
        final offset = Offset(-xSize.width / 2.0, xSize.height / 2.0);
        painter.paint(this, offset);
      }
      translate(-step, 0.0);
    }
    restore();
    // y+
    save();
    for (var i = 0; i < horizontalCount; i++) {
      if (i != 0 && i.isEven) {
        final y = (i * step).toInt().toString();
        painter
          ..text = TextSpan(text: y, style: style)
          ..layout();
        final ySize = painter.size;
        final offset = Offset(ySize.height / 2.0, -ySize.height / 2.0);
        painter.paint(this, offset);
      }
      translate(0.0, step);
    }
    restore();
    // y-
    save();
    for (var i = 0; i < horizontalCount; i++) {
      if (i != 0 && i.isEven) {
        final y = (-i * step).toInt().toString();
        painter
          ..text = TextSpan(text: y, style: style)
          ..layout();
        final ySize = painter.size;
        final offset = Offset(ySize.height / 2.0, -ySize.height / 2.0);
        painter.paint(this, offset);
      }
      translate(0.0, -step);
    }
    restore();
  }

  void drawItems() {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.blue;
    final c = Offset(0.0, 0.0);
    drawCircle(c, 40.0, paint);
    final p1 = Offset(20.0, 20.0);
    final p2 = Offset(40.0, 40.0);
    paint
      ..color = Colors.red
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    drawLine(p1, p2, paint);
  }

  void drawGridsPath(Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5
      ..color = Colors.grey;
    final width = size.width / 2.0;
    final height = size.height / 2.0;
    final step = 20.0;
    final horizontalCount = size.height / step;
    final verticalCount = size.width / step;
    // final path = Path()
    //   ..moveTo(-width, 0.0)
    //   ..lineTo(width, 0.0)
    //   ..moveTo(0.0, -height)
    //   ..lineTo(0.0, height);
    final path = Path();
    for (var i = 1; i < horizontalCount; i++) {
      path.moveTo(-width, i * step);
      path.relativeLineTo(size.width, 0.0);
      path.moveTo(-width, -i * step);
      path.relativeLineTo(size.width, 0.0);
    }
    for (var i = 1; i < verticalCount; i++) {
      path.moveTo(i * step, -height);
      path.relativeLineTo(0.0, size.height);
      path.moveTo(-i * step, -height);
      path.relativeLineTo(0.0, size.height);
    }
    drawPath(path, paint);
  }
}

class SimplePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    //drawAntiAlias(canvas);
    //drawStrokeWidth(canvas);
    //drawStrokeCap(canvas);
    //drawStrokeJoin(canvas);
    //drawStrokeMilterLimit(canvas);
    //drawInvertColors(canvas);
    canvas.center(size);
    //canvas.drawBottomRightGrids(size);
    //canvas.drawGrids(size);
    canvas.drawGridsPath(size);
    canvas.drawAxis(size);
    canvas.drawMarks(size);
    //canvas.drawItems();
    //drawDots(canvas);
    //drawRawPoints(canvas);
    //drawPoints(canvas);
    //drawRects(canvas);
    //drawRRects(canvas);
    //drawDRRects(canvas);
    //drawCircles(canvas);
    //drawColor(canvas);
    //drawPaint(canvas, size);
    //drawShadow(canvas);
    //drawPath(canvas);
    //clipRect(canvas, size);
    //clipRRect(canvas, size);
    //clipPath(canvas, size);
    //moveToAndLineTo(canvas);
    //relativeMoveToAndLineTo(canvas);
    //arcTo(canvas);
    //arcToPointAndRelativeArcToPoint(canvas);
    //conicToAndRelativeConicTo(canvas);
    //quadraticBezierToAndRelativeQuadraticBezierTo(canvas);
    //cubicToAndRelativeCubicTo(canvas);
    //addRectAndAddRRect(canvas);
    //addOvalAndAddArc(canvas);
    //addPolygonAndAddPath(canvas);
    //closeAndResetAndShift(canvas);
    //containsAndGetBounds(canvas);
    //transform(canvas);
    //combine(canvas);
    computeMetrics(canvas);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

extension SimpleX1 on SimplePainter {
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
}

extension SimpleX2 on SimplePainter {
  void drawDots(Canvas canvas) {
    canvas.save();
    final paint = Paint()
      ..color = Colors.orangeAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;
    final count = 12;
    final step = 2 * pi / count;
    final p1 = Offset(60.0, 0.0);
    final p2 = Offset(80.0, 0.0);
    for (var i = 0; i < count; i++) {
      canvas.drawLine(p1, p2, paint);
      canvas.rotate(step);
    }
    canvas.restore();
  }

  void drawPoints(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round;
    final pointMode = ui.PointMode.points;
    final points = <Offset>[
      Offset(-120.0, -20.0),
      Offset(-80.0, -80.0),
      Offset(-40.0, -40.0),
      Offset(0.0, -100.0),
      Offset(40.0, -140.0),
      Offset(80.0, -160.0),
      Offset(120.0, -100.0),
    ];
    canvas.drawPoints(pointMode, points, paint);
  }

  void drawRawPoints(Canvas canvas) {
    final pointMode = ui.PointMode.polygon;
    final points = Float32List.fromList(<double>[
      -120.0,
      -20.0,
      -80.0,
      -80.0,
      -40.0,
      -40.0,
      0.0,
      -100.0,
      40.0,
      -140.0,
      80.0,
      -160.0,
      120.0,
      -100.0,
    ]);
    final paint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;
    canvas.drawRawPoints(pointMode, points, paint);
  }

  void drawRects(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0;
    final center1 = Offset(0.0, 0.0);
    final rect1 = Rect.fromCenter(center: center1, width: 160.0, height: 160.0);
    canvas.drawRect(rect1, paint);
    final rect2 = Rect.fromLTRB(-120.0, -120.0, -80.0, -80.0);
    paint.color = Colors.red;
    canvas.drawRect(rect2, paint);
    final rect3 = Rect.fromLTWH(80.0, -120.0, 40.0, 40.0);
    paint.color = Colors.orange;
    canvas.drawRect(rect3, paint);
    final center2 = Offset(100.0, 100.0);
    final rect4 = Rect.fromCircle(center: center2, radius: 20.0);
    paint.color = Colors.green;
    canvas.drawRect(rect4, paint);
    final a = Offset(-120, 80);
    final b = Offset(-80, 120);
    final rect5 = Rect.fromPoints(a, b);
    paint.color = Colors.purple;
    canvas.drawRect(rect5, paint);
  }

  void drawRRects(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0;
    final center1 = Offset(0.0, 0.0);
    final rect1 = Rect.fromCenter(center: center1, width: 160.0, height: 160.0);
    final rrect1 = RRect.fromRectXY(rect1, 40.0, 20.0);
    canvas.drawRRect(rrect1, paint);
    final rrect2 = RRect.fromLTRBXY(-120.0, -120.0, -80.0, -80.0, 12.0, 12.0);
    paint.color = Colors.red;
    canvas.drawRRect(rrect2, paint);
    final radius3 = Radius.circular(12.0);
    final rrect3 = RRect.fromLTRBR(80.0, -120.0, 120.0, -80.0, radius3);
    paint.color = Colors.orange;
    canvas.drawRRect(rrect3, paint);
    final bottomRight = Radius.elliptical(12.0, 12.0);
    final rrect4 = RRect.fromLTRBAndCorners(80.0, 80.0, 120.0, 120.0,
        bottomRight: bottomRight);
    paint.color = Colors.green;
    canvas.drawRRect(rrect4, paint);
    final a = Offset(-120, 80);
    final b = Offset(-80, 120);
    final rect5 = Rect.fromPoints(a, b);
    final rrect5 = RRect.fromRectAndCorners(rect5, bottomLeft: bottomRight);
    paint.color = Colors.purple;
    canvas.drawRRect(rrect5, paint);
  }

  void drawDRRects(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0;
    final center = Offset(0.0, 0.0);
    final outerRect1 =
        Rect.fromCenter(center: center, width: 160.0, height: 160.0);
    final outer1 = RRect.fromRectXY(outerRect1, 20.0, 20.0);
    final innerRect1 =
        Rect.fromCenter(center: center, width: 100.0, height: 100.0);
    final inner1 = RRect.fromRectXY(innerRect1, 20.0, 20.0);
    canvas.drawDRRect(outer1, inner1, paint);
    final outerRect2 =
        Rect.fromCenter(center: center, width: 60.0, height: 60.0);
    final outer2 = RRect.fromRectXY(outerRect2, 16.0, 16.0);
    final innerRect2 =
        Rect.fromCenter(center: center, width: 40.0, height: 40.0);
    final inner2 = RRect.fromRectXY(innerRect2, 12.0, 12.0);
    paint.color = Colors.green;
    canvas.drawDRRect(outer2, inner2, paint);
  }

  void drawCircles(Canvas canvas) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.blue;
    final c = Offset(0.0, 0.0);
    canvas.save();
    canvas.translate(-200.0, 0.0);
    canvas.drawCircle(c, 60.0, paint);
    canvas.restore();

    final rect = Rect.fromCenter(center: c, width: 100.0, height: 120.0);
    canvas.drawOval(rect, paint);

    canvas.save();
    canvas.translate(200.0, 0.0);
    final sweepAngle = 3.0 * pi / 2.0;
    canvas.drawArc(rect, 0.0, sweepAngle, true, paint);
    canvas.restore();
  }

  void drawColor(Canvas canvas) {
    canvas.drawColor(Colors.red, BlendMode.lighten);
  }

  void drawPaint(Canvas canvas, Size size) {
    final colors = <Color>[
      Color(0xFFF60C0C),
      Color(0xFFF3B913),
      Color(0xFFE7F716),
      Color(0xFF3DF30B),
      Color(0xFF0DF6EF),
      Color(0xFF0829FB),
      Color(0xFFB709F4),
    ];
    final colorStops = <double>[
      1.0 / 7.0,
      2.0 / 7.0,
      3.0 / 7.0,
      4.0 / 7.0,
      5.0 / 7.0,
      6.0 / 7.0,
      1.0,
    ];
    final width = size.width / 2.0;
    final from = Offset(-width, 0.0);
    final to = Offset(width, 0.0);
    final paint = Paint()
      ..shader =
          ui.Gradient.linear(from, to, colors, colorStops, TileMode.clamp)
      ..blendMode = BlendMode.lighten;
    canvas.drawPaint(paint);
  }

  void drawShadow(Canvas canvas) {
    final path = Path()
      ..lineTo(80.0, 80.0)
      ..lineTo(-80.0, 80.0)
      ..close();
    canvas.drawShadow(path, Colors.red, 4.0, true);
    canvas.save();
    canvas.translate(200.0, 0.0);
    canvas.drawShadow(path, Colors.red, 4.0, false);
    canvas.restore();
  }

  void drawPath(Canvas canvas) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.blue;
    final path = Path()
      ..lineTo(60.0, 60.0)
      ..lineTo(-60.0, 60.0)
      ..lineTo(60.0, -60.0)
      ..lineTo(-60.0, -60.0)
      ..close();
    canvas.drawPath(path, paint);
    canvas.save();
    canvas.translate(140.0, 0.0);
    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  void clipRect(Canvas canvas, Size size) {
    final rect =
        Rect.fromCenter(center: Offset.zero, width: 360.0, height: 240.0);
    canvas.save();
    canvas.clipRect(rect);
    final colors = <Color>[
      Color(0xFFF60C0C),
      Color(0xFFF3B913),
      Color(0xFFE7F716),
      Color(0xFF3DF30B),
      Color(0xFF0DF6EF),
      Color(0xFF0829FB),
      Color(0xFFB709F4),
    ];
    final colorStops = <double>[
      1.0 / 7.0,
      2.0 / 7.0,
      3.0 / 7.0,
      4.0 / 7.0,
      5.0 / 7.0,
      6.0 / 7.0,
      1.0,
    ];
    final width = size.width / 2.0;
    final from = Offset(-width, 0.0);
    final to = Offset(width, 0.0);
    final paint = Paint()
      ..shader = ui.Gradient.linear(from, to, colors, colorStops)
      ..blendMode = BlendMode.lighten;
    canvas.drawPaint(paint);
    canvas.restore();
  }

  void clipRRect(Canvas canvas, Size size) {
    canvas.save();
    final rect =
        Rect.fromCenter(center: Offset.zero, width: 200.0, height: 100.0);
    final radius = Radius.circular(20.0);
    final rrect = RRect.fromRectAndRadius(rect, radius);
    canvas.clipRRect(rrect);
    canvas.drawColor(Colors.red, BlendMode.darken);
    canvas.restore();
  }

  void clipPath(Canvas canvas, Size size) {
    canvas.save();
    final path = Path()
      ..lineTo(80.0, 80.0)
      ..lineTo(-80.0, 80.0)
      ..close();
    canvas.clipPath(path);
    canvas.drawColor(Colors.red, BlendMode.darken);
    canvas.restore();
  }
}

extension SimpleX3 on SimplePainter {
  void moveToAndLineTo(Canvas canvas) {
    final path = Path()
      ..moveTo(0.0, 0.0)
      ..lineTo(60.0, 80.0)
      ..lineTo(60.0, 0.0)
      ..lineTo(0.0, -80.0)
      ..close();
    final paint = Paint()
      ..color = Colors.deepPurpleAccent
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, paint);

    path
      ..moveTo(0.0, 0.0)
      ..lineTo(-60.0, 80.0)
      ..lineTo(-60.0, 0.0)
      ..lineTo(0.0, -80.0)
      ..close();
    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawPath(path, paint);
  }

  void relativeMoveToAndLineTo(Canvas canvas) {
    final path = Path()
      ..relativeMoveTo(0.0, 0.0)
      ..relativeLineTo(100.0, 120.0)
      ..relativeLineTo(-12.0, -60.0)
      ..relativeLineTo(60.0, -8.0)
      ..close();
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.green;
    canvas.drawPath(path, paint);

    path
      ..reset()
      ..relativeMoveTo(-200.0, 0.0)
      ..relativeLineTo(100.0, 120.0)
      ..relativeLineTo(-12.0, -60.0)
      ..relativeLineTo(60.0, -8.0)
      ..close();
    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawPath(path, paint);
  }

  void arcTo(Canvas canvas) {
    final rect =
        Rect.fromCenter(center: Offset.zero, width: 160.0, height: 100.0);
    final path = Path()
      ..lineTo(32.0, 32.0)
      ..arcTo(rect, 0.0, 1.5 * pi, true);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.purpleAccent;
    canvas.drawPath(path, paint);

    canvas.save();
    canvas.translate(200.0, 0.0);
    path
      ..reset()
      ..lineTo(32.0, 32.0)
      ..arcTo(rect, 0.0, 1.5 * pi, false);
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  void arcToPointAndRelativeArcToPoint(Canvas canvas) {
    canvas.save();
    canvas.translate(0.0, -160.0);
    final arcEnd = Offset(40.0, 40.0);
    final radius = Radius.circular(60.0);
    final path = Path()
      ..lineTo(80.0, -40.0)
      ..arcToPoint(
        arcEnd,
        radius: radius,
        largeArc: false,
        clockwise: true,
      )
      ..close();
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.purpleAccent;
    canvas.drawPath(path, paint);
    canvas.restore();

    canvas.save();
    canvas.translate(0.0, 160.0);
    path
      ..reset()
      ..lineTo(80.0, -40.0)
      ..arcToPoint(
        arcEnd,
        radius: radius,
        largeArc: false,
        clockwise: false,
      )
      ..close();
    canvas.drawPath(path, paint);
    canvas.restore();

    canvas.save();
    canvas.translate(-160.0, 0.0);
    path
      ..reset()
      ..lineTo(80.0, -40.0)
      ..arcToPoint(
        arcEnd,
        radius: radius,
        largeArc: true,
        clockwise: false,
      )
      ..close();
    canvas.drawPath(path, paint);
    canvas.restore();

    canvas.save();
    canvas.translate(160.0, 0.0);
    path
      ..reset()
      ..lineTo(80.0, -40.0)
      ..arcToPoint(
        arcEnd,
        radius: radius,
        largeArc: true,
        clockwise: true,
      )
      ..close();
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  void conicToAndRelativeConicTo(Canvas canvas) {
    final path = Path()..conicTo(80.0, -100.0, 160.0, 0.0, 1.0);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.purpleAccent;
    canvas.drawPath(path, paint);

    canvas.save();
    canvas.translate(-200.0, 0.0);
    path
      ..reset()
      ..conicTo(80.0, -100.0, 160.0, 0.0, 0.5);
    canvas.drawPath(path, paint);
    canvas.restore();

    canvas.save();
    canvas.translate(200.0, 0.0);
    path
      ..reset()
      ..conicTo(80.0, -100.0, 160.0, 0.0, 1.5);
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  void quadraticBezierToAndRelativeQuadraticBezierTo(Canvas canvas) {
    final path = Path()
      ..quadraticBezierTo(100.0, -100.0, 160.0, 40.0)
      ..relativeQuadraticBezierTo(100.0, -100.0, 160.0, 40.0);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.purpleAccent;
    canvas.drawPath(path, paint);
  }

  void cubicToAndRelativeCubicTo(Canvas canvas) {
    final path = Path()
      ..cubicTo(80.0, -100.0, 100.0, 80.0, 160.0, 60.0)
      ..relativeCubicTo(80.0, -100.0, 100.0, 80.0, 160.0, 60.0);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.purpleAccent;
    canvas.drawPath(path, paint);
  }

  void addRectAndAddRRect(Canvas canvas) {
    final a = Offset(100.0, 100.0);
    final b = Offset(160.0, 160.0);
    final rect = Rect.fromPoints(a, b);
    final rrect = RRect.fromRectXY(rect.translate(100.0, -100.0), 12.0, 12.0);
    final path = Path()
      ..lineTo(100.0, 100.0)
      ..addRect(rect)
      ..relativeLineTo(100.0, -100.0)
      ..addRRect(rrect);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.purpleAccent;
    canvas.drawPath(path, paint);
  }

  void addOvalAndAddArc(Canvas canvas) {
    final a = Offset(100.0, 100.0);
    final b = Offset(160.0, 140.0);
    final oval1 = Rect.fromPoints(a, b);
    final oval2 = oval1.translate(160.0, -100.0);
    final path = Path()
      ..lineTo(100.0, 100.0)
      ..addOval(oval1)
      ..relativeLineTo(100.0, -100.0)
      ..addArc(oval2, 0.0, pi);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.purpleAccent;
    canvas.drawPath(path, paint);
  }

  void addPolygonAndAddPath(Canvas canvas) {
    final path0 = Path()..relativeQuadraticBezierTo(125.0, -100.0, 260.0, 0.0);
    final point = Offset(100.0, 100.0);
    final points = <Offset>[
      point,
      point.translate(20.0, -20.0),
      point.translate(40, -20),
      point.translate(60, 0),
      point.translate(60, 20),
      point.translate(40, 40),
      point.translate(20, 40),
      point.translate(0, 20),
    ];
    final path1 = Path()
      ..lineTo(100.0, 100.0)
      ..addPolygon(points, true)
      ..addPath(path0, Offset.zero)
      ..lineTo(160.0, 100.0);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.purpleAccent;
    canvas.drawPath(path1, paint);
  }
}

extension SimpleX4 on SimplePainter {
  void closeAndResetAndShift(Canvas canvas) {
    final path1 = Path()
      ..lineTo(100.0, 100.0)
      ..relativeLineTo(0.0, -50.0)
      ..close();
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.purpleAccent;
    canvas.drawPath(path1, paint);
    final offset = Offset(100.0, 0.0);
    final path2 = path1.shift(offset);
    canvas.drawPath(path2, paint);
    final path3 = path2.shift(offset);
    canvas.drawPath(path3, paint);
  }

  void containsAndGetBounds(Canvas canvas) {
    final path = Path()
      ..relativeLineTo(-32.0, 120.0)
      ..relativeLineTo(32.0, -32.0)
      ..relativeLineTo(32.0, 32.0)
      ..close();
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.purple;
    canvas.drawPath(path, paint);

    final point1 = Offset(20.0, 20.0);
    final judgement1 = path.contains(point1);
    print(judgement1);
    final point2 = Offset(0.0, 20.0);
    final judgement2 = path.contains(point2);
    print(judgement2);

    final bounds = path.getBounds();
    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = Colors.orange;
    canvas.drawRect(bounds, paint);
  }

  void transform(Canvas canvas) {
    final path = Path()
      ..relativeLineTo(-32.0, 120.0)
      ..relativeLineTo(32.0, -32.0)
      ..relativeLineTo(32.0, 32.0)
      ..close();
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.purple;
    for (var i = 0; i < 8; i++) {
      final matrix4 = Matrix4.rotationZ(i * pi / 4.0).storage;
      final transform = path.transform(matrix4);
      canvas.drawPath(transform, paint);
    }
  }

  void combine(Canvas canvas) {
    final path1 = Path()
      ..relativeLineTo(-32.0, 120.0)
      ..relativeLineTo(32.0, -32.0)
      ..relativeLineTo(32.0, 32.0)
      ..close();
    final oval =
        Rect.fromCenter(center: Offset.zero, width: 60.0, height: 60.0);
    final path2 = Path()..addOval(oval);
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.purple;
    final combined1 = Path.combine(PathOperation.difference, path1, path2);
    canvas.drawPath(combined1, paint);
    canvas.save();
    canvas.translate(120.0, 0.0);
    final combined2 = Path.combine(PathOperation.intersect, path1, path2);
    canvas.drawPath(combined2, paint);
    canvas.translate(120.0, 0.0);
    final combined3 =
        Path.combine(PathOperation.reverseDifference, path1, path2);
    canvas.drawPath(combined3, paint);
    canvas.restore();
    canvas.save();
    canvas.translate(-120.0, 0.0);
    final combined4 = Path.combine(PathOperation.union, path1, path2);
    canvas.drawPath(combined4, paint);
    canvas.translate(-120.0, 0.0);
    final combined5 = Path.combine(PathOperation.xor, path1, path2);
    canvas.drawPath(combined5, paint);
    canvas.restore();
  }

  void computeMetrics(Canvas canvas) {
    final oval =
        Rect.fromCenter(center: Offset.zero, width: 60.0, height: 60.0);
    final path = Path()
      ..relativeLineTo(-32.0, 120.0)
      ..relativeLineTo(32.0, -32.0)
      ..relativeLineTo(32.0, 32.0)
      ..close()
      ..addOval(oval);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = Colors.purpleAccent;
    canvas.drawPath(path, paint);
    paint
      ..style = PaintingStyle.fill
      ..color = Colors.deepOrange;
    final metrics = path.computeMetrics();
    for (var metric in metrics) {
      print(metric);
      final tangent = metric.getTangentForOffset(metric.length * 0.5);
      canvas.drawCircle(tangent!.position, 4.0, paint);
    }
  }
}

class GraphicPainter extends CustomPainter {
  final ui.Image image;

  GraphicPainter(this.image);

  @override
  void paint(ui.Canvas canvas, Size size) {
    canvas.center(size);
    canvas.drawGrids(size);
    canvas.drawAxis(size);
    canvas.drawMarks(size);
    // drawImage(canvas);
    // drawImageRect(canvas);
    //drawImageNine(canvas);
    //drawAtlas(canvas);
    //drawParagraph(canvas, TextAlign.right);
    //textPainter(canvas);
    //textPainterStyle(canvas);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

extension GraphicX on GraphicPainter {
  void drawImage(Canvas canvas) {
    final dx = -image.width / 2.0;
    final dy = -image.height / 2.0;
    final offset = Offset(dx, dy);
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.blue;
    canvas.drawImage(image, offset, paint);
  }

  void drawImageRect(Canvas canvas) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.blue;
    final dx = image.width / 2.0;
    final dy = image.height / 2.0;
    final center1 = Offset(dx, dy);
    final src1 = Rect.fromCenter(center: center1, width: 60.0, height: 60.0);
    final dst1 = Rect.fromLTRB(0.0, 0.0, 100.0, 100.0).translate(200.0, 0.0);
    canvas.drawImageRect(image, src1, dst1, paint);
    final center2 = Offset(dx, dy - 60.0);
    final src2 = Rect.fromCenter(center: center2, width: 60.0, height: 60.0);
    final dst2 =
        Rect.fromLTRB(0.0, 0.0, 100.0, 100.0).translate(-280.0, -100.0);
    canvas.drawImageRect(image, src2, dst2, paint);
    final center3 = Offset(dx + 60.0, dy);
    final src3 = Rect.fromCenter(center: center3, width: 60.0, height: 60.0);
    final dst3 = Rect.fromLTRB(0.0, 0.0, 100.0, 100.0).translate(-280.0, 50.0);
    canvas.drawImageRect(image, src3, dst3, paint);
  }

  void drawImageNine(Canvas canvas) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.blue;
    final dx = image.width / 2.0;
    final dy = image.height - 6.0;
    final center = Rect.fromCenter(
        center: Offset(dx, dy), width: image.width - 20.0, height: 2.0);
    final dst1 =
        Rect.fromCenter(center: Offset.zero, width: 300.0, height: 120.0);
    canvas.drawImageNine(image, center, dst1, paint);
    final dst2 =
        Rect.fromCenter(center: Offset.zero, width: 100.0, height: 48.0)
            .translate(240.0, 0.0);
    canvas.drawImageNine(image, center, dst2, paint);
    final dst3 =
        Rect.fromCenter(center: Offset.zero, width: 80.0, height: 250.0)
            .translate(-240.0, 0.0);
    canvas.drawImageNine(image, center, dst3, paint);
  }

  void drawAtlas(Canvas canvas) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.blue;
    final sprites = <Sprite>[];
    final position = Rect.fromLTWH(0.0, 324.0, 256.0, 168.0);
    final sprite = Sprite(position, Offset.zero, 0.0, 255);
    sprites.add(sprite);
    final transforms = sprites
        .map((e) => RSTransform.fromComponents(
            rotation: e.rotation,
            scale: 1.0,
            anchorX: 0.0,
            anchorY: 0.0,
            translateX: sprite.offset.dx,
            translateY: sprite.offset.dy))
        .toList();
    final rects = sprites.map((e) => e.position).toList();
    canvas.drawAtlas(image, transforms, rects, null, null, null, paint);
  }

  void drawParagraph(Canvas canvas, TextAlign textAlign) {
    final paragraphStyle = ui.ParagraphStyle(
      textAlign: textAlign,
      fontSize: 40.0,
      textDirection: TextDirection.ltr,
      maxLines: 1,
    );
    final textStyle = ui.TextStyle(
      color: Colors.black87,
      textBaseline: TextBaseline.alphabetic,
    );
    final builder = ui.ParagraphBuilder(paragraphStyle)
      ..pushStyle(textStyle)
      ..addText('Artist');
    final paragraph = builder.build();
    paragraph.layout(ui.ParagraphConstraints(width: 300.0));
    canvas.drawParagraph(paragraph, Offset.zero);
    final rect = Rect.fromLTRB(0.0, 0.0, 300.0, 40.0);
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.blue.withAlpha(32);
    canvas.drawRect(rect, paint);
  }

  void textPainter(Canvas canvas) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'Artist',
        style: TextStyle(fontSize: 40.0, color: Colors.black),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    final size = textPainter.size;
    final dx = -size.width / 2.0;
    final dy = -size.height / 2.0;
    final offset = Offset(dx, dy);
    textPainter.paint(canvas, offset);
    final rect =
        Rect.fromLTRB(0.0, 0.0, size.width, size.height).translate(dx, dy);
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.blue.withAlpha(32);
    canvas.drawRect(rect, paint);
  }

  void textPainterStyle(Canvas canvas) {
    final textPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'Artist',
        style: TextStyle(fontSize: 40.0, foreground: textPaint),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(maxWidth: 280.0);
    final size = textPainter.size;
    final dx = -size.width / 2.0;
    final dy = -size.height / 2.0;
    final offset = Offset(dx, dy);
    textPainter.paint(canvas, offset);
    final rect =
        Rect.fromLTRB(0.0, 0.0, size.width, size.height).translate(dx, dy);
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.blue.withAlpha(32);
    canvas.drawRect(rect, paint);
  }
}

class Sprite {
  final Rect position;
  final Offset offset;
  final double rotation;
  final int alpha;

  Sprite(this.position, this.offset, this.rotation, this.alpha);
}

Future<ui.Image> loadImageFromAssetsAsync(String path) async {
  final data = await rootBundle.load(path);
  final bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  return decodeImageFromList(bytes);
}
