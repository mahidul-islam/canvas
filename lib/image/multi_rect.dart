import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';

const kCanvasSize = 300.0;

class MultiRectRotatedAroundCenterPage extends StatefulWidget {
  const MultiRectRotatedAroundCenterPage({Key? key}) : super(key: key);

  @override
  _MultiRectRotatedAroundCenterPageState createState() =>
      _MultiRectRotatedAroundCenterPageState();
}

class _MultiRectRotatedAroundCenterPageState
    extends State<MultiRectRotatedAroundCenterPage> {
  ui.Image? image;
  var xPos = 0.0;
  var yPos = 0.0;
  final width = 100.0;
  final height = 100.0;
  bool _dragging = false;

  @override
  void initState() {
    _initCoOrdinate();
    _load('assets/img.png');
    super.initState();
  }

  /// Is the point (x, y) inside the rect?
  bool _insideRect(double x, double y) =>
      x >= xPos && x <= xPos + width && y >= yPos && y <= yPos + height;

  void _initCoOrdinate() {
    xPos = kCanvasSize - width - 20;
    yPos = 20;
    setState(() {});
  }

  void _load(String path) async {
    var bytes = await rootBundle.load(path);
    image = await decodeImageFromList(bytes.buffer.asUint8List());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onPanStart: (details) => _dragging = _insideRect(
            details.localPosition.dx,
            details.localPosition.dy,
          ),
          onPanEnd: (details) {
            _dragging = false;
          },
          onPanUpdate: (details) {
            if (_dragging) {
              setState(() {
                xPos += details.delta.dx;
                yPos += details.delta.dy;
              });
            }
          },
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.greenAccent, width: 2)),
            width: kCanvasSize,
            height: kCanvasSize,
            child: CustomPaint(
              painter: MultiRectPaint(
                  image: image, rect: Rect.fromLTWH(xPos, yPos, width, height)),
              child: Container(),
            ),
          ),
        ),
      ),
    );
  }
}

class MultiRectPaint extends CustomPainter {
  MultiRectPaint({this.image, required this.rect});
  final ui.Image? image;
  final Rect rect;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRRect(ui.RRect.fromRectXY(
      Rect.fromPoints(
          Offset(0.0, 0.0), Offset(kCanvasSize - 4, kCanvasSize - 4)),
      0,
      0,
    ));
    Paint whiteBrush = Paint()..color = Colors.white;
    Paint blackBrush = Paint()..color = Colors.black;
    Paint greenBrush = Paint()..color = Colors.greenAccent;
    Paint blueBrush = Paint()..color = Colors.lightBlueAccent.withOpacity(0.8);

    // Paint crossBrush = Paint()
    //   ..color = Colors.red
    //   ..style = PaintingStyle.stroke
    //   ..strokeWidth = 12;
    // canvas.drawLine(
    //     Offset(50, 50), Offset(size.width - 50, size.height - 50), crossBrush);
    // canvas.drawLine(
    //     Offset(size.width - 50, 50), Offset(50, size.height - 50), crossBrush);

    // Background Color
    // canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), blueBrush);
    // Static Or Background Things
    canvas.drawCircle(Offset(kCanvasSize, kCanvasSize), 20, greenBrush);
    canvas.drawCircle(Offset(0, 0), 20, blackBrush);
    if (image != null) {
      canvas.save();
      rotate(
          canvas: canvas,
          cx: image!.width.toDouble() / 2,
          cy: image!.height.toDouble() / 2,
          angle: -0.3);
      canvas.scale(kCanvasSize / image!.height);
      canvas.drawImage(image!, Offset(0, 0), greenBrush);
      canvas.restore();
    }
    canvas.save();
    rotate(canvas: canvas, cx: 150, cy: 0, angle: 0.5);
    canvas.drawRect(Rect.fromLTWH(130, 250, 40, 40), whiteBrush);
    canvas.restore();
    canvas.save();
    rotate(canvas: canvas, cx: 120, cy: 270, angle: 0.5);
    canvas.drawRect(Rect.fromLTWH(100, 250, 40, 40), whiteBrush);
    canvas.restore();

    // Draggable Rect
    canvas.drawRect(rect, blueBrush);
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
