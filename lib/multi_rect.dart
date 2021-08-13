import 'package:flutter/material.dart';
import 'dart:ui' as ui;

const kCanvasSize = 300.0;

class MultiRectRotatedAroundCenterPage extends StatefulWidget {
  const MultiRectRotatedAroundCenterPage({Key? key}) : super(key: key);

  @override
  _MultiRectRotatedAroundCenterPageState createState() =>
      _MultiRectRotatedAroundCenterPageState();
}

class _MultiRectRotatedAroundCenterPageState
    extends State<MultiRectRotatedAroundCenterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          // color: Colors.amberAccent,
          width: kCanvasSize,
          height: kCanvasSize,
          child: CustomPaint(
            painter: MultiRectPaint(),
            child: Container(),
          ),
        ),
      ),
    );
  }
}

class MultiRectPaint extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRRect(ui.RRect.fromRectXY(
      Rect.fromPoints(Offset(0.0, 0.0), Offset(kCanvasSize, kCanvasSize)),
      0,
      0,
    ));
    Paint whiteBrush = Paint()..color = Colors.white;
    Paint blackBrush = Paint()..color = Colors.black;
    Paint greenBrush = Paint()..color = Colors.greenAccent;
    Paint blueBrush = Paint()..color = Colors.lightBlueAccent.withOpacity(0.1);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), blueBrush);
    canvas.drawCircle(Offset(kCanvasSize / 2, kCanvasSize / 2), 20, greenBrush);
    canvas.drawCircle(Offset(0, 0), 20, blackBrush);
    canvas.save();
    rotate(canvas: canvas, cx: 150, cy: 0, angle: 0.5);
    canvas.drawRect(Rect.fromLTWH(130, -20, 40, 40), whiteBrush);
    canvas.restore();
    canvas.save();
    rotate(canvas: canvas, cx: 120, cy: 270, angle: 0.5);
    canvas.drawRect(Rect.fromLTWH(100, 250, 40, 40), whiteBrush);
    canvas.restore();
  }

  void rotate(
      {required Canvas canvas,
      required double cx,
      required double cy,
      required double angle}) {
    canvas.translate(cx, cy);
    canvas.rotate(angle);
    canvas.translate(-cx, -cy);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
