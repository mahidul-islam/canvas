import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';

const kCanvasSize = 300.0;

class DynamicFontLoadingInsideCanvas extends StatefulWidget {
  const DynamicFontLoadingInsideCanvas({Key? key}) : super(key: key);

  @override
  _DynamicFontLoadingInsideCanvasState createState() =>
      _DynamicFontLoadingInsideCanvasState();
}

class _DynamicFontLoadingInsideCanvasState
    extends State<DynamicFontLoadingInsideCanvas> {
  ui.Image? image;

  @override
  void initState() {
    _load('assets/img.png');
    super.initState();
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
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.greenAccent, width: 2)),
          width: kCanvasSize,
          height: kCanvasSize,
          child: CustomPaint(
            painter: BasicFontPaint(
              image: image,
            ),
            child: Container(),
          ),
        ),
      ),
      // ),
    );
  }
}

class BasicFontPaint extends CustomPainter {
  BasicFontPaint({this.image});
  final ui.Image? image;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRRect(ui.RRect.fromRectXY(
        Rect.fromPoints(
            Offset(0.0, 0.0), Offset(kCanvasSize - 4, kCanvasSize - 4)),
        0,
        0));
    Paint greenBrush = Paint()..color = Colors.greenAccent;

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
